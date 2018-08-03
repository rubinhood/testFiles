//
//  ProfileVC.h
//  GiftInTime
//
//  Created by Telugu Desham  on 18/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileVC : UIViewController

@property (weak, nonatomic) IBOutlet UIView *mMyWishlistVu;
@property (weak, nonatomic) IBOutlet UICollectionView *mMyWishlistCollection;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mMywishlistHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *mFrendzWishlistCollection;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mFrendzWishlistHeight;

@property (weak, nonatomic) IBOutlet UIScrollView *mProfileScrollVu;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mAddressRequestHeight;
@property (weak, nonatomic) IBOutlet UITableView *mAddressRequestTable;



@property (weak, nonatomic) IBOutlet UIImageView *mProfileImage;

@property (weak, nonatomic) IBOutlet UILabel *mProfileName;

@property (weak, nonatomic) IBOutlet UIButton *mGiftingPointsBtn;
@property (weak, nonatomic) IBOutlet UILabel *mMyWishlistCount;

@property (weak, nonatomic) IBOutlet UILabel *mFrendzWishlistCount;

@end
