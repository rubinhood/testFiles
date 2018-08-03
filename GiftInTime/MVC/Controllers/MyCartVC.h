//
//  MyCartVC.h
//  GiftInTime
//
//  Created by Telugu Desham  on 11/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCartVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *mProductDetailsTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mProductDetailsHeight;

@property (weak, nonatomic) IBOutlet UITableView *mSavedCardTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mSavedCardTableHeight;
@property (weak, nonatomic) IBOutlet UITableView *mPaymentOptionTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mPaymentOptionHeight;

@end
