//
//  SelectOccasionVC.h
//  GiftInTime
//
//  Created by Telugu Desham  on 10/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectOccasionVC : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mOccasionCollectionHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *mOccasionCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *mCardCollection;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mCardCollectionHeight;

@property (weak, nonatomic) IBOutlet UIImageView *mPreviewCard;

@property (weak, nonatomic) IBOutlet UIView *mCameraInformationBGVu;
@property (weak, nonatomic) IBOutlet UIView *mCameraInformation;

@end
