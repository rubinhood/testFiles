//
//  CategoriesVC.h
//  GiftInTime
//
//  Created by Telugu Desham  on 12/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoriesVC : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *mCategoriesCollection;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mCategoriesCollectionHeight;

@property (weak, nonatomic) IBOutlet UIButton *mProfileBtn;
@property (weak, nonatomic) IBOutlet UILabel *mWelcomeMsg;
@property (weak, nonatomic) IBOutlet UILabel *mUserPoints;


@end
