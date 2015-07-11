//
//  SkylockSetupViewController.h
//  Skylock
//
//  Created by Daniel Ondruj on 23.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SkylockSetupViewController : UIViewController <BluetoothManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
- (IBAction)continueButtonAction:(id)sender;
- (IBAction)closeGuideAction:(id)sender;

@end
