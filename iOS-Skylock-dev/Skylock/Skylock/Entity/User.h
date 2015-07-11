//
//  User.h
//  Skylock
//
//  Created by Daniel Ondruj on 21.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * apiID;
@property (nonatomic, retain) NSMutableArray *locks;
@property (nonatomic, retain) NSMutableArray *bikes;

@end
