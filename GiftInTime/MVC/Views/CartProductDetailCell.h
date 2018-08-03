//
//  CartProductDetailCell.h
//  GiftInTime
//
//  Created by Telugu Desham  on 16/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartProductDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mAddressHeight;
@property (weak, nonatomic) IBOutlet UIView *mAddressView;


@property (weak, nonatomic) IBOutlet UIButton *mShowAddressBtn;
@end
