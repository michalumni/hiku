//
//  IntroViewController.m
//  Skylock
//
//  Created by Daniel Ondruj on 08.04.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import "IntroViewController.h"
#import "APIManager.h"
#import "SignUpViewController.h"
#import <Social/Social.h>

@interface IntroViewController ()
@property (nonatomic, strong) NSDictionary *facebookUserDictionary;
@end

@implementation IntroViewController

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
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
            if([[errorDictionary objectForKey:@"code"] intValue] == 1003)
            {
                [self performSegueWithIdentifier:@"ShowSignUpFacebook" sender:self];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR_TITLE", @"") message:[[errorDictionary objectForKey:@"error"] objectForKey:@"message"] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                [alert show];
            }
        }
        else
        {
            AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            [appDelegate switchToUserArea];
        }
    }];
}

-(void)loginWithFacebookACAccount:(ACAccount *)account
{
    NSURL* URL = [NSURL URLWithString:@"https://graph.facebook.com/me"];
    
    SLRequest* request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                            requestMethod:SLRequestMethodGET
                                                      URL:URL
                                               parameters:nil];
    
    [request setAccount:account]; // Authentication - Requires user context
    
    [SVProgressHUD show];
    [request performRequestWithHandler:^(NSData* responseData, NSHTTPURLResponse* urlResponse, NSError* error) {
        // parse the response or handle the error
        [SVProgressHUD dismiss];
        
        
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
        if( dataDict[@"error"] != nil ) {
            //NSLog( @"error loading request: %@", dataDict[@"error"] );
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR_TITLE", @"") message:@"Error happened" delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
            [alert show];
        }
        else {
            [self loginWithFacebookUserDictionary:dataDict];
        }
    }];
}

-(void)loginWithFacebookUserDictionary:(NSDictionary *)dictionary
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _facebookUserDictionary = dictionary;
        [self performSegueWithIdentifier:@"ShowSignUpFacebook" sender:self];
    });
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
        //FBAccessTokenData *data = FBSession.activeSession.accessTokenData;
        
        //[self loginWithFacebookToken:data.accessToken];
        [SVProgressHUD show];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary *user, NSError *error) {
                if (!error) {
                    [self loginWithFacebookUserDictionary:user];
                }
                [SVProgressHUD dismiss];
            }];
        });
        
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
    else
    {
    
    }
}

#pragma mark - Actions

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"ShowSignUpFacebook"])
    {
        SignUpViewController *signUpViewController = (SignUpViewController *)[[segue destinationViewController] topViewController];
        signUpViewController.facebookUserDictionary = _facebookUserDictionary;
        signUpViewController.facebookSignUp = YES;
    }
    else if([[segue identifier] isEqualToString:@"ShowSignUp"])
    {
        SignUpViewController *signUpViewController = (SignUpViewController *)[[segue destinationViewController] topViewController];
        signUpViewController.facebookSignUp = NO;
    }
}

- (IBAction)conectWithFacebookButtonAction:(id)sender {
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *FBaccountType= [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    //NSDictionary *dictFB = [NSDictionary dictionaryWithObjectsAndKeys:FACEBOOK_KEY,ACFacebookAppIdKey,@[@"basic_info", @"email", @"user_birthday"],ACFacebookPermissionsKey, nil];
    NSDictionary *dictFB = @{ACFacebookAppIdKey : FACEBOOK_KEY,
                             ACFacebookPermissionsKey : @[@"basic_info", @"email", @"user_birthday"]};
    
    [accountStore requestAccessToAccountsWithType:FBaccountType options:dictFB completion:
     ^(BOOL granted, NSError *e) {
         if (granted) {
             NSArray *accounts = [accountStore accountsWithAccountType:FBaccountType];
             ACAccount *fbAccount = [accounts lastObject];
             //[self loginWithFacebookToken:fbAccount.credential.oauthToken];
             [self loginWithFacebookACAccount:fbAccount];
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
