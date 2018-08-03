//
//  AppDelegate.h
//  ZyimeStudent
//
//  Created by Telugu Desham  on 16/11/17.
//  Copyright © 2017 QuickTechnosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (nonatomic) BOOL sliderHide;

- (void)saveContext;
- (void)sliderMenuAction;
+ (AppDelegate *) appDelegate;
- (void)saveContext;
- (void) logout;

@end

