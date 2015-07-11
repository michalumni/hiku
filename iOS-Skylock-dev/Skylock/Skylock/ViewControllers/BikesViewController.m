//
//  BikesViewController.m
//  Skylock
//
//  Created by Daniel Ondruj on 04.04.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import "BikesViewController.h"
#import "UIViewController+ECSlidingViewController.h"

@interface BikesViewController ()

@end

@implementation BikesViewController

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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menuButtonTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    
}

-(IBAction)test:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

@end
