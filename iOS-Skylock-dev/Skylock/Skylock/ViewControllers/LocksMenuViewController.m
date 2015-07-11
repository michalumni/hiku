//
//  LocksMenuViewController.m
//  Skylock
//
//  Created by Daniel Ondruj on 19.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import "LocksMenuViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "LockListItemView.h"
#import "Lock.h"
#import "UIImage+ImageEffects.h"

@interface LocksMenuViewController ()
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) UINavigationController *mapNavigationController;
@end

@implementation LocksMenuViewController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMenu) name:RELOAD_MENU_NOTIFICATION object:nil];
    
    // topViewController is the transitions navigation controller at this point.
    // It is initially set as a User Defined Runtime Attributes in storyboards.
    // We keep a reference to this instance so that we can go back to it without losing its state.
    self.mapNavigationController = (UINavigationController *)self.slidingViewController.topViewController;
    
    locksArray = [[NSMutableArray alloc] init];
    locksItemArray = [[NSMutableArray alloc] init];
    
    [self createLocksList];
    
    [self performAppearance];
}

-(void)performAppearance
{
    id appearance = self.navigationController.navigationBar;
    [appearance setTitleTextAttributes:@{
                                         NSForegroundColorAttributeName: [UIColor whiteColor],
                                         NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:17]}];

    [appearance setBackIndicatorImage:[UIImage imageNamed:@"Icn-Navbar-Back"]];

    [appearance setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];


    [appearance setTintColor:[UIColor whiteColor]];
    [appearance setBarTintColor:UIColorWithRGBAValues(0,99,176,250)];

    [appearance setBarStyle:UIBarStyleBlack];

    [appearance setBackgroundColor:[UIColor clearColor]];

    [appearance setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RELOAD_MENU_NOTIFICATION object:nil];
}

- (BOOL)prefersStatusBarHidden {
    return hideStatusBar;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    
    return UIStatusBarAnimationSlide;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    hideStatusBar = YES;
    
    //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [UIView animateWithDuration:0.3 animations:^(void) {
        [self setNeedsStatusBarAppearanceUpdate];
    } completion:^(BOOL finished) {}];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    hideStatusBar = NO;
    
    //[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [UIView animateWithDuration:0.3 animations:^(void) {
        [self setNeedsStatusBarAppearanceUpdate];
    } completion:^(BOOL finished) {}];
}

#pragma mark - Prepare activities
-(void)createLocksList
{
    [locksArray removeAllObjects];
    [locksItemArray removeAllObjects];
    
    CDUser *user = [[SkylockDataManager sharedInstance] user];
    for(CDLock *lock in user.locks)
        [locksArray addObject:lock];
    
    [locksArray addObject:[NSNull null]];
    
    int i;
    for(i = 0; i < [locksArray count]; i++)
    {
        CGPoint coord;
        CDLock *lock = [locksArray objectAtIndex:i];
        
        LockListItemView *listItem = [self createListItemViewWithLock:lock];
        
        coord.x = 10 + (i%2)*(_scrollView.bounds.size.width/2.0f);
        coord.y = 10 + (i/2)*(listItem.bounds.size.height);
        CGRect rect = listItem.frame;
        rect.origin = coord;
        listItem.frame = rect;
        
        [_scrollView addSubview:listItem];
        [locksItemArray addObject:listItem];
    }
}

-(void)reloadMenu
{
    for(UIView *item in locksItemArray)
        [item removeFromSuperview];
    
    [self createLocksList];
}

-(void)deselectDefaultSigns
{
    for(LockListItemView *lliv in locksItemArray)
        [lliv setDefault:NO];
}

-(LockListItemView *)createListItemViewWithLock:(CDLock *)lock
{
    LockListItemView *listItem = [[[NSBundle mainBundle] loadNibNamed:@"LockListItemView" owner:self options:nil] firstObject];
    listItem.lock = lock;
    listItem.delegate = self;
    if((NSNull *)lock == [NSNull null])
    {
        listItem.lockImage.image = [UIImage imageNamed:@"LockAddNew"];
        listItem.nameLabel.text = @"Add New";
        [listItem.defaultSignImage setHidden:YES];
        
        [listItem setSelectedBkgImage:[UIImage imageNamed:@"LockItemBkgAddNew_highlighted"]];
        [listItem setUnselectedBkgImage:[UIImage imageNamed:@"LockItemBkgAddNew"]];
    }
    else
    {
        listItem.lockImage.image = [UIImage imageNamed:@"Lock"];
        listItem.nameLabel.text = [NSString stringWithFormat:@"%@", lock.name];
        [listItem.defaultSignImage setHidden:NO];
        [listItem setDefault:[lock.isDefault boolValue]];
        
        [listItem setSelectedBkgImage:[UIImage imageNamed:@"LockItemBkg_highlighted"]];
        [listItem setUnselectedBkgImage:[UIImage imageNamed:@"LockItemBkg"]];
    }
    [listItem setUp];
    
    return listItem;
}

-(void)lockItemClicked:(LockListItemView *)item withLock:(CDLock *)lock
{
    NSLog(@"lock clicked");
    if((NSNull *)lock == [NSNull null])
    {
        self.slidingViewController.topViewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1);
        
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewLockSection"];

        [self.slidingViewController resetTopViewAnimated:YES];
    }
    else
    {
        if(lock == [[SkylockDataManager sharedInstance] pickedLock])
        {
            [self.slidingViewController resetTopViewAnimated:YES];
            return;
        }
        
        
        
        //disconnect connected lock
        [[BluetoothManager sharedInstance] disconnectConnectedPeripheral];
        
        //deselectDefault lock
        [self deselectDefaultSigns];
        
        //set new default lock
        [item setDefault:YES];
        
        //reconnect lock
        [[SkylockDataManager sharedInstance] reconnectLock:lock];
        
        //reload map - repair pin
        
        
        //slide back to map
        [self.slidingViewController resetTopViewAnimated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:RELOAD_PIN_NOTIFICATION object:nil userInfo:nil];
    }
}


@end
