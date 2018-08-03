//
//  SignupVC.m
//  GiftInTime
//
//  Created by Telugu Desham  on 08/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import "SignupVC.h"
#import "LoginVC.h"
#import "DatePickerVC.h"
#import "NSDate+DateFunctions.h"

@interface SignupVC ()<UITextFieldDelegate, DatePickerProtocol, ApiServiceDelegate>

@end

@implementation SignupVC

{
    UITextField *mTextField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _mFirstName.delegate = self;
    _mLastName.delegate = self;
    _mCreatePassword.delegate = self;
    _mConfirmPassword.delegate = self;
    _mEmail.delegate = self;
    _mBirthDate.delegate = self;

    _mBirthDate.inputView = [[UIView alloc] initWithFrame:CGRectZero];
    _mBirthDate.inputAccessoryView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%@",self.navigationController.viewControllers);
}

- (IBAction)inputTheDate:(id)sender {
    [_mBirthDate resignFirstResponder];
    DatePickerVC *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DatePickerVC"];
    controller.delegate = self;
    [controller setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;

    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:controller animated:YES completion:nil];
    
    
}

- (void) dateFromDatePickerSelected:(NSDate *)date {
    
    _mBirthDate.text = [NSDate convertDateToStringWithFormat:date withformat:@"dd/MM/yyyy" ];
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

- (void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillShowNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillHideNotification];
    [super viewWillDisappear:animated];
}


- (void)singleTapClicked:(UITapGestureRecognizer *)gesture {
    [self dismissKeyboard];
}


// emails validation...
- (BOOL)isValidEmailAddress:(NSString *)emailAddress {
    
    //Create a regex string
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" ;
    
    //Create predicate with format matching your regex string
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    
    //return true if email address is valid
    return [emailTest evaluateWithObject:emailAddress];
}

- (BOOL) validateFields {
    
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *messageStr = nil;
    BOOL invalid = NO;
    
    if ([self.mFirstName.text length] == 0 || [[self.mFirstName.text stringByTrimmingCharactersInSet:whitespace] length] == 0) {
        messageStr = @"Please enter first name";
        invalid = YES;
    }
    else if ([self.mLastName.text length] == 0 || [[self.mLastName.text stringByTrimmingCharactersInSet:whitespace] length] == 0) {
        messageStr = @"Please enter last name";
        invalid = YES;

    }
    else if ([self.mEmail.text length] == 0 || [[self.mEmail.text stringByTrimmingCharactersInSet:whitespace] length] == 0) {
        messageStr = @"Please enter email id";
        invalid = YES;

    }
    else if (![self isValidEmailAddress:self.mEmail.text]) {
        messageStr = @"Please enter valid mail";
        invalid = YES;

    }
    
    else if ([self.mCreatePassword.text length] == 0 || [[self.mCreatePassword.text stringByTrimmingCharactersInSet:whitespace] length] == 0) {
        messageStr = @"Please enter password";
        invalid = YES;

    }
    else if ([self.mCreatePassword.text length] < 6 || [self.mCreatePassword.text length] > 8) {
        messageStr = @"Password must be 6 to 8 characters";
        invalid = YES;

    }
    else if ([self.mConfirmPassword.text length] == 0 || [[self.mConfirmPassword.text stringByTrimmingCharactersInSet:whitespace] length] == 0) {
        messageStr = @"Please enter confirm password";
        invalid = YES;

    }
    else if (![self.mConfirmPassword.text isEqualToString:self.mConfirmPassword.text]) {
        messageStr = @"Password and confirm password mismatch";
        invalid = YES;

    }else if (self.mBirthDate.text.length == 0) {
        messageStr = @"Please agree to our terms and condition";
        invalid = YES;

    }
    if(invalid){
        [KSToastView ks_showToast:messageStr];
    }
    
    return invalid ;

}


#pragma mark - ButtonActions
- (IBAction)registerButtonClicked:(UIButton *)sender {
    
    if([self validateFields]) {
        return;
    }
    [self dismissKeyboard];
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"];
    if (deviceToken == nil) {
        deviceToken = @"3955386a738f7bbd40e12f670ef5f101b259a366";
        deviceToken = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    // parameter with data....
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:self.mFirstName.text forKey:@"firstname"];
    [parameters setObject:self.mLastName.text forKey:@"lastname"];
    [parameters setObject:self.mEmail.text forKey:@"email"];
    
    
    [parameters setObject:self.mCreatePassword.text forKey:@"password"];
    [parameters setObject:self.mConfirmPassword.text forKey:@"password_confirmation"];
    [parameters setObject:@(1234456700) forKey:@"push_token"];
    [parameters setObject:@"iphone" forKey:@"devicetype"];
    NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    NSString *country = [currentLocale displayNameForKey:NSLocaleCountryCode value:countryCode];
    [parameters setObject:_mBirthDate.text forKey:@"date_of_birth"];
    [parameters setObject:country forKey:@"geo_location"];
    
    [[HTTPConnection sharedInstance] apiCall_HTTPConnection:parameters withFile:FILE_SIGNUP withHUD:self.view withServiceDelegate:self withServiceCall:SERVICE_SIGNUP];
    
    
}


- (void)onSuccessApiCall:(NSDictionary *)data withServiceCall:(int)serviceNumber {
    if(serviceNumber == SERVICE_SIGNUP) {
        if([data[@"code"] intValue] == 201) {
            [KSToastView ks_showToast:data[@"message"]];
            NSDictionary *profile = data[@"user"];
            NSString *tokenString = profile[AUTH_KEY];
            [[NSUserDefaults standardUserDefaults] setObject:profile forKey:USER_PROFILE];
            
            [[NSUserDefaults standardUserDefaults] setObject:tokenString forKey:AUTH_KEY];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self moveToHomeScreen];
        }else {
            [KSToastView ks_showToast:data[@"message"]];
        }
    }
    
}

- (void)onFailureApiCall:(NSDictionary *)data withServiceCall:(int)serviceNumber {
    if(serviceNumber == SERVICE_SIGNUP) {
            [KSToastView ks_showToast:data[@"message"]];
        
    }
}

- (IBAction)backToLoginButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - UITextFieldDelegate
/*
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    mTextField = textField;
    if(textField == _mBirthDate) {
        return NO;
        //[_mBirthDate resignFirstResponder];
        [self inputTheDate:nil];
    }
    return  YES;
}*/
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    mTextField = textField;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Keyboard Notifications

- (void)keyboardWillShow:(NSNotification *)note {
    if(mTextField == _mBirthDate) {
        [_mBirthDate resignFirstResponder];
    }
    NSDictionary* info = [note userInfo];
    CGRect keyboardInfoFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // get the height of the keyboard by taking into account the orientation of the device too
    CGRect windowFrame = [self.view.window convertRect:self.view.frame fromView:self.view];
    CGRect keyboardFrame = CGRectIntersection (windowFrame, keyboardInfoFrame);
    CGRect coveredFrame = [self.view.window convertRect:keyboardFrame toView:self.view];
    
    // add the keyboard height to the content insets so that the scrollview can be scrolled
    UIEdgeInsets contentInsets = UIEdgeInsetsMake (0.0, 0.0, coveredFrame.size.height, 0.0);
    _mSignupScrollVu.contentInset = contentInsets;
    _mSignupScrollVu.scrollIndicatorInsets = contentInsets;
    
    // make sure the scrollview content size width and height are greater than 0
    [_mSignupScrollVu setContentSize:CGSizeMake (_mSignupScrollVu.contentSize.width, _mSignupScrollVu.contentSize.height +20)];
    
    
}

- (void)keyboardWillHide:(NSNotification *)note {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _mSignupScrollVu.contentInset = contentInsets;
    _mSignupScrollVu.scrollIndicatorInsets = contentInsets;
    
}


- (void) moveToHomeScreen {
    // changing root view controller
    UINavigationController *homevc = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomTabBarVC"];
    [UIApplication sharedApplication].delegate.window.rootViewController = homevc;
        
}
- (IBAction)moveToLoginScreen:(id)sender {
    if(_mIsSignFirst) {
        LoginVC *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self.navigationController pushViewController:controller animated:YES];
        
    }else {
        [self.navigationController popViewControllerAnimated:YES];
        
    }

    
}


- (void)dismissKeyboard {
    [self.view endEditing:YES];
   
}



@end
