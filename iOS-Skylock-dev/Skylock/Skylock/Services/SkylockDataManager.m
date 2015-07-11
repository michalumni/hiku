//
//  SkylockDataManager.m
//  Skylock
//
//  Created by Daniel Ondruj on 24.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import "SkylockDataManager.h"
#import "CoreDataService.h"

@implementation SkylockDataManager

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

+ (SkylockDataManager*)sharedInstance
{
    static SkylockDataManager* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SkylockDataManager alloc] init];
    });
    
    return instance;
}

+ (void)setupUsers {
    // creates user if empty
    CDUsers* users = [[CoreDataService sharedInstance] coreDataObjectForClass:[CDUsers class] create:YES];
	[[SkylockDataManager sharedInstance] setUsers:users];
    
    [[SkylockDataManager sharedInstance] loadUserSession];
}

-(void)setUser:(CDUser *)user
{
    _user = user;
    CDLock *lock = [[SkylockDataManager sharedInstance] getDefaultLock];
    if(lock)
        [[SkylockDataManager sharedInstance] reconnectLock:lock];
}

-(void)loadUserSession
{
    for (CDUser *user in _users.users)
    {
        if((user.api_token != nil) && ([user.api_token length] > 0))
        {
            [self setUser:user];
        }
    }
}

-(void)logoutUserSession
{
    _user.api_token = nil;
    
    //sync
    [[CoreDataService sharedInstance] saveContext];
    
    _user = nil;
}

-(CDUser *)getUserWithID:(NSString *)userID
{
    for (CDUser *user in _users.users)
    {
        if([user.user_id isEqualToString:userID])
        {
            return user;
        }
    }
    
    return nil;
}

-(void)openUserSessionWithDataDictionary:(NSDictionary *)dictionary withXAppToken:(NSString *)XAppToken
{
    NSString *userID = [dictionary objectForKey:@"user_id"];
    
    CDUser *user = [[SkylockDataManager sharedInstance] getUserWithID:userID];
    if(user == nil)
    {
        user = [[CoreDataService sharedInstance] getNewCoreDataObjectForClass:[CDUser class]];
        user.inDatabase = [[SkylockDataManager sharedInstance] users];
    }
    
    //    "user_id": 1,
    //    "first_name": "Name",
    //    "last_name": "Surname",
    //    "phone": "123456789",
    //    "email": "name@example.com",
    //    "gender": "male",
    //    "password": "1234",
    //    "birth": "2/23/1980",
    //    "avatar_url": "https://image/Avatar/user_id.png"
    
    user.api_token = XAppToken;
    user.user_id = [dictionary objectForKey:@"user_id"];
    user.first_name = [dictionary objectForKey:@"first_name"];
    user.last_name = [dictionary objectForKey:@"last_name"];
    user.phone = [dictionary objectForKey:@"phone"];
    user.email = [dictionary objectForKey:@"email"];
    user.gender = [dictionary objectForKey:@"gender"];
    user.passwod = [dictionary objectForKey:@"password"];
    user.birth = [dictionary objectForKey:@"birth"];
    user.avatarURL = [dictionary objectForKey:@"avatar_url"];
    user.avatar = nil;
    
    //sync
    [[CoreDataService sharedInstance] saveContext];
    
    [self setUser:user];
}

-(void)updateUserWithDataDictionary:(NSDictionary *)dictionary
{
    NSString *userID = [dictionary objectForKey:@"user_id"];
    
    CDUser *user = [[SkylockDataManager sharedInstance] getUserWithID:userID];
    
    user.first_name = [dictionary objectForKey:@"first_name"];
    user.last_name = [dictionary objectForKey:@"last_name"];
    user.phone = [dictionary objectForKey:@"phone"];
    user.email = [dictionary objectForKey:@"email"];
    user.gender = [dictionary objectForKey:@"gender"];
    user.passwod = [dictionary objectForKey:@"password"];
    user.birth = [dictionary objectForKey:@"birth"];
    user.avatarURL = [dictionary objectForKey:@"avatar_url"];
//    user.first_name = [dictionary objectForKey:@"first_name"]
    
    //sync
    [[CoreDataService sharedInstance] saveContext];
}

-(void)reconnectLock:(CDLock *)lock
{
    _connectedLock = nil;
    
    _pickedLock = lock;
    [[BluetoothManager sharedInstance] reconnectPeripheralWithBTID:lock.localBTID];
    
}

-(void)didConnectPeripheralWithID:(NSUUID *)peripheralID
{
    CDUser *user = self.user;
    for(CDLock *lock in user.locks)
    {
        if([lock.localBTID isEqualToString:[peripheralID UUIDString]])
        {
            _pickedLock = lock;
            _connectedLock = lock;
            break;
        }
    }
}

-(void)didDisconnectPeripheralWithID:(NSString *)peripheralID
{
    _connectedLock = nil;
}

-(void)unsetAllLocksAsDefault
{
    for(CDLock *lock in [SkylockDataManager sharedInstance].user.locks)
    {
        lock.isDefault = [NSNumber numberWithBool:NO];
    }
}

-(void)setLockStateTo:(LockState)newState
{
    if(_connectedLock)
    {
        if(newState == eLocked)
            _connectedLock.isLocked = [NSNumber numberWithBool:YES];
        else if(newState == eUnlocked)
            _connectedLock.isLocked = [NSNumber numberWithBool:NO];
        
        [[CoreDataService sharedInstance] saveContext];
    }
}

-(void)updateLocationToConnectedLock:(CLLocationCoordinate2D)coordinate forcedSet:(BOOL)forced
{
    if(forced)
    {
        _pickedLock.locationLatitude = [NSNumber numberWithFloat:coordinate.latitude];
        _pickedLock.locationLongitude = [NSNumber numberWithFloat:coordinate.longitude];
        
        [[CoreDataService sharedInstance] saveContext];
    }
    else if(_connectedLock && (_pickedLock.isLocked != nil) && ![_pickedLock.isLocked boolValue])
    {
        _connectedLock.locationLatitude = [NSNumber numberWithFloat:coordinate.latitude];
        _connectedLock.locationLongitude = [NSNumber numberWithFloat:coordinate.longitude];
        
        [[CoreDataService sharedInstance] saveContext];
    }
}

-(CDLock *)getDefaultLock
{
    for(CDLock *lock in [SkylockDataManager sharedInstance].user.locks)
    {
        if([lock.isDefault boolValue])
            return lock;
    }
    
    return nil;
}

-(void)createNewLockWithName:(NSString *)name andUUID:(NSString *)uuid
{
    [self unsetAllLocksAsDefault];
    
    CDLock *newLock = [[CoreDataService sharedInstance] getNewCoreDataObjectForClass:[CDLock class]];
    newLock.name = name;
    newLock.localBTID = uuid;
    newLock.isDefault = [NSNumber numberWithBool:YES];
    newLock.owner = [SkylockDataManager sharedInstance].user;
    newLock.locationLatitude = [NSNumber numberWithFloat:-1111];
    newLock.locationLongitude = [NSNumber numberWithFloat:-1111];
    
    [[CoreDataService sharedInstance] saveContext];
    
    if([[BluetoothManager sharedInstance] getLocalUUIDOfConnectedPeripheral] != nil)
    {
        _connectedLock = newLock;
    }
    
    _pickedLock = newLock;
    
    [[BluetoothManager sharedInstance] readLockStateForConnectedDevice];
}

-(void)didReadLockLocked:(BOOL)locked
{
    _connectedLock.isLocked = [NSNumber numberWithBool:locked];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LOCK_UPDATED_NOTIFICATION object:nil userInfo:nil];
}

@end
