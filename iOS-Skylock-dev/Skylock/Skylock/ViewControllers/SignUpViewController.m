//
//  SignUpViewController.m
//  Skylock
//
//  Created by Daniel Ondruj on 09.04.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import "SignUpViewController.h"
#import <Social/Social.h>
#import "APIManager.h"
#import "SignUpCell.h"
#import "UIImage+ImageEffects.h"
#import "NSString+Validation.h"
#import "CoreDataService.h"

#define CELL_IDENTIFIER @"SignUpCell"

enum Items
{
    kName = 0,
    kSurname,
    kEmail,
    kPassword,
    kPasswordConfirm,
    kPhone,
    kGender,
    kBirth,
};

@interface SignUpViewController ()
@property (nonatomic, strong) NSMutableArray *menuItems;
@property (nonatomic, strong) UIToolbar *keyboardToolbar;
@property (nonatomic, strong) UIPickerView *genderPicker;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSMutableArray *values;
@property (nonatomic, weak) SignUpCell *selectedCell;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) UIBarButtonItem *signUpButton;
@property (nonatomic) BOOL closeRequest;

@end

@implementation SignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _closeRequest = NO;
    
    [self createMenuItems];
    
    [self createKeyboardToolbar];
    [self createDatePicker];
    [self createGenderPicker];
    
    [self prepareHeaderView];
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    UINib *nib = [UINib nibWithNibName:@"SignUpCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CELL_IDENTIFIER];
    
    _values = [NSMutableArray array];
    [_values addObject:@""];
    [_values addObject:@""];
    [_values addObject:@""];
    [_values addObject:@""];
    [_values addObject:@""];
    [_values addObject:@""];
    [_values addObject:@""];
    [_values addObject:@""];
    
    [self prepareDataIfFacebookSignUp];
    
    [self prepareNavBar];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self becomeFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - Properties

-(void)prepareNavBar
{
    _signUpButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"SignUp", @"") style:UIBarButtonItemStylePlain target:self action:@selector(signUpButtonAction:)];
    _signUpButton.enabled = NO;
    
    self.navigationItem.rightBarButtonItem = _signUpButton;
    
    
    
    UIBarButtonItem *closeBarButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", @"") style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonAction:)];
    closeBarButton.enabled = YES;
    
    self.navigationItem.leftBarButtonItem = closeBarButton;
}

-(void)prepareHeaderView
{
    _tableHeaderPhoto.layer.masksToBounds = YES;
    _tableHeaderPhoto.layer.cornerRadius = 63;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTap:)];
    [_tableHeaderView addGestureRecognizer:tapRecognizer];
}

-(void)createDatePicker
{
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
}

-(void)createGenderPicker
{
    _genderPicker = [[UIPickerView alloc] init];
    //_genderPicker.backgroundColor = [UIColor grayColor];
    _genderPicker.delegate = self;
    _genderPicker.dataSource = self;
    _genderPicker.showsSelectionIndicator = YES;
}

- (void)createMenuItems {
    //if (_menuItems) return _menuItems;
    
    _menuItems = [NSMutableArray array];
    [_menuItems addObject:@{@"title":@"Name", @"id":[NSNumber numberWithInt:kName]}];
    [_menuItems addObject:@{@"title":@"Surname", @"id":[NSNumber numberWithInt:kSurname]}];
    if(!_facebookSignUp)
    {
        [_menuItems addObject:@{@"title":@"Email", @"id":[NSNumber numberWithInt:kEmail]}];
        [_menuItems addObject:@{@"title":@"Password", @"id":[NSNumber numberWithInt:kPassword]}];
        [_menuItems addObject:@{@"title":@"Confirm Password", @"id":[NSNumber numberWithInt:kPasswordConfirm]}];
    }
    [_menuItems addObject:@{@"title":@"Phone", @"id":[NSNumber numberWithInt:kPhone]}];
    [_menuItems addObject:@{@"title":@"Gender", @"id":[NSNumber numberWithInt:kGender]}];
    [_menuItems addObject:@{@"title":@"Birth", @"id":[NSNumber numberWithInt:kBirth]}];
}

-(void)createKeyboardToolbar
{
    UIBarButtonItem* doneBarButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"") style:UIBarButtonItemStylePlain target:self action:@selector(hideKeyboard)];
    
    UIFont * font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    //NSDictionary * attributes = @{UITextAttributeFont: font, NSForegroundColorAttributeName: [UIColor whiteColor]};
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [doneBarButton setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    _keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    //_keyboardToolbar.backgroundColor = UIColorWithRGBValues(230, 232, 239);
    _keyboardToolbar.translucent = YES;
    _keyboardToolbar.barStyle = UIBarStyleBlack;
    //_keyboardToolbar.tintColor = [UIColor darkGrayColor];//UIColorWithRGBValues(230, 232, 239);
    _keyboardToolbar.items = [NSArray arrayWithObjects:
                             [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneBarButton, nil];
}

-(void)hideKeyboard
{
    [self becomeFirstResponder];
}

- (void) dateChanged:(id)sender{
    NSString *dateString = [_dateFormatter stringFromDate:_datePicker.date];
    //Sign *actualCell = (SignUpDoubleInputCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    _selectedCell.valueTextField.text = dateString;
}

#pragma mark - Facebook prepare data

-(void)prepareDataIfFacebookSignUp
{
    if(_facebookSignUp)
    {
        [_values replaceObjectAtIndex:kName withObject:[_facebookUserDictionary objectForKey:@"first_name"]];
        [_values replaceObjectAtIndex:kSurname withObject:[_facebookUserDictionary objectForKey:@"last_name"]];
        [_values replaceObjectAtIndex:kEmail withObject:[_facebookUserDictionary objectForKey:@"email"]];
        [_values replaceObjectAtIndex:kGender withObject:[_facebookUserDictionary objectForKey:@"gender"]];
        [_values replaceObjectAtIndex:kBirth withObject:[_facebookUserDictionary objectForKey:@"birthday"]];
    }
}

#pragma mark - UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SignUpCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    
    
    cell.valueTextField.placeholder = NSLocalizedString(@"Required", @"");
    
    cell.titleLabel.text = [[_menuItems objectAtIndex:[indexPath row]] objectForKey:@"title"];
    
    [cell.valueTextField addTarget:self
                            action:@selector(textFieldDidChange:)
                  forControlEvents:UIControlEventEditingChanged];
    
    int cellID = [[[_menuItems objectAtIndex:[indexPath row]] objectForKey:@"id"] intValue];
    cell.valueTextField.tag = cellID;
    switch (cellID) {
        case kName:
            cell.valueTextField.keyboardType = UIKeyboardTypeDefault;
            cell.valueTextField.returnKeyType = UIReturnKeyNext;
            cell.valueTextField.secureTextEntry = NO;
            cell.valueTextField.delegate = self;
            cell.valueTextField.inputAccessoryView = _keyboardToolbar;
            cell.valueTextField.text = [_values objectAtIndex:kName];
            break;
        case kSurname:
            cell.valueTextField.keyboardType = UIKeyboardTypeDefault;
            cell.valueTextField.returnKeyType = UIReturnKeyNext;
            cell.valueTextField.secureTextEntry = NO;
            cell.valueTextField.delegate = self;
            cell.valueTextField.inputAccessoryView = _keyboardToolbar;
            cell.valueTextField.text = [_values objectAtIndex:kSurname];
            break;
        case kEmail:
            cell.valueTextField.keyboardType = UIKeyboardTypeEmailAddress;
            cell.valueTextField.returnKeyType = UIReturnKeyNext;
            cell.valueTextField.secureTextEntry = NO;
            cell.valueTextField.delegate = self;
            cell.valueTextField.inputAccessoryView = _keyboardToolbar;
            cell.valueTextField.text = [_values objectAtIndex:kEmail];
            break;
        case kPassword:
            cell.valueTextField.keyboardType = UIKeyboardTypeDefault;
            cell.valueTextField.returnKeyType = UIReturnKeyNext;
            cell.valueTextField.secureTextEntry = YES;
            cell.valueTextField.delegate = self;
            cell.valueTextField.inputAccessoryView = _keyboardToolbar;
            break;
        case kPasswordConfirm:
            cell.valueTextField.keyboardType = UIKeyboardTypeDefault;
            cell.valueTextField.returnKeyType = UIReturnKeyNext;
            cell.valueTextField.secureTextEntry = YES;
            cell.valueTextField.delegate = self;
            cell.valueTextField.inputAccessoryView = _keyboardToolbar;
            break;
        case kPhone:
            cell.valueTextField.keyboardType = UIKeyboardTypePhonePad;
            cell.valueTextField.returnKeyType = UIReturnKeyNext;
            cell.valueTextField.secureTextEntry = NO;
            cell.valueTextField.delegate = self;
            cell.valueTextField.inputAccessoryView = _keyboardToolbar;
            break;
        case kGender:
            cell.valueTextField.inputView = _genderPicker;
            cell.valueTextField.delegate = self;
            cell.valueTextField.secureTextEntry = NO;
            cell.valueTextField.inputAccessoryView = _keyboardToolbar;
            cell.valueTextField.text = [[_values objectAtIndex:kGender] capitalizedString];
            break;
        case kBirth:
            cell.valueTextField.inputView = _datePicker;
            cell.valueTextField.delegate = self;
            cell.valueTextField.secureTextEntry = NO;
            cell.valueTextField.inputAccessoryView = _keyboardToolbar;
            cell.valueTextField.text = [_values objectAtIndex:kBirth];
            break;
        default:
            break;
    }
    
    return cell;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    SignUpCell *cell = (SignUpCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag+1 inSection:0]];
    
    [cell.valueTextField becomeFirstResponder];
    
    return NO;
}

-(void)textFieldDidChange:(UITextField *)textField
{
    [_values replaceObjectAtIndex:textField.tag withObject:textField.text];
    
    _signUpButton.enabled = [self allMandatoryFieldsOKCheckSilently:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _selectedCell = (SignUpCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0]];
    
    if(textField.tag == kGender)
    {
        textField.text = ([_genderPicker selectedRowInComponent:0]==0)?@"Male":@"Female";
    }
    else if(textField.tag == kBirth)
    {
        NSString *dateString = [_dateFormatter stringFromDate:_datePicker.date];
        textField.text = dateString;
    }
    
    _tableView.scrollEnabled = NO;
    //if(_tableView.bounds.size.height == _tableView.contentSize.height)
    //    [self.tableView setContentSize:CGSizeMake(_tableView.bounds.size.width, _tableView.bounds.size.height*2)];
    
    
    int index = textField.tag+1;
    if((index >= kPhone) && _facebookSignUp)
        index -= 3;
    
    CGPoint offset = CGPointMake(0, 50*index);
    [_tableView setContentOffset:offset animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(_closeRequest)
        return;
    
    [_values replaceObjectAtIndex:textField.tag withObject:textField.text];
    
    
    
    [self allMandatoryFieldsOKCheckSilently:YES];
    [self checkAndAlertMandatoryFieldAtIndex:textField.tag];
    
   _selectedCell = nil;
    
    _tableView.scrollEnabled = YES;
    
    [self.tableView setContentOffset:CGPointMake(0, -self.navigationController.navigationBar.frame.size.height) animated:YES];
    //[self.tableView setContentSize:CGSizeMake(_tableView.bounds.size.width, _tableView.bounds.size.height)];
}

-(void)checkMandatoryFieldsAndAllowSignup
{
    BOOL allGood = YES;
    for(int index = 0; index < [_values count]; index++)
    {
        if(_facebookSignUp && ((index == kPassword) || (index == kPasswordConfirm)))
            continue;
        
        NSString *str = [_values objectAtIndex:index];
        if([str length] <= 0)
        {
            allGood = NO;
            break;
        }
    }
    
    _signUpButton.enabled = allGood;
}

-(void)checkAndAlertMandatoryFieldAtIndex:(int)index
{
    NSString *str = [_values objectAtIndex:index];
    
    if((index == kEmail) && (![str isValidEmailAddress]))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR_TITLE", @"") message:@"Email format is wrong" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    if((index == kPhone) && (![str isValidPhoneNumberUS]))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR_TITLE", @"") message:@"Phone number format is wrong" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    
    if(!_facebookSignUp)
    {
        if( (index == kPassword) && ([[_values objectAtIndex:kPassword] length] <= 0) )
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR_TITLE", @"") message:@"Password must not be empty." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            return;
        }
        
        if( (index == kPassword) && ([[_values objectAtIndex:kPassword] length] <= 0) )
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR_TITLE", @"") message:@"Password must not be empty." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            return;
        }
        
        if(index == kPasswordConfirm)
        {
            NSString *str1 = [_values objectAtIndex:kPassword];
            NSString *str2 = [_values objectAtIndex:kPasswordConfirm];
            if(![str1 isEqualToString:str2])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR_TITLE", @"") message:@"The password and confirmation password do not match." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
                return;
            }
        }
    }
}

-(BOOL)allMandatoryFieldsOKCheckSilently:(BOOL)silence
{
    BOOL allGood = YES;
    for(int index = 0; index < [_values count]; index++)
    {
        NSString *str = [_values objectAtIndex:index];
        
        if(((index == kPassword) || (index == kPasswordConfirm)) && !_facebookSignUp)
        {
            if([str length] <= 0)
            {
                allGood = NO;
                break;
            }
        }
        
        if((index == kEmail) && (![str isValidEmailAddress]))
        {
            if(!silence)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR_TITLE", @"") message:@"Email number format is wrong" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            
            allGood = NO;
            break;
        }
        
        if((index == kPhone) && (![str isValidPhoneNumberUS]))
        {
            if(!silence)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR_TITLE", @"") message:@"Phone number format is wrong" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            
            allGood = NO;
            break;
        }
        
        if(!_facebookSignUp)
        {
            if( (index == kPassword) && ([[_values objectAtIndex:kPassword] length] <= 0) )
            {
                if(!silence)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR_TITLE", @"") message:@"Password must not be empty." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
                
                allGood = NO;
                break;
            }
            
            if(index == kPasswordConfirm)
            {
                NSString *str1 = [_values objectAtIndex:kPassword];
                NSString *str2 = [_values objectAtIndex:kPasswordConfirm];
                if(![str1 isEqualToString:str2])
                {
                    if(!silence)
                    {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR_TITLE", @"") message:@"The password and confirmation password do not match." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    }
                    
                    allGood = NO;
                    break;
                }
            }
        }
    }
    
    return allGood;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SignUpCell *cell = (SignUpCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell.valueTextField becomeFirstResponder];
}

#pragma mark - Actions

-(void)headerTap:(UITapGestureRecognizer *)recognizer
{
    [self showPhotoPicker];
}

-(void)signUpButtonAction:(id)sender
{
    [SVProgressHUD show];
    
    [[APIManager sharedInstance] signUpUserWithName:[_values objectAtIndex:kName] withSurname:[_values objectAtIndex:kSurname] withEmail:[_values objectAtIndex:kEmail] withPassword:[_values objectAtIndex:kPassword] withConfirmPassword:[_values objectAtIndex:kPasswordConfirm] withGender:[_values objectAtIndex:kGender] withPhone:[_values objectAtIndex:kPhone] withBirth:[_values objectAtIndex:kBirth] withCompletionBlock:^(NSDictionary *errorDictionary, NSError *error) {
            if(error != nil)
            {
                [SVProgressHUD dismiss];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR_TITLE", @"") message:@"Error happened" delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                [alert show];
            }
            else if(errorDictionary != nil)
            {
                [SVProgressHUD dismiss];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR_TITLE", @"") message:[[errorDictionary objectForKey:@"error"] objectForKey:@"message"] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                if(_tableHeaderBkgImage.image != nil)
                {
                    //upload image
                    [[APIManager sharedInstance] requestUpdateAvatarImage:_tableHeaderPhoto.image completionHandler:^(NSString *avatarURL, NSError *error) {
                        
                        [[SkylockDataManager sharedInstance] user].avatarURL = avatarURL;
                        
                        //downloadImage
                        NSURL *imageURL = [NSURL URLWithString:avatarURL];
                        NSURLRequest *urlR = [NSURLRequest requestWithURL:imageURL];
                        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlR];
                        requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
                        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [[SkylockDataManager sharedInstance] user].avatar = UIImagePNGRepresentation(responseObject);
                            //sync
                            [[CoreDataService sharedInstance] saveContext];
                            
                            [SVProgressHUD dismiss];
                            
                            AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
                            [appDelegate switchToUserArea];
                            
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [SVProgressHUD dismiss];
                            
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR_TITLE", @"") message:@"There was an error with uploading image. Please try it again in profile section." delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                            alert.tag = 123;
                            [alert show];
                        }];
                        [requestOperation start];
                    }];
                }
                else
                {
                    CDUser *user = [[SkylockDataManager sharedInstance] user];
                    
                    [SVProgressHUD dismiss];
                    
                    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
                    [appDelegate switchToUserArea];
                }
            }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ( (alertView.tag == 123) && (buttonIndex == 0))
    {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate switchToUserArea];
    }
}

-(void)closeButtonAction:(id)sender
{
    _closeRequest = YES;
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return 2;
}

- (NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if(row == 0)
        return @"Male";
    else
        return @"Female";
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    CGRect rect = CGRectMake(0.0, 0.0, 320, 50);
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    //label.backgroundColor = [UIColor yellowColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
    if(IS_IOS7)
        label.textColor = [UIColor whiteColor];
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    
    return label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //_timeTextField.text = [[_timesOfRide objectAtIndex:[pickerView selectedRowInComponent:0]] objectForKey:@"dateString"];
    if(row == 0)
    {
        [_values replaceObjectAtIndex:kGender withObject:@"Male"];
    }
    else
    {
        [_values replaceObjectAtIndex:kGender withObject:@"Female"];
    }
    
    _selectedCell.valueTextField.text = [_values objectAtIndex:kGender];
}

#pragma mark - Image Picker

-(void)showPhotoPicker
{
    NSString *other1 = @"Take a Photo";
    NSString *other2 = @"Choose a Photo";
    NSString *cancelTitle = @"Cancel";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:other1, other2, nil];
    
    [actionSheet showInView:self.view];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    _tableHeaderPhoto.image = image;
    
    _tableHeaderBkgImage.image = [image applyBlurWithRadius:30 tintColor:[UIColor clearColor] saturationDeltaFactor:1.8f maskImage:nil];
    
    //_profileImageView.image = image;
    picker.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
            imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
            [imagePickerController setAllowsEditing:YES];
            
            [self presentViewController:imagePickerController animated:YES completion:^{
                
            }];
        }
    }
    else if(buttonIndex == 1)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
            imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
            [imagePickerController setAllowsEditing:YES];
            
            [self presentViewController:imagePickerController animated:YES completion:^{
                
            }];
        }
    }
}

@end
