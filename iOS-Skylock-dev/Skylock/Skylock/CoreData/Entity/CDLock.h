//
//  CDLock.h
//  Skylock
//
//  Created by Daniel Ondruj on 10.04.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDUser;

@interface CDLock : NSManagedObject

@property (nonatomic, retain) NSString * lock_id;
@property (nonatomic, retain) NSNumber * isDefault;
@property (nonatomic, retain) NSNumber * isLocked;
@property (nonatomic, retain) NSString * localBTID;
@property (nonatomic, retain) NSNumber * locationLatitude;
@property (nonatomic, retain) NSNumber * locationLongitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) CDUser *owner;

@end
