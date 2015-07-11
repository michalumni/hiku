//
//  CDUsers.h
//  Skylock
//
//  Created by Daniel Ondruj on 10.04.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDUser;

@interface CDUsers : NSManagedObject

@property (nonatomic, retain) NSSet *users;
@end

@interface CDUsers (CoreDataGeneratedAccessors)

- (void)addUsersObject:(CDUser *)value;
- (void)removeUsersObject:(CDUser *)value;
- (void)addUsers:(NSSet *)values;
- (void)removeUsers:(NSSet *)values;

@end
