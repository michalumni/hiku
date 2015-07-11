//
//  LoginViewController.h
//  Skylock
//
//  Created by Daniel Ondruj on 09.04.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)loginButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *facebookLoginButton;
- (IBAction)facebookLoginButtonAction:(id)sender;

@end
