//
//  CalEventsCell.h
//  GiftInTime
//
//  Created by Telugu Desham  on 19/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalEventsCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *mTopLine;
@property (weak, nonatomic) IBOutlet UIView *mBottomLine;
@property (weak, nonatomic) IBOutlet UILabel *mEventName;
@property (weak, nonatomic) IBOutlet UILabel *mDateString;
@property (weak, nonatomic) IBOutlet UICollectionView *mPicCollection;

@property (strong, nonatomic) NSArray *mPics;

@end
