//
//  AddressPendingRequestCell.h
//  GiftInTime
//
//  Created by Telugu Desham  on 18/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressPendingRequestCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mFrendsImage;
@property (weak, nonatomic) IBOutlet UILabel *mFrendsName;
@property (weak, nonatomic) IBOutlet UILabel *mFrendsRequestStatus;
@property (weak, nonatomic) IBOutlet UIButton *mFrendsRequestAgainBtn;

@end
