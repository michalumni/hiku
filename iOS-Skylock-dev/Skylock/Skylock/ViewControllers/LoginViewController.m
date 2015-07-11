//
//  LoginViewController.m
//  Skylock
//
//  Created by Daniel Ondruj on 09.04.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import "LoginViewController.h"
#import "NSString+Validation.h"
#import "APIManager.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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

#pragma mark - Facebook

-(void)createAccountWithFacebookToken:(NSString *)token
{
    
}

-(void)loginWithFacebookToken:(NSString *)token
{
    [SVProgressHUD show];
    [[APIManager sharedInstance] signInUserWithFacebookAccess:token withCompletionBlock:^(NSDictionary *errorDictionary, NSError *error) {
        [SVProgressHUD dismiss];
        
        if(error != nil)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR_TITLE", @"") message:@"Error happened" delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
            [alert show];
        }
        else if(errorDictionary != nil)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR_TITLE", @"") message:[[errorDictionary objectForKey:@"error"] objectForKey:@"message"] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            [appDelegate switchToUserArea];
        }
    }];
}

-(BOOL)solveSessionCreateAccount
{
    if (FBSession.activeSession.isOpen) {
        //NSLog(@"user %@", [user first_name]);
        FBAccessTokenData *data = FBSession.activeSession.accessTokenData;
        
        [self loginWithFacebookToken:data.accessToken];
        
        return YES;
    }
    else
        return NO;
}

-(BOOL)solveSessionLogin
{
    if (FBSession.activeSession.isOpen) {
        //NSLog(@"user %@", [user first_name]);
        FBAccessTokenData *data = FBSession.activeSession.accessTokenData;
        
        [self loginWithFacebookToken:data.accessToken];
        
        return YES;
    }
    else
        return NO;
}

// This method will be called when the user information has been fetched (asi az po fbloginview - neni tento pripad
//- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
//                            user:(id<FBGraphUser>)user {
//    NSLog(@"user %@", [user first_name]);
//    
//    
//}

// Logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    NSLog(@"Logged out");
}

- (void)fbLoginAction
{
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state != FBSessionStateOpen) //&& !FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
    {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for basic_info permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info", @"email", @"user_birthday"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
             AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
             
             [self solveSessionLogin];
         }];
    }
}

#pragma mark - Actions

- (IBAction)loginButtonAction:(id)sender {
    if(([_emailTextField.text isValidEmailAddress]) && !([NSString isEmptyOrNil:_passwordTextField.text]))
    {
        [SVProgressHUD show];
        [[APIManager sharedInstance] loginUser:_emailTextField.text withPassword:_passwordTextField.text withCompletionBlock:^(NSDictionary *errorDictionary, NSError *error) {
            [SVProgressHUD dismiss];
            
            if(error != nil)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR_TITLE", @"") message:@"Error happened" delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                [alert show];
            }
            else if(errorDictionary != nil)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR_TITLE", @"") message:[[errorDictionary objectForKey:@"error"] objectForKey:@"message"] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
                [appDelegate switchToUserArea];
            }
        }];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Email and password must not be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)facebookLoginButtonAction:(id)sender {
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *FBaccountType= [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    //NSDictionary *dictFB = [NSDictionary dictionaryWithObjectsAndKeys:FACEBOOK_KEY,ACFacebookAppIdKey,@[@"basic_info", @"email"],ACFacebookPermissionsKey, nil];
    NSDictionary *dictFB = @{ACFacebookAppIdKey : FACEBOOK_KEY,
                             ACFacebookPermissionsKey : @[@"basic_info", @"email", @"user_birthday"]};
    
    [accountStore requestAccessToAccountsWithType:FBaccountType options:dictFB completion:
     ^(BOOL granted, NSError *e) {
         if (granted) {
             NSArray *accounts = [accountStore accountsWithAccountType:FBaccountType];
             ACAccount *fbAccount = [accounts lastObject];
             [self loginWithFacebookToken:fbAccount.credential.oauthToken];
             //it will always be the last object with single sign on
             //self.facebookAccount = [accounts lastObject];
             
             //NSLog(@"facebook account =%@",[self.facebookAccount valueForKeyPath:@"properties.uid"]);
         } else {
             //Fail gracefully...
             NSLog(@"error getting permission %@",e);
             
             if (![self solveSessionLogin]) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self fbLoginAction];
                 });
             }
         }
     }];
}
@end
