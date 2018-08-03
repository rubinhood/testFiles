//
//  AddressCell.h
//  GiftInTime
//
//  Created by Telugu Desham  on 16/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mFullName;
@property (weak, nonatomic) IBOutlet UILabel *mEmail;
@property (weak, nonatomic) IBOutlet UIButton *mWishlistBtn;
@property (weak, nonatomic) IBOutlet UIButton *mGiftnowBtn;
@property (weak, nonatomic) IBOutlet UILabel *mColorLabel;

@end
