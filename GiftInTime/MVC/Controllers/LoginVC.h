//
//  LoginVC.h
//  GiftInTime
//
//  Created by Telugu Desham  on 08/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *mEmail;
@property (weak, nonatomic) IBOutlet UITextField *mPassword;

@property (assign, nonatomic)  BOOL mIsFirst;

@end
