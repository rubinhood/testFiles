//
//  AddContactVC.h
//  GiftInTime
//
//  Created by Telugu Desham  on 16/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddContactVC : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *mProfileScrollVu;
@property (weak, nonatomic) IBOutlet UIButton *mContactProfile;



@property (weak, nonatomic) IBOutlet UITextField *mFirstName;
@property (weak, nonatomic) IBOutlet UITextField *mFamilyName;
@property (weak, nonatomic) IBOutlet UITextField *mEmail;
@property (weak, nonatomic) IBOutlet UITextField *mPhone;
@property (weak, nonatomic) IBOutlet UITextField *mAddress;
@property (weak, nonatomic) IBOutlet UITextField *mAddress2;
@property (weak, nonatomic) IBOutlet UITextField *mCity;
@property (weak, nonatomic) IBOutlet UITextField *mPostCode;
@property (weak, nonatomic) IBOutlet UITextField *mState;

@property (weak, nonatomic) IBOutlet UITextField *mCountryName;


@end
