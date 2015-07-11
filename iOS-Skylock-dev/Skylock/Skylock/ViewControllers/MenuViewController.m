//
//  MenuViewController.m
//  Skylock
//
//  Created by Daniel Ondruj on 19.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import "MenuViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MenuCell.h"
#import "APIManager.h"
#import <AFHTTPRequestOperation.h>
#import "CoreDataService.h"
#import <CoreMotion/CoreMotion.h>

@implementation MyNavController

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    
    return UIBarPositionTopAttached;
}

-(void)testHide
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

@end



@interface MenuViewController ()
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) UINavigationController *mapNavigationController;
@property (nonatomic, strong) NSIndexPath *selectedMenuIndexPath;
@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        CMAccelerometerData *a;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.edgesForExtendedLayout = UIEdgeInsetsMake(20, 0, 0, 0);
    
    // topViewController is the transitions navigation controller at this point.
    // It is initially set as a User Defined Runtime Attributes in storyboards.
    // We keep a reference to this instance so that we can go back to it without losing its state.
    self.mapNavigationController = (UINavigationController *)self.slidingViewController.topViewController;
    
    [self.tableView registerClass:[MenuCell class] forCellReuseIdentifier:@"MenuCell"];
    
    _selectedMenuIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    //update user profile
    [[APIManager sharedInstance] updateProfileWithCompletionBlock:^(NSDictionary *errorDictionary, NSError *error) {
        if((error == nil) && (errorDictionary == nil))
        {
            [self updateUserAvatar];
        }
        else
        {
            [self updateUserAvatar];
        }
    }];
    
    if(![UIDevice isIPhone5Screen])
        _tableHeightConstraint.constant = 250;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userViewTapped:)];
    [_userView addGestureRecognizer:tapRecognizer];
    
    [_userImage.layer setMasksToBounds:YES];
    [_userImage.layer setCornerRadius:_userImage.bounds.size.width/2.0f];
    
//    [self createMenuItems];
//    [self.tableView reloadData];
}


-(void)updateUserAvatar
{
    //update image
    CDUser *user = [[SkylockDataManager sharedInstance] user];
    
    NSURL *imageURL = [NSURL URLWithString:user.avatarURL];
    
    //if the image is store only locally, we try to sync it
    if((user.avatarURL == nil) && (user.avatar != nil))
    {
        [[APIManager sharedInstance] requestUpdateAvatarImage:[UIImage imageWithData:user.avatar] completionHandler:^(NSString *avatarURL, NSError *error) {
            if((error == nil) && (avatarURL != nil))
            {
                [[SkylockDataManager sharedInstance] user].avatarURL = avatarURL;
                [[CoreDataService sharedInstance] saveContext];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR_TITLE", @"") message:@"Problem with sending avatar to the server. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
    else
    {
        NSURLRequest *urlR = [NSURLRequest requestWithURL:imageURL];
        
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlR];
        requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            _userImage.image = responseObject;
            user.avatar = UIImagePNGRepresentation(_userImage.image);
            
            //sync
            [[CoreDataService sharedInstance] saveContext];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        [requestOperation start];
    }
}

- (BOOL)prefersStatusBarHidden {
    return hideStatusBar;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    
    return UIStatusBarAnimationSlide;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self createMenuItems];
    [self reloadUser];
    [_tableView reloadData];
    
    if(_selectedMenuIndexPath.section != -1)
        [_tableView selectRowAtIndexPath:_selectedMenuIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
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

//-(void)repairFrame:(BOOL)hideStatusBar
//{
//    [self.navigationController.view setNeedsLayout];
//    CGRect navBarFrame;
//    UINavigationBar *navBar = nil;
//    for (UIView *subView in navigationController.view.subviews)
//    {
//        if ([subView isMemberOfClass:[UINavigationBar class]])
//        {
//            navBar = (UINavigationBar *)subView;
//            navBarFrame = navBar.frame;
//            navBarFrame.origin = CGPointMake(0,0);
//            break;
//        }
//    }
//    
//    if ([UIApplication sharedApplication].statusBarHidden != hideStatusBar)
//    {
//        [[UIApplication sharedApplication] setStatusBarHidden:hideStatusBar withAnimation:UIStatusBarAnimationSlide];
//        [UIView animateWithDuration:0.25 animations:^{
//            window.frame = [[UIScreen mainScreen] applicationFrame];
//            navBar.frame = navBarFrame;
//        }];
//    }
//    else
//    {
//        window.frame = [[UIScreen mainScreen] applicationFrame];
//    }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Properties

-(void)reloadUser
{
    CDUser *user = [[SkylockDataManager sharedInstance] user];
    _userName.text = [NSString stringWithFormat:@"%@ %@", user.first_name, user.last_name];
    if(user.avatar != nil)
        _userImage.image = [UIImage imageWithData:user.avatar];
}

- (void)createMenuItems {
    //if (_menuItems) return _menuItems;
    
    int locks = [[[[SkylockDataManager sharedInstance] user] locks] count];
    int bikes = [[[[SkylockDataManager sharedInstance] user] bikes] count];
    
    _menuItems = @[@{@"name":@"Locks", @"imageName":@"IcnMenuLocks", @"badgeNum":[NSNumber numberWithInt:locks]},
                   @{@"name":@"Bikes", @"imageName":@"IcnMenuBikes", @"badgeNum":[NSNumber numberWithInt:bikes]},
                   @{@"name":@"Account", @"imageName":@"IcnMenuSettings", @"badgeNum":[NSNumber numberWithInt:-1]},
                   ];
}

#pragma mark - Actions
-(void)userViewTapped:(UITapGestureRecognizer *)recognizer
{
    [_tableView deselectRowAtIndexPath:_selectedMenuIndexPath animated:YES];
    _selectedMenuIndexPath = [NSIndexPath indexPathForRow:0 inSection:-1];
    
    self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileNavigationController"];
    
    [self.slidingViewController resetTopViewAnimated:YES];
}

#pragma mark - UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MenuCell";
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary *menuItem = self.menuItems[indexPath.row];
    
    cell.titleLabel.text = [menuItem objectForKey:@"name"];
    cell.iconImageView.image = [UIImage imageNamed:[menuItem objectForKey:@"imageName"]];

    int badgeNum = [[menuItem objectForKey:@"badgeNum"] intValue];
    cell.numberLabel.text = (badgeNum > 0)?[NSString stringWithFormat:@"%d", badgeNum]:@"";
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *menuItem = self.menuItems[indexPath.row];
    
    _selectedMenuIndexPath = indexPath;
    
    // This undoes the Zoom Transition's scale because it affects the other transitions.
    // You normally wouldn't need to do anything like this, but we're changing transitions
    // dynamically so everything needs to start in a consistent state.
    self.slidingViewController.topViewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1);
    
    switch ([indexPath row]) {
        case 0:
            if(self.slidingViewController.topViewController != self.mapNavigationController)
                self.slidingViewController.topViewController = self.mapNavigationController;
            break;
        case 1:
            self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BikesNavigationController"];
            break;
        case 2:
        {
            
        }
            break;
        default:
            break;
    }
    
    [self.slidingViewController resetTopViewAnimated:YES];
}

#pragma mark - Debug actions

- (IBAction)debugSwitchChangedValue:(id)sender {
    if(_debugSwitch.isOn)
    {
        _connectedSwitch.enabled = YES;
        
        [self createDebugLock];
    }
    else
    {
        _connectedSwitch.enabled = NO;
        
        [SkylockDataManager sharedInstance].pickedLock = nil;
        [SkylockDataManager sharedInstance].connectedLock = nil;
        
        [_connectedSwitch setOn:NO];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RELOAD_MENU_NOTIFICATION object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:RELOAD_PIN_NOTIFICATION object:nil userInfo:nil];
}

- (IBAction)connectedSwitchChangedValue:(id)sender {
    
    
    if(_connectedSwitch.isOn)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:BT_DID_CONNECT object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:LOCK_UPDATED_NOTIFICATION object:nil userInfo:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:BT_DID_DISCONNECT object:nil userInfo:nil];
    }
}

- (IBAction)testLockSwitchChangedValue:(id)sender
{
    
}

- (IBAction)hideDebugView:(id)sender {
    [_debugView removeFromSuperview];
}

-(void)createDebugLock
{
    CDLock *newLock = [[CoreDataService sharedInstance] getNewCoreDataObjectForClass:[CDLock class]];
    newLock.name = @"Debug lock";
    newLock.localBTID = @"00000000-0000-0000-0000-000000000000";
    newLock.isDefault = [NSNumber numberWithBool:YES];
    newLock.locationLatitude = [NSNumber numberWithFloat:-1111];
    newLock.locationLongitude = [NSNumber numberWithFloat:-1111];
    newLock.isLocked = [NSNumber numberWithBool:NO];
    
    [SkylockDataManager sharedInstance].pickedLock = newLock;
    [SkylockDataManager sharedInstance].connectedLock = newLock;
}

@end
