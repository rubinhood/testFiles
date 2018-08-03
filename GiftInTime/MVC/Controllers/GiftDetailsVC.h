//
//  GiftDetailsVC.h
//  GiftInTime
//
//  Created by Telugu Desham  on 09/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditableResponderBtn.h"

@interface GiftDetailsVC : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *mOtherCollection;
@property (weak, nonatomic) IBOutlet UIScrollView *mPictureScroll;
@property (weak, nonatomic) IBOutlet UIPageControl *mPageControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mOtherColectionHeight;
@property (strong, nonatomic) NSDictionary *mProductData;

@property (weak, nonatomic) IBOutlet UILabel *mProductName;

@property (weak, nonatomic) IBOutlet UILabel *mByStore;

@property (weak, nonatomic) IBOutlet UILabel *mOriginalPrice;
@property (weak, nonatomic) IBOutlet UILabel *mDiscountedPrice;
@property (weak, nonatomic) IBOutlet UILabel *mDiscountPercentage;

@property (weak, nonatomic) IBOutlet UILabel *mProductDetails;

@property (weak, nonatomic) IBOutlet UILabel *mShippingDetails;
@property (weak, nonatomic) IBOutlet UILabel *mSelectedOption;
@property (weak, nonatomic) IBOutlet EditableResponderBtn *mOptionsBtn;

@end
