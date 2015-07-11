//
//  SkylockSetupNameViewController.m
//  Skylock
//
//  Created by Daniel Ondruj on 24.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import "SkylockSetupNameViewController.h"
#import "CoreDataService.h"
#import "CDLock+Skylock.h"

@interface SkylockSetupNameViewController ()

@end

@implementation SkylockSetupNameViewController

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
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if([textField.text length] > 0)
       [_continueButton setEnabled:YES];
    else
       [_continueButton setEnabled:NO];
}

-(void)tapped:(UITapGestureRecognizer *)recognizer
{
    [self becomeFirstResponder];
}

- (IBAction)continueButtonAction:(id)sender {
    if([_nameTextField.text length] > 0)
    {
        
        [[SkylockDataManager sharedInstance] createNewLockWithName:_nameTextField.text andUUID:[[[BluetoothManager sharedInstance] getLocalUUIDOfConnectedPeripheral] UUIDString]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:RELOAD_MENU_NOTIFICATION object:nil];
        
        [self performSegueWithIdentifier:@"showCongratulationsViewController" sender:self];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Name error" message:@"Name must not be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}

- (IBAction)closeGuideAction:(id)sender {
    [[BluetoothManager sharedInstance] disconnectConnectedPeripheral];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
