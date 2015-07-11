//
//  AppDelegate.m
//  Skylock
//
//  Created by Daniel Ondruj on 18.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreDataService.h"
#import "UIImage+ImageEffects.h"
#import "ClearNavigationViewController.h"

#import "PPEnterpriseBuildService.h"

#if ENABLE_PONYDEBUGGER
#import <PonyDebugger.h>
#endif

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
#if ENABLE_PONYDEBUGGER
    
    PDDebugger *debugger = [PDDebugger defaultInstance];
    [debugger enableNetworkTrafficDebugging];
    [debugger forwardAllNetworkTraffic];
    [debugger enableViewHierarchyDebugging];
    [debugger setDisplayedViewAttributeKeyPaths:@[@"frame", @"hidden", @"alpha", @"opaque"]];
    [debugger connectToURL:[NSURL URLWithString:kPonyDebuggerURL]];
    
#endif
    
    [[PPEnterpriseBuildService
      sharedInstanceWithPlistURL:[NSURL URLWithString:@"https://app.ulikeit.com/skylock/Skylock.plist"]
      installURL:[NSURL URLWithString:@"https://app.ulikeit.com/skylock/"]]
     startDetectingNewVersions];
    
    [SkylockDataManager setupUsers];
    
    [self performAppearance];
    
    if([[SkylockDataManager sharedInstance] user] == nil)
        [self switchToLoginArea];
    else
        [self switchToUserArea];
    
    // Whenever a person opens the app, check for a cached session
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
    }
    
    return YES;
}

-(void)switchToUserArea
{
    UINavigationController *rootNavigationController = (UINavigationController *)self.window.rootViewController;
    //[rootNavigationController popToRootViewControllerAnimated:NO];
    
    UIViewController *slidingViewController = [rootNavigationController.storyboard instantiateViewControllerWithIdentifier:@"SlidingViewController"];
    
    //[rootNavigationController pushViewController:slidingViewController animated:YES];
    
    //[rootNavigationController setNavigationBarHidden:YES animated:YES];
    
    //[rootNavigationController setViewControllers:@[slidingViewController] animated:YES];
    
//    [[rootNavigationController.viewControllers firstObject] presentViewController:slidingViewController animated:YES completion:^{
//        
//    }];
    
    //[rootNavigationController pushViewController:slidingViewController animated:YES];
    [self.window setRootViewController:slidingViewController];
    
    //    UINavigationController *rootNavigationController = (UINavigationController *)self.window.rootViewController;
    //
    //    if ([rootNavigationController.topViewController isKindOfClass:[LoginViewController class]]) {
    //        [rootNavigationController popViewControllerAnimated:YES];
    //    }
    //    else {
    //        MainVC *mainVC = [rootNavigationController.storyboard instantiateViewControllerWithIdentifier:@"MainVC"];
    //        //[rootNavigationController popToRootViewControllerAnimated:NO];
    //        [rootNavigationController pushViewController:mainVC animated:YES];
    //    }
    
}


-(void)switchToLoginArea
{
    UINavigationController *rootNavigationController = (UINavigationController *)self.window.rootViewController;
    //[rootNavigationController popToViewController:[rootNavigationController.viewControllers firstObject] animated:NO];
    //[rootNavigationController popToRootViewControllerAnimated:NO];
    //UINavigationBar *n = rootNavigationController.navigationBar;
    
    //UIViewController *mainVC = [rootNavigationController.storyboard instantiateViewControllerWithIdentifier:@"mainVC"];
    
    UINavigationController *introNavigationController = [rootNavigationController.storyboard instantiateViewControllerWithIdentifier:@"IntroNavigationController"];
//    [rootNavigationController introNavigationController animated:YES];
    UIViewController *introViewController = [rootNavigationController.storyboard instantiateViewControllerWithIdentifier:@"IntroViewController"];
    
    [self.window setRootViewController:introNavigationController];
    
    //[rootNavigationController setNavigationBarHidden:NO animated:YES];
    //[rootNavigationController pushViewController:introViewController animated:YES];
    //[self.window setRootViewController:introNavigationController];
    //[rootNavigationController setViewControllers:@[introViewController] animated:YES];
//    [mainVC presentViewController:introNavigationController animated:YES completion:^{
//        
//    }];
    
    //[mainVC performSegueWithIdentifier:@"Login" sender:mainVC];
    
//    [[rootNavigationController.viewControllers firstObject] performSegueWithIdentifier:@"Login" sender:[rootNavigationController.viewControllers firstObject]];
//    UIViewController *a = [rootNavigationController.viewControllers firstObject];
    
    //self.window.rootViewController = introNavigationController;
    
    //    UINavigationController *rootNavigationController = (UINavigationController *)self.window.rootViewController;
    //
    //    if ([rootNavigationController.topViewController isKindOfClass:[LoginViewController class]]) {
    //        [rootNavigationController popViewControllerAnimated:YES];
    //    }
    //    else {
    //        MainVC *mainVC = [rootNavigationController.storyboard instantiateViewControllerWithIdentifier:@"MainVC"];
    //        //[rootNavigationController popToRootViewControllerAnimated:NO];
    //        [rootNavigationController pushViewController:mainVC animated:NO];
    
    //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //            [[NSNotificationCenter defaultCenter] postNotificationName:kSwitchToLoginAreaNotification object:self];
    //        });
    //    }
    
    
    
    //    UINavigationController *rootNavigationController = (UINavigationController *)self.window.rootViewController;
    //
    //    IntroViewController *introVC = [rootNavigationController.storyboard instantiateViewControllerWithIdentifier:@"IntroViewController"];
    
    ////[rootNavigationController popToRootViewControllerAnimated:NO];
    //[rootNavigationController pushViewController:introVC animated:YES];
    
    ////////////////////////////////////////////////////////////////
    
    
}

// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        //[self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        //[self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        //[self userLoggedOut];
    }
}

-(void)showMessage:(NSString *)alertMsg withTitle:(NSString *)alertTitle
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationBecomeInactive" object:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationBecomeActive" object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return  UIInterfaceOrientationMaskPortrait;
}

-(void)performAppearance
{
    //Init styles
	id appearance;
    
    //Navigation bar
    appearance = [UINavigationBar appearanceWhenContainedIn:[UINavigationController class], nil];
    
    [appearance setTintColor:APP_BLUE_COLOR_TINT];
//    [appearance setBarTintColor:[UIColor clearColor]];
//    [appearance setTranslucent:YES];
    
    
    //[appearance setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    
    //[appearance setShadowImage:[UIImage new]];
    
    //[appearance setBackIndicatorImage:[UIImage imageNamed:@"Icn-Navbar-Back-Normal.png"]];
    
    [appearance setTitleTextAttributes:@{
                                         NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Medium" size:17],
                                         NSForegroundColorAttributeName: [UIColor blackColor]
                                         }];
    
    appearance = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationController class], nil];
    
    appearance = [UINavigationBar appearanceWhenContainedIn:[ClearNavigationViewController class], nil];
    [appearance setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    
}
#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Skylock" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Skylock.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
    return wasHandled;
}

@end
