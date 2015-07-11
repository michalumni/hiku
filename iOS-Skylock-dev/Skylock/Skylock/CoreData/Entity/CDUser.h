//
//  CDUser.h
//  Skylock
//
//  Created by Daniel Ondruj on 14.04.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDBike, CDLock, CDUsers;

@interface CDUser : NSManagedObject

@property (nonatomic, retain) NSString * api_token;
@property (nonatomic, retain) NSData * avatar;
@property (nonatomic, retain) NSString * birth;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSString * passwod;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSString * avatarURL;
@property (nonatomic, retain) NSSet *bikes;
@property (nonatomic, retain) CDUsers *inDatabase;
@property (nonatomic, retain) NSSet *locks;
@end

@interface CDUser (CoreDataGeneratedAccessors)

- (void)addBikesObject:(CDBike *)value;
- (void)removeBikesObject:(CDBike *)value;
- (void)addBikes:(NSSet *)values;
- (void)removeBikes:(NSSet *)values;

- (void)addLocksObject:(CDLock *)value;
- (void)removeLocksObject:(CDLock *)value;
- (void)addLocks:(NSSet *)values;
- (void)removeLocks:(NSSet *)values;

@end
