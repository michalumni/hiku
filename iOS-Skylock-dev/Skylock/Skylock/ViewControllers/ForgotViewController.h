//
//  ForgotViewController.h
//  Skylock
//
//  Created by Daniel Ondruj on 11.04.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
- (IBAction)sendButtonAction:(id)sender;

@end
