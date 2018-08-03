//
//  SignupVC.h
//  GiftInTime
//
//  Created by Telugu Desham  on 08/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupVC : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *mFirstName;

@property (weak, nonatomic) IBOutlet UITextField *mLastName;

@property (weak, nonatomic) IBOutlet UITextField *mEmail;
@property (weak, nonatomic) IBOutlet UITextField *mCreatePassword;
@property (weak, nonatomic) IBOutlet UITextField *mConfirmPassword;
@property (weak, nonatomic) IBOutlet UIScrollView *mSignupScrollVu;
@property (weak, nonatomic) IBOutlet UITextField *mBirthDate;
@property (assign, nonatomic)  BOOL mIsSignFirst;
@end
