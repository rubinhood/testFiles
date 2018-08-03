//
//  CategoryDetailsVC.h
//  GiftInTime
//
//  Created by Telugu Desham  on 09/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryDetailsVC : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *mProductCollection;
@property (strong, nonatomic) NSDictionary  *mCategoryDetail;
@property (weak, nonatomic) IBOutlet UILabel *mTitleLabel;
@end
