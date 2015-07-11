//
//  MapViewController.m
//  Skylock
//
//  Created by Daniel Ondruj on 19.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import "MapViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MEDynamicTransition.h"
#import "THProgressView.h"
#import "UIImage+ImageEffects.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MenuViewController.h"
#import "LockPin.h"
#import <math.h>
#import "TitleView.h"

@interface MapViewController ()

@property (nonatomic) CLLocationCoordinate2D currentLocation;
@property (nonatomic) BOOL locationIsAvailable;


@property (nonatomic, strong) UIImageView *pinLockImage;
@property (nonatomic, strong) UIImageView *pinHaloImage;

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        currentLockState = eUndefined;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    self.automaticallyAdjustsScrollViewInsets = YES;
//    _navigationBlurBar
    
    _currentLocation = kCLLocationCoordinate2DInvalid;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadLockPin) name:RELOAD_PIN_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lockChanged) name:RELOAD_MENU_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:@"applicationBecomeActive" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeInactive) name:@"applicationBecomeInactive" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lockStateUpdated) name:LOCK_UPDATED_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDisconnectToPeripheral:) name:BT_DID_DISCONNECT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didConnectToPeripheral:) name:BT_DID_CONNECT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFailConnectToPeripheral:) name:BT_DID_FAIL_CONNECT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lockStateUpdated) name:BT_DID_FAIL_CONNECT object:nil];
    
//    lockStateUpdated
    
    _pinLockImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MapPinLock_locked"]];
    _pinHaloImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PinHalo"]];
    
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"TitleView" owner:self options:nil];
    TitleView* titleView = [nibViews firstObject];
    self.navigationItem.titleView = titleView;
    
    [self setProperTitle];
    
    self.slidingViewController.delegate = nil;
    
    self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;
    self.slidingViewController.customAnchoredGestures = @[];
    self.slidingViewController.panGesture.delegate = self;
    [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    navbarShadowLineImage = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    
    [self setLockLocked:eUndefined];
    
    [self setBatteryState:eFull];
    
    [self performAppearance];
    
    _lockButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);//top,left,bottom,right
    _lockButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    _blurSettingsPanelView.translucentStyle = UIBarStyleBlack;
    
    [self fancySettingsPanelShowUp];
    
    [self solveLocationState];
    
    //[self showAndUpdateFancyLockPin];
    
    [self.mapView setShowsUserLocation:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)applicationBecomeActive
{
    
}

-(void)applicationBecomeInactive
{
    
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    
    return UIStatusBarAnimationSlide;
}

-(void)setProperTitle
{
    CDLock *lock = [[SkylockDataManager sharedInstance] pickedLock];
    if(lock != nil)
    {
        ((TitleView *)self.navigationItem.titleView).titleLabel.text = lock.name;
        ((TitleView *)self.navigationItem.titleView).titleImage.image = [UIImage imageNamed:@"redDot.png"];
        [((TitleView *)self.navigationItem.titleView) updateConstraints];
    }
    else
    {
        ((TitleView *)self.navigationItem.titleView).titleLabel.text = NSLocalizedString(@"SKYLOCK_TITLE", @"Title for screens");
        ((TitleView *)self.navigationItem.titleView).titleImage.image = nil;
        [((TitleView *)self.navigationItem.titleView) updateConstraints];
    }
}

-(void)lockStateUpdated
{
    CDLock *lock = [[SkylockDataManager sharedInstance] connectedLock];
    if([lock.isLocked boolValue])
    {
        [self setLockStateVisuals:eLocked];
    }
    else if(![lock.isLocked boolValue])
    {
        [self setLockStateVisuals:eUnlocked];
    }
    
    [self showAndUpdateFancyLockPin];
}

-(void)solveLocationState
{
    if (([CLLocationManager locationServicesEnabled])
        && !([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)
        && !([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied))
    {
        _locationIsAvailable = YES;
    }
    else
    {
        _locationIsAvailable = NO;
    }
}

-(void)showAndUpdateFancyLockPin
{
    CDLock *lock = [[SkylockDataManager sharedInstance] pickedLock];
    if(lock)
    {
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([lock.locationLatitude floatValue], [lock.locationLongitude floatValue]);
        LockPin *lockPin = [self getLockPinInAnnotations];
        if((coord.latitude > -1111) && (coord.longitude > -1111))
        {
            if(lockPin)
            {
                lockPin.coordinate = coord;
            }
            else
            {
                LockPin *lockPin = [[LockPin alloc] init];
                lockPin.coordinate = coord;
                
                [self.mapView addAnnotation:lockPin];
            }
        }
        else
        {
            [self.mapView removeAnnotation:lockPin];
        }
    }
}

-(LockPin *)getLockPinInAnnotations
{
    for(id pin in self.mapView.annotations)
    {
        if([pin isKindOfClass:[LockPin class]])
            return pin;
    }
    
    return nil;
}

-(void)fancySettingsPanelShowUp
{
    _contentSettingsPanelView.alpha = 0.0;
    _colorBkgSettingsPanel.alpha = 0.0;
    _blurSettingsPanelView.alpha = 0.0;
    _colorBkgSettingsPanel.transform = CGAffineTransformMakeTranslation(0, 33);
    _blurSettingsPanelView.transform = CGAffineTransformMakeTranslation(0, 33);
    _contentSettingsPanelView.transform = CGAffineTransformMakeTranslation(0, 33);
    [UIView animateWithDuration:0.8 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _colorBkgSettingsPanel.transform = CGAffineTransformMakeTranslation(0, 0);
        _blurSettingsPanelView.transform = CGAffineTransformMakeTranslation(0, 0);
        _contentSettingsPanelView.transform = CGAffineTransformMakeTranslation(0, 0);
        
        _colorBkgSettingsPanel.alpha = 1.0;
        _blurSettingsPanelView.alpha = 1.0;
    } completion:^(BOOL finished) {
        if(finished)
        {
            
        }
    }];
    
    [UIView animateWithDuration:0.6 delay:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _contentSettingsPanelView.alpha = 1.0;
    } completion:^(BOOL finished) {
        if(finished)
        {
            
        }
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if(touch.view == _lockButton)
        return NO;
    else
        return YES;
}

-(void)performAppearance
{
    [_contentNavigationBar setShadowImage:[UIImage new]];
    
//    id appearance = self.navigationController.navigationBar;
//    [appearance setTitleTextAttributes:@{
//                                         NSForegroundColorAttributeName: [UIColor whiteColor],
//                                         NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:17]}];
//    
//    [appearance setBackIndicatorImage:[UIImage imageNamed:@"Icn-Navbar-Back"]];
//    
//    [appearance setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    
    
//    [appearance setTintColor:[UIColor whiteColor]];
//    [appearance setBarTintColor:UIColorWithRGBAValues(0,99,176,250)];
    
//    [appearance setBarStyle:UIBarStyleBlack];
    
//    [appearance setBackgroundColor:[UIColor clearColor]];
    
//    [appearance setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    navbarShadowLineImage.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    navbarShadowLineImage.hidden = NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setBatteryState:(BatteryState)newState
{
    switch (newState) {
        case eCritical:
            [_batteryStateImage setImage:[UIImage imageNamed:@"Battery_critical"]];
            [_batteryStateLabel setTextColor:BATTERY_CRITICAL_COLOR];
            [_batteryStateLabel setText:@"Critical"];
            break;
        case eLow:
            [_batteryStateImage setImage:[UIImage imageNamed:@"Battery_low"]];
            [_batteryStateLabel setTextColor:BATTERY_OK_COLOR];
            [_batteryStateLabel setText:@"Low"];
            break;
        case eOK:
            [_batteryStateImage setImage:[UIImage imageNamed:@"Battery_ok"]];
            [_batteryStateLabel setTextColor:BATTERY_OK_COLOR];
            [_batteryStateLabel setText:@"OK"];
            break;
        case eFull:
            [_batteryStateImage setImage:[UIImage imageNamed:@"Battery_full"]];
            [_batteryStateLabel setTextColor:BATTERY_OK_COLOR];
            [_batteryStateLabel setText:@"Full"];
            break;
        default:
            break;
    }
}

#pragma mark - Lock actions

-(void)lockChanged
{
    [self setProperTitle];
}

-(void)reloadLockPin
{
    [self showAndUpdateFancyLockPin];
}

-(void)setLockStateVisuals:(LockState)lockState
{
    [_lockProgress setProgress:0];
    
    _mapControlsButton.enabled = YES;
    _settingsButton.enabled = YES;
    
    if(lockState == eUndefined)
    {
        [_lockButton setTitle:NSLocalizedString(@"NOT_DEFINED_BTN", nil) forState:UIControlStateNormal];
        [_lockButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //[_lockButton setTitleShadowColor:UIColorWithRGBAValues(128, 128, 128, 64) forState:UIControlStateNormal];
        [_lockButtonBackground setBackgroundColor:[UIColor lightGrayColor]];
        [_lockButton setEnabled:NO];
        [_lockButton setImage:nil forState:UIControlStateNormal];
        
        _lockButton.alpha = 0.0f;
        [UIView animateWithDuration:0.5f animations:^{
            _lockButton.alpha = 1.0f;
        }];
        
        currentLockState = eUndefined;
        
        if(_mapControlsButton.selected)
        {
            _mapControlsButton.selected = NO;
            
            _topControlsPanelView.alpha = 1.0;
            [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
                _topControlsPanelView.alpha = 0.0;
            } completion:^(BOOL finished) {
                if(finished)
                {
                    
                }
            }];
            
            _translucentNavbarView.transform = CGAffineTransformMakeTranslation(0, 50);
            [UIView animateWithDuration:0.25f delay:0.15f options:UIViewAnimationOptionCurveEaseIn animations:^{
                _translucentNavbarView.transform = CGAffineTransformMakeTranslation(0, 0);
            } completion:^(BOOL finished) {
                if(finished)
                {
                    [_topControlsPanelView setHidden:YES];
                }
            }];
        }
        
        _mapControlsButton.enabled = NO;
        _settingsButton.enabled = NO;
    }
    else if(lockState == eLocked)
    {
        [_lockButton setTitle:NSLocalizedString(@"HOLD_TO_UNLOCK_BTN", nil) forState:UIControlStateNormal];
        [_lockButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //[_lockButton setTitleShadowColor:UIColorWithRGBAValues(7, 54, 72, 255) forState:UIControlStateNormal];
        [_lockButtonBackground setBackgroundColor:UIColorWithRGBAValues(70, 156, 207, 255)];
        [_lockButton setEnabled:YES];
        [_lockButton setImage:[UIImage imageNamed:@"BtnHoldLock_unlocked"] forState:UIControlStateNormal];
        
        _lockButton.alpha = 0.0f;
        [UIView animateWithDuration:0.5f animations:^{
            _lockButton.alpha = 1.0f;
        }];
        
        currentLockState = eLocked;
        
        _pinLockImage.image = [UIImage imageNamed:@"MapPinLock_locked"];
        
        [_pinHaloImage setHidden:NO];
        _pinHaloImage.transform = CGAffineTransformIdentity;
        _pinHaloImage.transform = CGAffineTransformMakeScale(0.0, 0.0);
        _pinHaloImage.alpha = 1.0;
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveLinear  animations:^{
            _pinHaloImage.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            if(finished)
            {
                [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveLinear  animations:^{
                    _pinHaloImage.alpha = 0.0;
                    _pinHaloImage.transform = CGAffineTransformMakeScale(2.0, 2.0);
                } completion:^(BOOL finished) {
                    if(finished)
                        [_pinHaloImage setHidden:YES];
                }];
            }
        }];
    }
    else if(lockState == eUnlocked)
    {
        [_lockButton setTitle:NSLocalizedString(@"HOLD_TO_LOCK_BTN", nil) forState:UIControlStateNormal];
        [_lockButton setTitleColor:UIColorWithRGBAValues(7, 54, 72, 255) forState:UIControlStateNormal];
        //[_lockButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_lockButtonBackground setBackgroundColor:[UIColor whiteColor]];
        [_lockButton setEnabled:YES];
        [_lockButton setImage:[UIImage imageNamed:@"BtnHoldLock_locked"] forState:UIControlStateNormal];
        
        _lockButton.alpha = 0.0f;
        [UIView animateWithDuration:0.5f animations:^{
            _lockButton.alpha = 1.0f;
        }];
        
        currentLockState = eUnlocked;
        
        _pinLockImage.image = [UIImage imageNamed:@"MapPinLock_unlocked"];
        
        [_pinHaloImage setHidden:NO];
        _pinHaloImage.transform = CGAffineTransformIdentity;
        _pinHaloImage.transform = CGAffineTransformMakeScale(0.0, 0.0);
        _pinHaloImage.alpha = 1.0;
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            _pinHaloImage.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            if(finished)
            {
                [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveLinear  animations:^{
                    _pinHaloImage.alpha = 0.0;
                    _pinHaloImage.transform = CGAffineTransformMakeScale(2.0, 2.0);
                } completion:^(BOOL finished) {
                    if(finished)
                        [_pinHaloImage setHidden:YES];
                }];
            }
        }];
    }
}

-(void)setLockLocked:(LockState)lockState
{
    if(lockState == eUndefined)
    {
        [self setLockStateVisuals:lockState];
    }
    else if(lockState == eLocked)
    {
        [self setLockStateVisuals:lockState];
        
        [[BluetoothManager sharedInstance] setLockStateTo:currentLockState];
        [[SkylockDataManager sharedInstance] setLockStateTo:currentLockState];
        [[SkylockDataManager sharedInstance] updateLocationToConnectedLock:_currentLocation forcedSet:YES];
    }
    else if(lockState == eUnlocked)
    {
        [self setLockStateVisuals:lockState];
        
        [[BluetoothManager sharedInstance] setLockStateTo:currentLockState];
        [[SkylockDataManager sharedInstance] setLockStateTo:currentLockState];
    }
}

-(void)switchLockState
{
    if(currentLockState == eLocked)
        [self setLockLocked:eUnlocked];
    else if(currentLockState == eUnlocked)
        [self setLockLocked:eLocked];
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    
}

-(void)timerTick
{
    if(progressIncreasing)
    {
        NSLog(@"%.5f", _lockProgress.progress+1*exp(-1*((pow(((_lockProgress.progress*100)-70),2))/110) )+(1.0f/160.0f));
        float gauss = 3*exp(-1*((pow(((_lockProgress.progress*100)-60),2))/450) );
        [_lockProgress setProgress:_lockProgress.progress+gauss/320+(1.0f/320.0f)];
        if(_lockProgress.progress >= 1.0f)
        {
            [_lockProgress setHidden:YES];
            [self stopTimer];
            [self switchLockState];
        }
    }
    else
    {
        [_lockProgress setProgress:_lockProgress.progress-(1.0f/160.0f)];
        if(_lockProgress.progress <= 0.0f)
        {
            [_lockProgress setHidden:YES];
            [self stopTimer];
        }
    }
}

-(void)startSlowTimer
{
    [self stopTimer];
    
    [_lockProgress setHidden:NO];
    
    if(currentLockState == eLocked)
       [_lockProgress setProgressTintColor:[UIColor whiteColor]];
    else if(currentLockState == eUnlocked)
        [_lockProgress setProgressTintColor:UIColorWithRGBAValues(70, 156, 207, 255)];
    
    holdTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f/160 target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
}

-(void)startSpeedTimer
{
    [self stopTimer];
    
    holdTimer = [NSTimer scheduledTimerWithTimeInterval:0.001f target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
}

-(void)stopTimer
{
    if(holdTimer != nil)
        [holdTimer invalidate];
    holdTimer = nil;
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{

}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    _currentLocation = userLocation.coordinate;
    
    [self gotoLocation:_currentLocation];
    
    //nastavi aktualni pozici na zamek, pokud je odemceny a pripojeny
    [[SkylockDataManager sharedInstance] updateLocationToConnectedLock:_currentLocation forcedSet:NO];
    [self showAndUpdateFancyLockPin];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *LockMapAnnotaionIdentifier = @"LockMapAnnotaionIdentifier";
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                    reuseIdentifier:LockMapAnnotaionIdentifier];
    annotationView.canShowCallout = YES;
    
    UIImage *flagImage = [UIImage imageNamed:@"MapPin"];
    
    annotationView.image = flagImage;
    _pinHaloImage.hidden = YES;
    _pinHaloImage.layer.anchorPoint = CGPointMake(0.5, 0.5);
    MoveFrameToX(_pinLockImage, 19);
    MoveFrameToY(_pinLockImage, 12);
    MoveFrameToX(_pinHaloImage, annotationView.frame.size.width/2.0f-_pinHaloImage.frame.size.width/2.0f);
    MoveFrameToY(_pinHaloImage, annotationView.frame.size.height/2.0f-_pinHaloImage.frame.size.height/2.0f);
    [annotationView addSubview:_pinLockImage];
    [annotationView addSubview:_pinHaloImage];
    
    annotationView.opaque = NO;
    annotationView.canShowCallout = NO;
    
    
    /*
     UIImageView *sfIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icn-Mapa-Pin.png"]];
     sfIconView.contentMode = UIViewContentModeCenter;
     annotationView.leftCalloutAccessoryView = sfIconView;
     */
    
    //zobacek je 5px od spodu, neboli 1/14. Takze od centru chceme odecist 6/14
    annotationView.centerOffset = CGPointMake( annotationView.centerOffset.x, annotationView.centerOffset.y - ((annotationView.image.size.height/14)*6) );
    
    return annotationView;
}

-(void)gotoLocation:(CLLocationCoordinate2D)coordinate
{
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = coordinate.latitude;
    newRegion.center.longitude = coordinate.longitude;
    newRegion.span.latitudeDelta = 0.005;//4
    newRegion.span.longitudeDelta = 0.005;
    
    [self.mapView setRegion:newRegion animated:YES];
}

#pragma mark - BT action

-(void)didDisconnectToPeripheral:(NSDictionary *)itemDetails
{
    [self setProperTitle];
    ((TitleView *)self.navigationItem.titleView).titleImage.image = [UIImage imageNamed:@"redDot.png"];
    
    [self setLockLocked:eUndefined];
}

-(void)didConnectToPeripheral:(NSDictionary *)itemDetails
{
    [self setProperTitle];
    ((TitleView *)self.navigationItem.titleView).titleImage.image = [UIImage imageNamed:@"greenDot.png"];
}

-(void)didFailConnectToPeripheral:(NSDictionary *)itemDetails
{
    [self setProperTitle];
    ((TitleView *)self.navigationItem.titleView).titleImage.image = [UIImage imageNamed:@"redDot.png"];
}

#pragma mark - IBActions

- (IBAction)menuButtonTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (IBAction)locksMenuButtonTapped:(id)sender {
    [self.slidingViewController anchorTopViewToLeftAnimated:YES];
}

- (IBAction)lockButtonDown:(id)sender {
    NSLog(@"down");
    progressIncreasing = YES;
    [self startSlowTimer];
}

- (IBAction)lockButtonCancel:(id)sender {
    NSLog(@"cancel");
    progressIncreasing = NO;
    [self startSpeedTimer];
}

- (IBAction)lockButtonUp:(id)sender {
    NSLog(@"up");
    progressIncreasing = NO;
    [self startSpeedTimer];
}
- (IBAction)mapControlsButtonAction:(id)sender {
    [_mapControlsButton setSelected:!_mapControlsButton.selected];
    [_mapControlsButton setImage:[_mapControlsButton imageForState:(_mapControlsButton.selected)?UIControlStateNormal:UIControlStateSelected] forState:UIControlStateHighlighted];
    
    if(_mapControlsButton.selected)
    {
        [_topControlsPanelView setHidden:NO];
        
        _translucentNavbarView.transform = CGAffineTransformMakeTranslation(0, 50.0f);
        [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            _translucentNavbarView.transform = CGAffineTransformMakeTranslation(0, 100.0f);
        } completion:^(BOOL finished) {
            if(finished)
            {
            
            }
        }];
        
        _topControlsPanelView.alpha = 0.0;
        [UIView animateWithDuration:0.25f delay:0.15f options:UIViewAnimationOptionCurveEaseIn animations:^{
            _topControlsPanelView.alpha = 1.0;
        } completion:^(BOOL finished) {
            if(finished)
            {
                
            }
        }];
    }
    else
    {
        _topControlsPanelView.alpha = 1.0;
        [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            _topControlsPanelView.alpha = 0.0;
        } completion:^(BOOL finished) {
            if(finished)
            {
                
            }
        }];
        
        _translucentNavbarView.transform = CGAffineTransformMakeTranslation(0, 50);
        [UIView animateWithDuration:0.25f delay:0.15f options:UIViewAnimationOptionCurveEaseIn animations:^{
            _translucentNavbarView.transform = CGAffineTransformMakeTranslation(0, 0);
        } completion:^(BOOL finished) {
            if(finished)
            {
                [_topControlsPanelView setHidden:YES];
            }
        }];
    }
}
- (IBAction)settingsButtonAction:(id)sender {
    
    [self performSegueWithIdentifier:@"ShowLockSettings" sender:self];
}

- (IBAction)filterButtonAction:(id)sender {
}

- (IBAction)navigationButtonAction:(id)sender {
    [_navigationButton setSelected:!_navigationButton.selected];
    [_navigationButton setImage:[_navigationButton imageForState:(_navigationButton.selected)?UIControlStateNormal:UIControlStateSelected] forState:UIControlStateHighlighted];
    
    if([_navigationButton isSelected])
    {
        CDLock *lock = [[SkylockDataManager sharedInstance] pickedLock];
        if(lock != nil)
            [self gotoLocation:CLLocationCoordinate2DMake([lock.locationLatitude floatValue], [lock.locationLongitude floatValue])];
    }
    else
    {
        if(CLLocationCoordinate2DIsValid(_currentLocation))
            [self gotoLocation:_currentLocation];
    }
}

- (IBAction)mapTypeControlChanged:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex)
    {
        case 0://normal
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1: //Satellite
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        default:  //Map
            break;
    }
}
@end
