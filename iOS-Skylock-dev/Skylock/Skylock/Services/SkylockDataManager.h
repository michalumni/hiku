//
//  SkylockDataManager.h
//  Skylock
//
//  Created by Daniel Ondruj on 24.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDUser.h"
#import "CDLock.h"
#import "CDLock+Skylock.h"
#import "CDBike.h"
#import "CDBike+Skylock.h"
#import "User.h"
#import "Lock.h"
#import "Bike.h"
#import <MapKit/MapKit.h>

@interface SkylockDataManager : NSObject

@property (nonatomic, strong) CDUser *user;
@property (nonatomic, strong) CDUsers *users;

//@property (nonatomic, strong) User *user;
//@property (nonatomic, strong) Bike *bike;
//@property (nonatomic, strong) Lock *lock;

@property (nonatomic, strong) CDLock *connectedLock;
@property (nonatomic, strong) CDLock *pickedLock;

+ (SkylockDataManager*)sharedInstance;
+ (void)setupUsers;
-(void)createNewLockWithName:(NSString *)name andUUID:(NSString *)uuid;
-(CDLock *)getDefaultLock;
-(void)reconnectLock:(CDLock *)lock;

-(void)didConnectPeripheralWithID:(NSUUID *)peripheralID;
-(void)didDisconnectPeripheralWithID:(NSUUID *)peripheralID;

-(void)updateLocationToConnectedLock:(CLLocationCoordinate2D)coordinate forcedSet:(BOOL)forced;

-(void)setLockStateTo:(LockState)newState;

-(void)didReadLockLocked:(BOOL)locked;

-(CDUser *)getUserWithID:(NSString *)userID;

-(void)openUserSessionWithDataDictionary:(NSDictionary *)dictionary withXAppToken:(NSString *)XAppToken;

-(void)updateUserWithDataDictionary:(NSDictionary *)dictionary;

-(void)logoutUserSession;

@end
