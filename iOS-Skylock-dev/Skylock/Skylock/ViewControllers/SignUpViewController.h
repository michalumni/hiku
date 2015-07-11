//
//  SignUpViewController.h
//  Skylock
//
//  Created by Daniel Ondruj on 09.04.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) BOOL facebookSignUp;
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *tableHeaderBkgImage;
@property (weak, nonatomic) IBOutlet UIImageView *tableHeaderPhoto;

@property (strong, nonatomic) IBOutlet NSDictionary *facebookUserDictionary;

@end
