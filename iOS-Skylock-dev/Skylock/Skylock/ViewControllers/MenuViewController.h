//
//  MenuViewController.h
//  Skylock
//
//  Created by Daniel Ondruj on 19.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyNavController : UINavigationController

-(void)testHide;

@end

@interface MenuViewController : UIViewController
{
    BOOL hideStatusBar;
}

@property (weak, nonatomic) IBOutlet UIView *userView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeightConstraint;

//debug
@property (weak, nonatomic) IBOutlet UIView *debugView;
@property (weak, nonatomic) IBOutlet UISwitch *debugSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *connectedSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *testLockSwitch;

- (IBAction)debugSwitchChangedValue:(id)sender;
- (IBAction)connectedSwitchChangedValue:(id)sender;
- (IBAction)testLockSwitchChangedValue:(id)sender;
- (IBAction)hideDebugView:(id)sender;

@end
