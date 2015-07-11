//
//  Lock.h
//  Skylock
//
//  Created by Daniel Ondruj on 20.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Lock : NSObject

@property (nonatomic, strong) NSString * apiID;
@property (nonatomic, strong) NSString * localBTID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic) BOOL isDefault;

@end
