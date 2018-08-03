//
//  LoginVC.m
//  ZyimeStudent
//
//  Created by Telugu Desham  on 03/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import "LoginVC.h"
#import "SignupVC.h"
#import "CustomTabBarVC.h"
#import "ForgotPassVC.h"

@interface LoginVC () <UITextFieldDelegate , ApiServiceDelegate>

@end

@implementation LoginVC

{
    UITextField *mTextField;
    CGFloat mKBHeight;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _mEmail.delegate = self;
    _mPassword.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    
    // keyboard notifications ...
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [super viewWillAppear:animated];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%@",self.navigationController.viewControllers);
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillShowNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillHideNotification];
    [super viewWillDisappear:animated];
}

#pragma mark - Keyboard Notifications
- (void)keyboardWillShow:(NSNotification *)note {
    
    
    // Keyboard height....
    NSDictionary *userInfo = [note userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    mKBHeight = kbSize.height;
    // getting superviews for text filed...
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGPoint textFieldOrigin = [mTextField convertPoint:mTextField.frame.origin toView:window];
    textFieldOrigin.y = textFieldOrigin.y + mTextField.frame.size.height +20;
    CGFloat height = ([[UIScreen mainScreen] bounds].size.height) - textFieldOrigin.y;
    
    if (height+20 < mKBHeight) {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.frame = CGRectMake(0, -kbSize.height+height, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
    else {
        
    }
}

-(BOOL)prefersStatusBarHidden { return YES; }


- (void)keyboardWillHide:(NSNotification *)note {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}



#pragma mark - TextFieldDelegates

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    mTextField = textField;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)doLogin:(id)sender {
    if(![self verifyFields]) {
        
        return;
    }
    
    NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    NSString *country = [currentLocale displayNameForKey:NSLocaleCountryCode value:countryCode];
    NSMutableDictionary *params = [[[NSDictionary alloc] initWithObjectsAndKeys:_mEmail.text ,@"email",_mPassword.text,@"password",country,@"geo_location", nil] mutableCopy];
    
    [self.view endEditing:YES];
    
    [[HTTPConnection sharedInstance] apiCall_HTTPConnection:[params mutableCopy] withFile:FILE_LOGIN withHUD:self.view withServiceDelegate:self withServiceCall:SERVICE_LOGIN];

    
}

- (void) moveToHomeScreen {
    
    // changing root view controller
    UIViewController *homevc = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomTabBarVC"];
    //[self.navigationController pushViewController:homevc animated:YES];
    
    
    
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:homevc];
    naviController.navigationBarHidden = YES;
    [UIApplication sharedApplication].delegate.window.rootViewController = naviController;

}



- (IBAction)forgotPassword:(id)sender {
    ForgotPassVC *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPassVC"];
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (IBAction)moveToSignUpScreen:(id)sender {
    
    if(_mIsFirst) {
        SignupVC *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SignupVC"];
        [self.navigationController pushViewController:controller animated:YES];
        
    }else {
         [self.navigationController popViewControllerAnimated:YES];

    }
    
}




- (void) onSuccessApiCall:(NSDictionary *)responseDict withServiceCall:(int)serviceNumber {
    if(serviceNumber == SERVICE_LOGIN) {
        [KSToastView ks_showToast:responseDict[@"massage"]];

        NSDictionary *userProfile = responseDict[@"user"];
        NSString *tokenString = userProfile[AUTH_KEY];
        [[NSUserDefaults standardUserDefaults] setObject:userProfile forKey:USER_PROFILE];
        
        [[NSUserDefaults standardUserDefaults] setObject:tokenString forKey:AUTH_KEY];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self moveToHomeScreen];
        
    }
}

- (void) onFailureApiCall:(NSDictionary *)data withServiceCall:(int)serviceNumber {
    if(serviceNumber == SERVICE_LOGIN) {
        [KSToastView ks_showToast:@"Login Failure"];
        
    }
    
}


- (Boolean) verifyFields {
    if([_mEmail.text isEqualToString: @""]) {
        [KSToastView ks_showToast:@"Please enter your mobile number"];
        return NO;
        
    }else if([_mPassword.text isEqualToString: @""]) {
        [KSToastView ks_showToast:@"Please enter your mobile number of phone number"];
        return NO;
    }
    
    return YES;
    
}




@end
