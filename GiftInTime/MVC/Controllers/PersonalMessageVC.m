//
//  PersonalMessageVC.m
//  GiftInTime
//
//  Created by Telugu Desham  on 11/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import "PersonalMessageVC.h"
#define PLACEHOLDER_TEXT  @"Write your personalized message here" 
#define CHARECTER_LIMIT  140

@interface PersonalMessageVC () <UITextViewDelegate>

@end

@implementation PersonalMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _mPersonalMessageTV.delegate = self;
    _mPersonalMessageTV.textContainerInset = UIEdgeInsetsMake(
                                                       8,-_mPersonalMessageTV.textContainer.lineFragmentPadding, 0,0);
    

    _mPersonalMessageTV.delegate =  self;
    
    _mPersonalMessageTV.text = PLACEHOLDER_TEXT;
    _mPersonalMessageTV.textColor = [UIColor lightGrayColor];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)messageHasBeenWritten:(id)sender {
}

- (IBAction)backToPreviousVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
    [self dismissKeyboard];
    [super viewWillDisappear:animated];
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
    UIEdgeInsets contentInsets = UIEdgeInsetsMake (0.0, 0.0, coveredFrame.size.height+50, 0.0);
    _mSupportScrollVu.contentInset = contentInsets;
    _mSupportScrollVu.scrollIndicatorInsets = contentInsets;
    
    // make sure the scrollview content size width and height are greater than 0
    //[_mSupportScrollVu setContentSize:CGSizeMake (_mSupportScrollVu.contentSize.width, _mSupportScrollVu.contentSize.height)];
}

- (void)keyboardWillHide:(NSNotification *)note {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _mSupportScrollVu.contentInset = contentInsets;
    _mSupportScrollVu.scrollIndicatorInsets = contentInsets;
    
    // _mSupportScrollVu.contentSize = CGSizeMake(_mSupportScrollVu.frame.size.width, _mSupportScrollVu.frame.size.height);

    
}


- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [self dismissKeyboard];
        return NO;
    }
    
    return textView.text.length + (text.length - range.length) <= CHARECTER_LIMIT;
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:PLACEHOLDER_TEXT]) {
        textView.text = @"";
        textView.textColor = [UIColor darkGrayColor]; //optional
    }
    [textView becomeFirstResponder];
}



- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = PLACEHOLDER_TEXT;
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}


@end
