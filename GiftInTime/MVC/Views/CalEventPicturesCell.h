//
//  CalEventPicturesCell.h
//  GiftInTime
//
//  Created by Telugu Desham  on 19/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Contacts/Contacts.h>

@interface CalEventPicturesCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mEventPicView;
@property (weak, nonatomic) IBOutlet UIView *mEventPicBgView;
@property (strong, nonatomic) CNContact *contacts;

@end
