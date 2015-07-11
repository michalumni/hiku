//
//  SkylockSetupCongratulationsViewController.m
//  Skylock
//
//  Created by Daniel Ondruj on 24.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import "SkylockSetupCongratulationsViewController.h"

@interface SkylockSetupCongratulationsViewController ()

@end

@implementation SkylockSetupCongratulationsViewController

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

- (IBAction)closeButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
