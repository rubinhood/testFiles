//
//  EditProfileVC.m
//  GiftInTime
//
//  Created by Telugu Desham  on 16/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import "EditProfileVC.h"
#import "PECropViewController.h"
#import "ChangePassVC.h"
#import "NSDate+DateFunctions.h"
#import "DatePickerVC.h"

@interface EditProfileVC () <UINavigationControllerDelegate,UIImagePickerControllerDelegate, PECropViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate, ApiServiceDelegate, DatePickerProtocol, UIPickerViewDelegate,UIPickerViewDataSource >

@end

@implementation EditProfileVC

{
    UIImagePickerController *mImagePicker;
    UIPopoverController *mPopover;
    UIImage *mImageProfile;
    bool mIsPrimaryImage;
    UITextField *mTextField;
    UIPickerView *mPickerVu;
    NSMutableArray *mCountryArray;
    NSMutableArray *mStateArray;
    NSDictionary *mSelectedCountry;
    NSDictionary *mSelectedState;
    UIDatePicker *mDatePicker;
    NSDate *mSelectedDate;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    mCountryArray = [[NSMutableArray alloc] init];
    mStateArray =  [[NSMutableArray alloc] init];
    
    
    _mFirstName.delegate =self;
    _mLastName.delegate = self;
    _mEmail.delegate = self;
    _mPhone.delegate = self;
    _mBirthdayDay.delegate = self;
    _mBirthdayYEar.delegate = self;
    _mBirthdayMonth.delegate = self;
    
    _mAddress1.delegate = self;
    _mAddress2.delegate = self;

    _mCity.delegate = self;
    _mZipcode.delegate = self;
    _mState.delegate = self;
    _mCountry.delegate = self;
    
    /*
    [_mBirthdayDay addTarget:self action:@selector(inputTheDate) forControlEvents:UIControlEventEditingDidBegin];
    [_mBirthdayMonth addTarget:self action:@selector(inputTheDate) forControlEvents:UIControlEventEditingDidBegin];
    [_mBirthdayYEar addTarget:self action:@selector(inputTheDate) forControlEvents:UIControlEventEditingDidBegin];*/
    
    
    [self setUpDatePicker:_mBirthdayMonth];
    [self setUpDatePicker:_mBirthdayYEar];
    [self setUpDatePicker:_mBirthdayDay];

    //[mDatePicker setDate:[self getSelectedDate] ];
    
    [_mCountry addTarget:self action:@selector(getCountryOption) forControlEvents:UIControlEventEditingDidBegin];
    //[_mBirthdayMonth addTarget:self action:@selector(getStateOption) forControlEvents:UIControlEventEditingDidBegin];

    [self displayUserData];
    [self getCountryList];
    [self getStateList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) displayUserData {
    NSDictionary *userProfile = [[NSUserDefaults standardUserDefaults] objectForKey:USER_PROFILE];
    _mFirstName.text = [NSString stringWithFormat:@"%@",userProfile[@"firstname"]];
    
    _mLastName.text = [NSString stringWithFormat:@"%@",userProfile[@"lastname"]];
    _mEmail.text = userProfile[@"email"];
    _mPhone.text = userProfile[@"billing_address"][@"phone"];
    NSDate *bdate = [NSDate stringToDateConversion:userProfile[@"date_of_birth"] withStringFormat:@"yyyy-MM-dd"];
    _mBirthdayMonth.text = [NSDate convertDateToStringWithFormat:bdate withformat:@"MM"];
    
    _mBirthdayDay.text = [NSDate convertDateToStringWithFormat:bdate withformat:@"dd"];
    _mBirthdayYEar.text = [NSDate convertDateToStringWithFormat:bdate withformat:@"yyyy"];
    
    _mAddress1.text = userProfile[@"billing_address"][@"address1"];
    _mAddress2.text = userProfile[@"billing_address"][@"address2"];
    _mCity.text = userProfile[@"billing_address"][@"city"];
    
    _mState.text =  userProfile[@"billing_address"][@"state_name"];
    _mZipcode.text =  userProfile[@"billing_address"][@"zipcode"];
    
    mSelectedCountry = userProfile[@"billing_address"][@"country_data"] ;
    mSelectedState = userProfile[@"billing_address"][@"state_data"] ;
    if(mSelectedCountry != nil)
        _mCountry.text = userProfile[@"billing_address"][@"country_data"][@"name"];
    if(mSelectedState != nil)
        _mState.text = userProfile[@"billing_address"][@"state_data"][@"name"];
    
    [_mProfileImage sd_setImageWithURL:[NSURL URLWithString:userProfile[@"profile_picture"]] placeholderImage:DataInstance.mBlankImage];

}

- (void)inputTheDate {
    /*if (_mBirthdayYEar.isFirstResponder )
        [_mBirthdayYEar resignFirstResponder];
    if (_mBirthdayMonth.isFirstResponder )
        [_mBirthdayMonth resignFirstResponder];
    if (_mBirthdayDay.isFirstResponder )
        [_mBirthdayDay resignFirstResponder];*/
    
    //[self.view endEditing:YES];
    DatePickerVC *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DatePickerVC"];
    controller.delegate = self;
    [controller setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:controller animated:YES completion:nil];
    
    
}

- (void) getCountryOption {
    if(mCountryArray.count == 0) {
        [self.view endEditing:YES];
        [self getCountryOption];
        [KSToastView ks_showToast:@"No Country data available"];
        return;
    }
    
    
    
}
- (void) getStateOption {
    if(mStateArray.count == 0) {
        [self.view endEditing:YES];
        if(mSelectedCountry != nil) {
            [self getStateOption];
        }else {
            [KSToastView ks_showToast:@"First Enter the Country"];
  
        }
        return;
    }
}



- (void) dateFromDatePickerSelected:(NSDate *)bdate {
    NSString *stringDate = [NSDate convertDateToStringWithFormat:bdate withformat:@"dd-MM-yyyy"];
    NSLog(@"%@",stringDate);
    if(stringDate == nil)
        return;
    _mBirthdayMonth.text = [NSDate convertDateToStringWithFormat:bdate withformat:@"MM"];
    _mBirthdayDay.text = [NSDate convertDateToStringWithFormat:bdate withformat:@"dd"];
    _mBirthdayYEar.text = [NSDate convertDateToStringWithFormat:bdate withformat:@"yyyy"];
    
}
- (IBAction)backToPreviousController:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // keyboard notifications ...
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillShowNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillHideNotification];
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
    UIEdgeInsets contentInsets = UIEdgeInsetsMake (0.0, 0.0, coveredFrame.size.height, 0.0);
    _mProfileScrollVu.contentInset = contentInsets;
    _mProfileScrollVu.scrollIndicatorInsets = contentInsets;
    
    // make sure the scrollview content size width and height are greater than 0
    [_mProfileScrollVu setContentSize:CGSizeMake (_mProfileScrollVu.contentSize.width, _mProfileScrollVu.contentSize.height)];
    
}


- (void)keyboardWillHide:(NSNotification *)note {
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _mProfileScrollVu.contentInset = contentInsets;
    _mProfileScrollVu.scrollIndicatorInsets = contentInsets;
    
}

- (IBAction)getUserProfileImage:(UIButton*)sender {
    
    
    if(sender.tag == 11) {
        mIsPrimaryImage = YES;
        
    }else {
        mIsPrimaryImage = NO;

    }
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Photo Slection" message:@"Please select image of your documents" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self cameraSelected:nil];
        
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self photoGallerySelected:nil];
        
        
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    
    actionSheet.popoverPresentationController.sourceView = self.view;
    actionSheet.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0);
    [self presentViewController:actionSheet animated:YES
                     completion:nil];
    
    
    
}

- (void)photoGallerySelected:(id)sender {
    mImagePicker = [[UIImagePickerController alloc]init];
    mImagePicker.delegate = self;
    mImagePicker.allowsEditing = NO;
    mImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:mImagePicker animated:YES completion:NULL];
    
}

- (void)cameraSelected:(id)sender {
    mImagePicker = [[UIImagePickerController alloc] init];
    mImagePicker.delegate = self;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        mImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:mImagePicker animated:YES completion:NULL];
    } else {
        [KSToastView ks_showToast:@"Camera is not available"];
    }
}

#pragma mark - ImagePickerController Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = image;
    controller.keepingCropAspectRatio = YES;
    if(mIsPrimaryImage) {
        controller.cropAspectRatio = 1;
    }else {
        controller.cropAspectRatio = 2;

    }
    controller.rotationEnabled = YES;
    //controller.imageCropRect = CGRectMake((image.size.width  - 200) / 2 ,(image.size.height - 200) / 2,200,200);
    
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigationController animated:YES completion:^{
        
    }];
    
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage {
    [controller dismissViewControllerAnimated:YES completion:NULL];
    
    
    if(mIsPrimaryImage) {
        
        mImageProfile = [self imageWithImage:croppedImage scaledToSize:CGSizeMake(300, 300)];
        _mPrimaryProfile.image = mImageProfile ;

        
    }else {
        
        mImageProfile = [self imageWithImage:croppedImage scaledToSize:CGSizeMake(600, 300)];
        _mSecondaryProfile.image = mImageProfile ;


    }
   
    /*_mProfileImageView.layer.cornerRadius = _mProfileImageView.layer.frame.size.width/2;
     _mProfileImageView.layer.borderWidth = 4.0;
     _mProfileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
     _mProfileImageView.layer.masksToBounds = YES;*/
    
    
}

- (void) cropViewControllerDidCancel:(PECropViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize; {
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}


- (IBAction)changePassword:(id)sender {
    ChangePassVC *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePassVC"];
    [self.navigationController pushViewController:controller animated:YES];
    
}


- (BOOL) validateFieldsForFail {
    
    if([_mFirstName.text isEqualToString:@""]) {
        [KSToastView ks_showToast:@"Please enter your first name"];
        return NO;
    }else if([_mLastName.text isEqualToString:@""]) {
        [KSToastView ks_showToast:@"Please enter your last name"];
        return NO;
    }else if([_mPhone.text isEqualToString:@""]) {
        [KSToastView ks_showToast:@"Please enter your Phone Number"];
        return NO;
    }else if([_mBirthdayDay.text isEqualToString:@""]) {
        [KSToastView ks_showToast:@"Please enter birth day"];
        return NO;
    }else if([_mBirthdayMonth.text isEqualToString:@""]) {
        [KSToastView ks_showToast:@"Please enter birth day"];
        return NO;
    }else if([_mBirthdayYEar.text isEqualToString:@""]) {
        [KSToastView ks_showToast:@"Please enter birth day"];
        return NO;
    }else if([_mAddress1.text isEqualToString:@""]) {
        [KSToastView ks_showToast:@"Please enter your first address line"];
        return NO;
    }else if([_mCity.text isEqualToString:@""]) {
        [KSToastView ks_showToast:@"Please enter your city name"];
        return NO;
    }else if([_mZipcode.text isEqualToString:@""]) {
        [KSToastView ks_showToast:@"Please enter your address zipcode"];
        return NO;
    }else if([_mState.text isEqualToString:@""] || mSelectedState == nil) {
        [KSToastView ks_showToast:@"Please enter your state name"];
        return NO;
    }else if([_mCountry.text isEqualToString:@""] || mSelectedCountry == nil) {
        [KSToastView ks_showToast:@"Please enter your country name"];
        return NO;
    }
    
    
    return YES;
    
}


- (IBAction)updateProfile:(id)sender {
    if(![self validateFieldsForFail]) {
        return;
    }
    NSMutableDictionary *imageDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:mImageProfile,@"profile_image", nil];
    NSDictionary *userProfile = [[NSUserDefaults standardUserDefaults] objectForKey:USER_PROFILE];
    NSString *oldimage = [NSString stringWithFormat:@"%@%@",userProfile[@"image_path2"],userProfile[@"image_name"]];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init ];
    
    
    [parameters setObject:[NSString stringWithFormat:@"%@-%@-%@",_mBirthdayDay.text,_mBirthdayMonth.text,_mBirthdayYEar.text] forKey:@"date_of_birth"];
    
    [parameters setObject:_mPhone.text forKey:@"phone"];
    
    [parameters setObject:_mEmail.text forKey:@"email"];
    [parameters setObject:_mEmail.text forKey:@"address"];
    [parameters setObject:_mFirstName.text forKey:@"firstname"];
    [parameters setObject:_mLastName.text forKey:@"lastname"];

    [parameters setObject:_mCity.text forKey:@"city"];
    [parameters setObject:mSelectedState[@"id"] forKey:@"state_id"];
    [parameters setObject:mSelectedState[@"country_id"] forKey:@"country_id"];

    [parameters setObject:_mAddress1.text forKey:@"address1"];
    [parameters setObject:_mAddress2.text forKey:@"address2"];
    [parameters setObject:_mZipcode.text forKey:@"zipcode"];
    //[parameters setObject:@"iphone" forKey:@"device_type"];
    
    [parameters setObject:@"male" forKey:@"gender"];
    [parameters setObject:_mAddress1.text forKey:@"addr_private"];
    //[parameters setObject:@"Delhi" forKey:@"geo_location"];
    //[parameters setObject:@"12345678" forKey:@"push_token"];
    
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"];
    if (deviceToken == nil) {
        deviceToken = @"3955386a738f7bbd40e12f670ef5f101b259a366";
        deviceToken = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    // parameter with data....
    

    [parameters setObject:@(1234456700) forKey:@"push_token"];
    [parameters setObject:@"iphone" forKey:@"device_type"];
    NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    NSString *country = [currentLocale displayNameForKey:NSLocaleCountryCode value:countryCode];
    [parameters setObject:country forKey:@"geo_location"];

    NSString *tokenString =[[NSUserDefaults standardUserDefaults] objectForKey:AUTH_KEY];
    
    [parameters setObject:tokenString forKey:AUTH_KEY];
    NSString *url = [NSString stringWithFormat:@"%@%@",FILE_UPDATE_PROFILE,userProfile[@"user_id"]];
    
    [[HTTPConnection sharedInstance] apiCall_HTTPConnection:parameters images:imageDic withFile:url withHUD:self.view withServiceDelegate:self withServiceCall:SERVICE_UPDATE_PROFILE];
    
    
    
    
}


-(void) getCountryList  {
    [[HTTPConnection sharedInstance] apiGetCall_HTTPConnection:nil withFile:FILE_GET_COUNTRIES withHUD:self.view withServiceDelegate:self withServiceCall:SERVICE_GET_COUNTRIES];
}

-(void) getStateList  {
    if(mSelectedCountry == nil) {
        [KSToastView ks_showToast:@"Please Select country First"];
        return;
    }
    NSString *file = [NSString stringWithFormat:@"%@%@",FILE_GET_STATES,mSelectedCountry[@"id"]];
    [[HTTPConnection sharedInstance] apiGetCall_HTTPConnection:nil withFile:file withHUD:self.view withServiceDelegate:self withServiceCall:SERVICE_GET_STATES];
}
- (void) onSuccessApiCall:(NSDictionary *)data withServiceCall:(int)serviceNumber {
    if(serviceNumber == SERVICE_UPDATE_PROFILE) {
        NSDictionary *userProfile = data[@"user"];
        [[NSUserDefaults standardUserDefaults] setObject:userProfile forKey:USER_PROFILE];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationProfileUpdated object:nil];
        [self backToPreviousController:nil];
        
    }if(serviceNumber == SERVICE_GET_COUNTRIES) {
        if([data[@"code"] intValue]==200) {
            [mCountryArray removeAllObjects];
            [mCountryArray addObjectsFromArray:data[@"countries"]];
            [self setUpPicker:_mCountry];
        }
    }if(serviceNumber == SERVICE_GET_STATES) {
        if([data[@"code"] intValue]==200) {
            [mStateArray removeAllObjects];
            [mStateArray addObjectsFromArray:data[@"country"]];
            [self setUpPicker:_mState];
        }
        
    }
    
}

- (void) onFailureApiCall:(NSDictionary *)data withServiceCall:(int)seriviceNumber {
    
    
    
    
}

- (BOOL) isCharecterAcceptable:(UITextField*) textField rangeChars:(NSString*) rangeCharcters {
    NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:rangeCharcters];
    NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:textField.text];
    BOOL stringIsValid = [numbersOnly isSupersetOfSet:characterSetFromTextField];
    return stringIsValid;
    
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    mTextField = textField;
    if(textField == _mState) {
        [self getStateOption];
    }if(textField == _mBirthdayYEar || textField == _mBirthdayMonth || textField == _mBirthdayDay) {
        //[mDatePicker setDate:[self getSelectedDate]];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    if(textField == _mPhone) {
        return ([self isCharecterAcceptable:_mPhone rangeChars:PHONE_NUMBER_CHARECTERS]);
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Pickerview

- (void) setUpPicker:(UITextField *) sender {
    mPickerVu = [[UIPickerView alloc] init];
    mPickerVu.backgroundColor = [UIColor whiteColor];
    mPickerVu.delegate = self;
    mPickerVu.dataSource = self;
    UIToolbar *toolbar = [[UIToolbar alloc]init];
    [toolbar sizeToFit];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(showPickedDone)];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelPicker)];
    doneBtn.tintColor = [UIColor whiteColor];
    cancelBtn.tintColor = [UIColor whiteColor];
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
    target:nil action:nil];
    toolbar.translucent = NO;
    toolbar.barTintColor = [UIColor HexColorWithAlpha:APP_GREEN_COLOR];
    [toolbar setItems:[NSArray arrayWithObjects:cancelBtn,flexibleSpaceLeft, doneBtn , nil]];
    [sender setInputAccessoryView:toolbar];
    sender.inputView = mPickerVu;
    
}

- (void) showPickedDone {
    [self.view endEditing:YES];
    [self.view setUserInteractionEnabled:YES];
    if(mTextField == _mCountry) {
        _mCountry.text = mSelectedCountry[@"name"];
        mSelectedState = nil;
        _mState.text = @"";
        [mStateArray removeAllObjects];
        [self getStateList];
        
    }else if (mTextField == _mState){
        _mState.text = mSelectedState[@"name"];
    
    }

}


- (void) cancelPicker {
    [self.view endEditing:YES];
    [self.view setUserInteractionEnabled:YES];
}

#pragma mark - PickeRViewDelegates


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(mTextField == _mCountry)
        return mCountryArray.count;
    else {
        return mStateArray.count;
        
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(mTextField == _mCountry)
        return mCountryArray[row][@"name"];
    else
        return mStateArray[row][@"name"];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(mTextField == _mCountry)
        mSelectedCountry = mCountryArray[row];
    else
        mSelectedState = mStateArray[row];
}

#pragma mark - DatePickeRView

- (void) setUpDatePicker:(UITextField *) sender {
    mDatePicker = [[UIDatePicker alloc] init];
    [mDatePicker setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    mDatePicker.backgroundColor = [UIColor whiteColor];
    UIToolbar *toolbar = [[UIToolbar alloc]init];
    [toolbar sizeToFit];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(showSelectedDate)];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelSelectedDate)];
    doneBtn.tintColor = [UIColor whiteColor];
    cancelBtn.tintColor = [UIColor whiteColor];
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                       target:nil action:nil];
    toolbar.translucent = NO;
    toolbar.barTintColor = [UIColor HexColorWithAlpha:APP_GREEN_COLOR];
    [toolbar setItems:[NSArray arrayWithObjects:cancelBtn,flexibleSpaceLeft, doneBtn , nil]];
    [mDatePicker addTarget:self action:@selector(pickerChange:) forControlEvents:UIControlEventValueChanged];
    
    mDatePicker.maximumDate = [NSDate date];
    mDatePicker.date = [NSDate date];
    mDatePicker.datePickerMode = UIDatePickerModeDate;
    [sender setInputAccessoryView:toolbar];
    sender.inputView = mDatePicker;
    
}
- (void) showSelectedDate {
    // Call Reshedule API
    [self dateFromDatePickerSelected:mSelectedDate];
    [self.view endEditing:YES];
    [self.view setUserInteractionEnabled:YES];
}
- (void) cancelSelectedDate {
    [self.view endEditing:YES];
    [self.view setUserInteractionEnabled:YES];
    
}

- (void) pickerChange:(UIDatePicker*) datePicker {
    mSelectedDate = datePicker.date;
    NSLog(@"Date Selected -- %@",[NSDate convertDateToStringWithFormat:mSelectedDate withformat:@"dd/MM/yyyy" ]);
}

- (NSDate *) getSelectedDate {
    
    NSString *stringDate = [NSString stringWithFormat:@"%@-%@-%@",_mBirthdayDay.text,_mBirthdayMonth.text,_mBirthdayYEar.text];
    NSDateFormatter *dateFormattter = [[NSDateFormatter alloc] init];
    [dateFormattter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormattter setDateFormat:@"dd-MM-yyyy"];
    NSDate *date = [dateFormattter dateFromString:stringDate];
    return date;
}



@end
