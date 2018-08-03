//
//  ForgotPassVC.m
//  GiftInTime
//
//  Created by Telugu Desham  on 29/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import "ForgotPassVC.h"
#import "CommonUtils.h"

@interface ForgotPassVC () <UITextFieldDelegate, ApiServiceDelegate>

@end

@implementation ForgotPassVC

{
    UITextField *mTextField;
    CGFloat mKBHeight;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _mEmailAddress.delegate = self;
    
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


- (IBAction) actionForgetPassword:(id)sender {
    if(![self verifyFields]) {
        
        return;
    }
    

    NSMutableDictionary *params = [[[NSDictionary alloc] initWithObjectsAndKeys:_mEmailAddress.text ,@"email", nil] mutableCopy];
    
    [self.view endEditing:YES];
    
    [[HTTPConnection sharedInstance] apiCall_HTTPConnection:[params mutableCopy] withFile:FILE_FORGOT_PASSWORD withHUD:self.view withServiceDelegate:self withServiceCall:SERVICE_FORGOT_PASSWORD];
    
    
}

- (void) onSuccessApiCall:(NSDictionary *)responseDict withServiceCall:(int)serviceNumber {
    if(serviceNumber == SERVICE_FORGOT_PASSWORD) {
        [KSToastView ks_showToast:responseDict[@"message"]];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) onFailureApiCall:(NSDictionary *)data withServiceCall:(int)serviceNumber {
    if(serviceNumber == SERVICE_FORGOT_PASSWORD) {
        [KSToastView ks_showToast:@"Login Failure"];
        
    }
    
}


- (Boolean) verifyFields {
    if([_mEmailAddress.text isEqualToString: @""]) {
        [KSToastView ks_showToast:@"Please enter your mobile number"];
        return NO;
        
    }else if([CommonUtils validateEmailWithString:_mEmailAddress.text]) {
        [KSToastView ks_showToast:@"Please enter Valid email address"];
        return NO;
    }
    
    return YES;
    
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


- (IBAction)backToPreviousController:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
