//
//  IntroViewController.h
//  Skylock
//
//  Created by Daniel Ondruj on 08.04.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface IntroViewController : UIViewController <FBLoginViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *conectWithFacebookButton;
- (IBAction)conectWithFacebookButtonAction:(id)sender;

@end
