//
//  AppDelegate.m
//  ZyimeStudent
//
//  Created by Telugu Desham  on 16/11/17.
//  Copyright © 2017 QuickTechnosoft. All rights reserved.
//

#import "AppDelegate.h"
#import "CustomTabBarVC.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Bolts/Bolts.h>
#import "LoginVC.h"
#import "StartupVC.h"
#import "IQKeyboardManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    // move to home screen if user already login..
    NSDictionary *userProfile = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserProfile"];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    if (userProfile != nil) {
        // changing root view controller
        CustomTabBarVC *homevc = [storyboard instantiateViewControllerWithIdentifier:@"CustomTabBarVC"];
        UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:homevc];
        naviController.navigationBarHidden = YES;
        [UIApplication sharedApplication].delegate.window.rootViewController = naviController;
    }
    


    return YES;
}

- (void)initKeyboard {
    
    //ONE LINE OF CODE.
    //Enabling keyboard manager(Use this line to enable managing distance between keyboard & textField/textView).
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    //(Optional)Set Distance between keyboard & textField, Default is 10.
    //[[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:15];
    
    //(Optional)Enable autoToolbar behaviour. If It is set to NO. You have to manually create UIToolbar for keyboard. Default is NO.
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
    //(Optional)Setting toolbar behaviour to IQAutoToolbarBySubviews to manage previous/next according to UITextField's hierarchy in it's SuperView. Set it to IQAutoToolbarByTag to manage previous/next according to UITextField's tag property in increasing order. Default is `IQAutoToolbarBySubviews`.
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarBySubviews];
    
    //(Optional)Resign textField if touched outside of UITextField/UITextView. Default is NO.
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    //[[IQKeyboardManager sharedManager] setOverrideKeyboardAppearance:YES];
    //[[IQKeyboardManager sharedManager] previousNextDisplayMode] = //IQPreviousNextDisplayModeAlwaysShow;
    //(Optional)Giving permission to modify TextView's frame. Default is NO.
    //[[IQKeyboardManager sharedManager] setCanAdjustTextView:YES];
    
    //(Optional)Show TextField placeholder texts on autoToolbar. Default is NO.
    [[IQKeyboardManager sharedManager] setShouldShowTextFieldPlaceholder:YES];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                    ];
    // Add any custom logic here.
    return handled;
}



- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation
                    ];
    // Add any custom logic here.
    return handled;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Helpers
+ (AppDelegate *) appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void) logout {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserProfile"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIStoryboard *stroyb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginVC *login = [stroyb instantiateViewControllerWithIdentifier:@"StartupVC"];
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:login];
    naviController.navigationBarHidden = YES;
    [UIApplication sharedApplication].delegate.window.rootViewController = naviController;
    
    
}



- (void)sliderMenuAction {
    
    UIView *sliderView = [self.window viewWithTag:50002];
    UIView *view = [sliderView viewWithTag:50001];
    [self.window bringSubviewToFront:sliderView];
    
    if (!self.sliderHide) {
        view.alpha = 0;
        self.sliderHide = YES;
        /*
         [UIView animateWithDuration:0.5 animations:^{
         sliderView.frame = CGRectMake(-[[UIScreen mainScreen] bounds].size.width, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
         } completion:^(BOOL finished) {
         }];*/
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSliderDrawerClosed object:nil];
        
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            sliderView.frame = CGRectMake(-[[UIScreen mainScreen] bounds].size.width, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        } completion:^(BOOL finished) {
            
        }];
        
    }
    else {
        
        self.sliderHide = NO;
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            sliderView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        } completion:^(BOOL finished) {
            view.alpha = 0.2;
            
        }];
        /*
         [UIView animateWithDuration:0.5 animations:^{
         sliderView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
         } completion:^(BOOL finished) {
         view.alpha = 0.2;
         
         }];*/
    }
}
#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"GiftInTime"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
