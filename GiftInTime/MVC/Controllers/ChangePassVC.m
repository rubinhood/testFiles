//
//  ChangePassVC.m
//  GiftInTime
//
//  Created by Telugu Desham  on 29/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import "ChangePassVC.h"

@interface ChangePassVC () <UITextFieldDelegate, ApiServiceDelegate>

@end

@implementation ChangePassVC

{
    UITextField *mTextField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _mOldPass.delegate = self;
    _mNewPass.delegate = self;
    _mConfirmPass.delegate = self;
    
    
    
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%@",self.navigationController.viewControllers);
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

- (IBAction)backToLoginButtonClicked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - UITextFieldDelegate
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
    
    NSDictionary* info = [note userInfo];
    CGRect keyboardInfoFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // get the height of the keyboard by taking into account the orientation of the device too
    CGRect windowFrame = [self.view.window convertRect:self.view.frame fromView:self.view];
    CGRect keyboardFrame = CGRectIntersection (windowFrame, keyboardInfoFrame);
    CGRect coveredFrame = [self.view.window convertRect:keyboardFrame toView:self.view];
    
    // add the keyboard height to the content insets so that the scrollview can be scrolled
    UIEdgeInsets contentInsets = UIEdgeInsetsMake (0.0, 0.0, coveredFrame.size.height +10, 0.0);
    _mSignupScrollVu.contentInset = contentInsets;
    _mSignupScrollVu.scrollIndicatorInsets = contentInsets;
    
    // make sure the scrollview content size width and height are greater than 0
    ///[_mSignupScrollVu setContentSize:CGSizeMake (_mSignupScrollVu.contentSize.width, _mSignupScrollVu.contentSize.height +40)];
    
    
}

- (void)keyboardWillHide:(NSNotification *)note {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _mSignupScrollVu.contentInset = contentInsets;
    _mSignupScrollVu.scrollIndicatorInsets = contentInsets;
    
}



- (void)dismissKeyboard {
    [self.view endEditing:YES];
    
}

- (IBAction)changePasswordButtonClicked:(UIButton *)sender {
    
    // fileds validations...
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *messageStr = nil;
    if ([_mOldPass.text length] == 0 || [[_mOldPass.text stringByTrimmingCharactersInSet:whitespace] length] == 0) {
        messageStr = @"Please enter your current password";
    }
    else if ([_mNewPass.text length] < 6 || [_mNewPass.text length] > 8) {
        messageStr = @"Password must be 6 to 8 characters";
    }
    else if ([_mConfirmPass.text length] == 0 || [[_mConfirmPass.text stringByTrimmingCharactersInSet:whitespace] length] == 0) {
        messageStr = @"Please enter confirm password";
    }
    else if (![_mNewPass.text isEqualToString:_mConfirmPass.text]) {
        messageStr = @"Password and confirm password mismatch";
    }
    else {}
    
    // display alert message...
    if (messageStr != nil) {
        [KSToastView ks_showToast:messageStr];
    }
    
    else {
        [self.view endEditing:YES];
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
        NSDictionary *UserProfile = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserProfile"];
        //[parameters setObject:[NSString stringWithFormat:@"%@", _mCountryCode.currentTitle] forKey:@"ph_code"];
        [parameters setObject:_mOldPass.text forKey:@"current_password"];
        [parameters setObject:_mNewPass.text forKey:@"password"];
        [parameters setObject:_mConfirmPass.text forKey:@"password_confirmation"];
        [parameters setObject:UserProfile[AUTH_KEY] forKey:AUTH_KEY];
        
        
        [[HTTPConnection sharedInstance] apiCall_HTTPConnection:parameters withFile:FILE_CHANGE_PASSWORD withHUD:self.view withServiceDelegate:self withServiceCall:SERVICE_CHANGE_PASSWORD];
    }
    
}



- (void) onSuccessApiCall:(NSDictionary *)data withServiceCall:(int)serviceNumber {
    if([data[@"code"] intValue]==201) {
        if([data objectForKey:@"massage"] != nil)
            if(![data[@"massage"] isEqualToString:@""])
                [KSToastView ks_showToast:[data objectForKey:@"message"]];
        
        [KSToastView ks_showToast:@"Success ! Password changed. Please Login to continue"];
        [self.navigationController popViewControllerAnimated:YES];
        //[[AppDelegate appDelegate] logout];
    }
    
}

- (void) onFailureApiCall:(NSDictionary *)data withServiceCall:(int)serviceNumber {
    [KSToastView ks_showToast:[data objectForKey:@"message"]];
    
}



@end
