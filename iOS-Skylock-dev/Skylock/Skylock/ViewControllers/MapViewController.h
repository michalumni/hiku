//
//  MapViewController.h
//  Skylock
//
//  Created by Daniel Ondruj on 19.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ILTranslucentView.h"

@class THProgressView;

@interface MapViewController : UIViewController <UIGestureRecognizerDelegate, CLLocationManagerDelegate>
{
    NSTimer *holdTimer;
    BOOL progressIncreasing;
    LockState currentLockState;
    UIImageView *navbarShadowLineImage;
}
@property (weak, nonatomic) IBOutlet UINavigationItem *topNavigationItem;
@property (weak, nonatomic) IBOutlet UINavigationBar *contentNavigationBar;

@property (weak, nonatomic) IBOutlet UIView *translucentNavbarView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet THProgressView *lockProgress;
@property (weak, nonatomic) IBOutlet UIView *topControlsPanelView;
@property (weak, nonatomic) IBOutlet ILTranslucentView *topControlsPanelBlurView;
@property (weak, nonatomic) IBOutlet UIView *topControlsPanelContentView;

@property (weak, nonatomic) IBOutlet UIView *settingsPanelView;
@property (weak, nonatomic) IBOutlet UIButton *lockButton;
@property (weak, nonatomic) IBOutlet UIView *lockButtonBackground;
- (IBAction)lockButtonDown:(id)sender;
- (IBAction)lockButtonCancel:(id)sender;
- (IBAction)lockButtonUp:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *batteryStateImage;
@property (weak, nonatomic) IBOutlet UILabel *batteryStateLabel;
@property (weak, nonatomic) IBOutlet UIButton *mapControlsButton;
- (IBAction)mapControlsButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
- (IBAction)settingsButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet ILTranslucentView *blurSettingsPanelView;
@property (weak, nonatomic) IBOutlet UIView *colorBkgSettingsPanel;
@property (weak, nonatomic) IBOutlet UIView *contentSettingsPanelView;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;
- (IBAction)filterButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *navigationButton;
- (IBAction)navigationButtonAction:(id)sender;
- (IBAction)mapTypeControlChanged:(id)sender;

@end
