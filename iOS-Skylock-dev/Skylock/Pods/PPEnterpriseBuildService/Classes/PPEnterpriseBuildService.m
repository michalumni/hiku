//
//  EnterpriseBuildService.m
//  SpoonRocket
//
//  Created by Petr Pavlik on 27/01/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "PPEnterpriseBuildService.h"

@interface PPEnterpriseBuildService () <UIAlertViewDelegate>

@property(nonatomic, strong) NSURL* plistURL;
@property(nonatomic, strong) NSURL* installURL;

@property(atomic, getter = isCheckingForNewVersion) BOOL checkingForNewVersion;

@end

@implementation PPEnterpriseBuildService

+ (PPEnterpriseBuildService*)sharedInstanceWithPlistURL:(NSURL*)plistURL installURL:(NSURL*)installURL; {

    static PPEnterpriseBuildService* sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        NSParameterAssert(plistURL);
        NSParameterAssert(installURL);

        sharedInstance = [PPEnterpriseBuildService new];
        sharedInstance.installURL = installURL;
        sharedInstance.plistURL = plistURL;
    });

    return sharedInstance;
}

#pragma mark -

- (void)startDetectingNewVersions {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNewVersion) name:UIApplicationWillEnterForegroundNotification object:nil];

    [self checkNewVersion];
}

- (void)stopDetectingNewVersions {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -

- (void)checkNewVersion {

    if (self.isCheckingForNewVersion) {
        return;
    }

    self.checkingForNewVersion = YES;

    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){


        NSURLRequest* request = [NSURLRequest requestWithURL:self.plistURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];

        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

            dispatch_async(dispatch_get_main_queue(), ^{

                if (connectionError) {

                    [self.delegate enterpriseBuildService:self didFailToDetectNewVersionWithError:connectionError];

                    self.checkingForNewVersion = NO;
                    return;
                }

                NSError* parsingError;
                id plist = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:&parsingError];

                if (parsingError) {

                    [self.delegate enterpriseBuildService:self didFailToDetectNewVersionWithError:parsingError];

                    self.checkingForNewVersion = NO;
                    return;
                }

                NSString* bundleVersionFromPlist = plist[@"items"][0][@"metadata"][@"bundle-version"];
                NSString* bundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

                if (!bundleVersion.length) {
                    return;
                }

                if ([bundleVersion compare:bundleVersionFromPlist options:NSNumericSearch] == NSOrderedAscending) {

                    [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Version %@ is available.", bundleVersionFromPlist] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Install", nil] show];
                }
                else {

                    self.checkingForNewVersion = NO;
                }
            });
        }];
    });
}

#pragma mark -

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {

    self.checkingForNewVersion = NO;

    if (buttonIndex == alertView.cancelButtonIndex) {
        return;
    }

    [[UIApplication sharedApplication] openURL:self.installURL];
}

@end
