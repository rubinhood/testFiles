//
//  ChangePassVC.h
//  GiftInTime
//
//  Created by Telugu Desham  on 29/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePassVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *mOldPass;
@property (weak, nonatomic) IBOutlet UITextField *mNewPass;
@property (weak, nonatomic) IBOutlet UITextField *mConfirmPass;
@property (weak, nonatomic) IBOutlet UIButton *mSendBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *mSignupScrollVu;

@end
