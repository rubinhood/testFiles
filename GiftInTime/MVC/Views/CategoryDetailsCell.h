//
//  CategoryDetailsCell.h
//  GiftInTime
//
//  Created by Telugu Desham  on 09/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryDetailsCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mProductImage;
@property (weak, nonatomic) IBOutlet UILabel *mProductPrice;
@property (weak, nonatomic) IBOutlet UIButton *mProductFavBtn;
@property (weak, nonatomic) IBOutlet UIButton *mProductGiftBtn;

@property (weak, nonatomic) IBOutlet UILabel *mProductName;

@property (weak, nonatomic) IBOutlet UILabel *mProductCityState;
@property (weak, nonatomic) IBOutlet UILabel *mProductBy;


@end
