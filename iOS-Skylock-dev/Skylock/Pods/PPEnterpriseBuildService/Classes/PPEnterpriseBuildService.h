//
//  EnterpriseBuildService.h
//  SpoonRocket
//
//  Created by Petr Pavlik on 27/01/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPEnterpriseBuildService;

@protocol PPEnterpriseBuildServiceDelegate <NSObject>

- (void)enterpriseBuildService:(PPEnterpriseBuildService*)service didFailToDetectNewVersionWithError:(NSError*)error;

@end

@interface PPEnterpriseBuildService : NSObject

+ (PPEnterpriseBuildService*)sharedInstanceWithPlistURL:(NSURL*)plistURL installURL:(NSURL*)installURL;

- (void)startDetectingNewVersions;
- (void)stopDetectingNewVersions;

@property(nonatomic, weak) id <PPEnterpriseBuildServiceDelegate> delegate;

@end
