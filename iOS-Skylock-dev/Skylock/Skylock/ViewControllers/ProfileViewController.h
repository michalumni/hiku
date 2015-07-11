//
//  ProfileViewController.h
//  Skylock
//
//  Created by Daniel Ondruj on 18.04.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIBarButtonItem *menuBarButton;
@property (strong, nonatomic) UIBarButtonItem *logoutBarButton;
@property (strong, nonatomic) UIBarButtonItem *cancelBarButton;
@property (strong, nonatomic) UIBarButtonItem *saveBarButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) BOOL facebookSignUp;
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *tableHeaderBkgImage;
@property (weak, nonatomic) IBOutlet UIImageView *tableHeaderPhoto;

@property (strong, nonatomic) IBOutlet NSDictionary *facebookUserDictionary;
- (IBAction)menuButtonTapped:(id)sender;
- (IBAction)logoutButtonTapped:(id)sender;

@end
