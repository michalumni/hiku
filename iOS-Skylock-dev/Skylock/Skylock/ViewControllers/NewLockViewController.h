//
//  NewLockViewController.h
//  Skylock
//
//  Created by Daniel Ondruj on 24.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewLockViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *orderSkylockOnlineButton;
@property (weak, nonatomic) IBOutlet UIButton *connectSkylockButton;
- (IBAction)connectSkylockButtonAction:(id)sender;
- (IBAction)orderSkylockOnlineButtonAction:(id)sender;
- (IBAction)menuButtonTapped:(id)sender;
- (IBAction)locksMenuButtonTapped:(id)sender;

@end
