//
//  SkylockSetupNameViewController.h
//  Skylock
//
//  Created by Daniel Ondruj on 24.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SkylockSetupNameViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
- (IBAction)continueButtonAction:(id)sender;
- (IBAction)closeGuideAction:(id)sender;

@end
