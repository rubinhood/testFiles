//
//  EditProfileVC.h
//  GiftInTime
//
//  Created by Telugu Desham  on 16/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditProfileVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *mPrimaryProfile;
@property (weak, nonatomic) IBOutlet UIImageView *mSecondaryProfile;
@property (weak, nonatomic) IBOutlet UIScrollView *mProfileScrollVu;

@property (weak, nonatomic) IBOutlet UITextField *mFirstName;
@property (weak, nonatomic) IBOutlet UITextField *mLastName;

@property (weak, nonatomic) IBOutlet UITextField *mEmail;

@property (weak, nonatomic) IBOutlet UITextField *mPhone;

@property (weak, nonatomic) IBOutlet UITextField *mBirthdayMonth;

@property (weak, nonatomic) IBOutlet UITextField *mBirthdayDay;
@property (weak, nonatomic) IBOutlet UITextField *mBirthdayYEar;

@property (weak, nonatomic) IBOutlet UITextField *mAddress1;

@property (weak, nonatomic) IBOutlet UITextField *mAddress2;
@property (weak, nonatomic) IBOutlet UITextField *mCity;
@property (weak, nonatomic) IBOutlet UITextField *mZipcode;
@property (weak, nonatomic) IBOutlet UITextField *mState;
@property (weak, nonatomic) IBOutlet UITextField *mCountry;
@property (weak, nonatomic) IBOutlet UIImageView *mProfileImage;

@end
