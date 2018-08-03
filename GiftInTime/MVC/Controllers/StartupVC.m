//
//  StartupVC.m
//  GiftInTime
//
//  Created by Telugu Desham  on 08/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import "StartupVC.h"
#import "LoginVC.h"
#import "SignupVC.h"
#import "SocialLoginClass.h"

@interface StartupVC ()<SocialLoginClassDelegate>

@end

@implementation StartupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openLoginViewController:(id)sender {
    LoginVC *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    controller.mIsFirst = YES;
        [self.navigationController pushViewController:controller animated:YES];
    
}

- (IBAction)openSignupViewController:(id)sender {
    SignupVC *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SignupVC"];
    controller.mIsSignFirst = YES;
    [self.navigationController pushViewController:controller animated:YES];
    
    
}

- (IBAction)loginViaFacebook:(id)sender {
    [[SocialLoginClass sharedInstance] setDelegate:self];
    [[SocialLoginClass sharedInstance] initiateFacebookLoginFrom:self];
}

- (IBAction)loginViaTwitter:(id)sender {
    [[SocialLoginClass sharedInstance] setDelegate:self];
    [[SocialLoginClass sharedInstance] initiateTwitterLoginFrom:self];
}


- (IBAction)loginViaGoogle:(id)sender {
    [[SocialLoginClass sharedInstance] setDelegate:self];
    [[SocialLoginClass sharedInstance] initiateGoogleLoginFrom:self];
}




- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)removeKeyBoard {
    
    
}

- (BOOL)validateEmailOrPhone:(NSString *)text {
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    NSString *phoneRegex = @"^((\\+)|(00))[0-9]{6,14}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    if([emailTest evaluateWithObject:text] == NO && [phoneTest evaluateWithObject:text] == NO) {
        return YES;
        
    }else {
        return NO;
    }
    
}

- (void) onFacebokLoginCancelled {
    [KSToastView ks_showToast:@"Facebook cancelled"];
    
    
}
- (void) onFacebokLoginSuccess:(NSDictionary *)userLoginData {
    [KSToastView ks_showToast:@"Facebook Succes"];
    
}
- (void) onFacebokLoginFailed:(NSError *)error {
    [KSToastView ks_showToast:@"Facebook FAiled"];
    
}




@end
