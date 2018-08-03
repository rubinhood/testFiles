//
//  CustomTabBarVC.m
//  ZyimeStudent
//
//  Created by Telugu Desham  on 01/12/17.
//  Copyright © 2017 QuickTechnosoft. All rights reserved.
//

#import "CustomTabBarVC.h"
#import "UIColor+ColorHex.h"
#import "AppDelegate.h"
#import "SliderMenuVC.h"
#import "MailVC.h"
#import "CharityVC.h"
#import "SettingsVC.h"
#import "ProfileVC.h"

@interface CustomTabBarVC () <sliderMenuDelegates>

@end

@implementation CustomTabBarVC
{
    AppDelegate *appDelegate;
    SliderMenuVC *slideMenu;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.definesPresentationContext = YES;
    // Do any additional setup after loading the view.
    [self hiddenExistingTabBar];
    
    if(self.viewControllers.count == 0) {
        NSLog(@"Error for tabbar");
    }
    
    [self selectViewControllerFromTabBar:[_mTabBarItemsArray objectAtIndex:0]];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTabbarUIUpdate:) name:kNotificationSliderDrawerClosed object:nil];
    
    // Slider menu....
    appDelegate = [AppDelegate appDelegate];
    appDelegate.sliderHide = YES;
    
    slideMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"SliderMenuVC"];
    [slideMenu.view setFrame:CGRectMake(-[[UIScreen mainScreen] bounds].size.width, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    slideMenu.view.tag = 50002;
    UIView *view = [slideMenu.view viewWithTag:50001];
    view.alpha = 0;
    slideMenu.delegate = self;
    [appDelegate.window addSubview:slideMenu.view];

    
    
    
}


- (void) showProfileData {
    
    
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void) showProfile {
    [self selectViewControllerFromTabBar:[_mTabBarItemsArray objectAtIndex:3]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hiddenExistingTabBar {
    
    for(UIView *view in self.view.subviews) {
        if([view isKindOfClass:[UITabBar class]]) {
            //view.hidden = YES;
            UIView *tabbarView = [[[NSBundle mainBundle] loadNibNamed:@"CustomTabBar" owner:self options:nil] lastObject]; // "MyTabBar" is the name of the .xib file
            tabbarView.frame = view.bounds;
            [view addSubview:tabbarView];
            break;
        }
        else {
            //            view.hidden = YES;
        }
    }
}
- (IBAction)selectViewControllerFromTabBar:(UIButton*)sender {
    for(UIButton *btn in _mTabBarItemsArray) {
        btn.selected = NO;
        UIButton *button = [btn.superview viewWithTag:11];
        button.selected =  NO;
        UILabel *label = [btn.superview viewWithTag:12];
        label.textColor = [UIColor darkGrayColor];
    }
    
    sender.selected =  YES;
    UIButton *button = [sender.superview viewWithTag:11];
    button.selected =  YES;
    UILabel *label = [sender.superview viewWithTag:12];
    label.textColor = [UIColor HexColorWithAlpha:0xff86D2C1];
    if(sender.tag < 4)
        self.selectedIndex = sender.tag;
    
    else {
        
        //self.selectedIndex = 0;
        [appDelegate sliderMenuAction];
        NSLog(@"%@", NSStringFromClass([self.selectedViewController class]));
 
    }
}


- (void) getTabbarUIUpdate:(NSNotification *) notification {
    
    for(UIButton *btn in _mTabBarItemsArray) {
        btn.selected = NO;
        UIButton *button = [btn.superview viewWithTag:11];
        button.selected =  NO;
        UILabel *label = [btn.superview viewWithTag:12];
        label.textColor = [UIColor darkGrayColor];
    }

    UIButton *sender = [_mTabBarItemsArray objectAtIndex:self.selectedIndex];
    sender.selected =  YES;
    UIButton *button = [sender.superview viewWithTag:11];
    button.selected =  YES;
    UILabel *label = [sender.superview viewWithTag:12];
    label.textColor = [UIColor HexColorWithAlpha:0xff86D2C1];
    if(sender.tag < 4)
        self.selectedIndex = sender.tag;
    
    else {
        
        //self.selectedIndex = 0;
        [appDelegate sliderMenuAction];
        NSLog(@"%@", NSStringFromClass([self.selectedViewController class]));
        
    }

    
    
}

#pragma mark - Menu Delegate
- (void)sliderMenu_clickedIndexPath:(NSString *)menustring {
    
    [appDelegate sliderMenuAction];
    [self.navigationController popToRootViewControllerAnimated:NO];
    NSLog(@"user selected : %@", menustring);
    
    if ([menustring isEqualToString:@"Mail"]) {
        MailVC *mailController = [self.storyboard instantiateViewControllerWithIdentifier:@"MailVC"];
        [self.navigationController pushViewController:mailController animated:YES];
        
    }else if ([menustring isEqualToString:@"Charity"]) {
        CharityVC *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CharityVC"];
        [self.navigationController pushViewController:controller animated:YES];
        
    }else if ([menustring isEqualToString:@"Settings"]) {
        SettingsVC *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsVC"];
        [self.navigationController pushViewController:controller animated:YES];
        
    }else if ([menustring isEqualToString:@"Profile"]) {
        ProfileVC *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileVC"];
        [self.navigationController pushViewController:controller animated:YES];
        
    }
    
    else if ([menustring isEqualToString:@"Logout"]) {
        [[AppDelegate appDelegate] logout];

        
    } else {}
    
}

@end
