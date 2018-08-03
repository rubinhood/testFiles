//
//  CalendarVC.h
//  GiftInTime
//
//  Created by Telugu Desham  on 19/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendar.h"

@interface CalendarVC : UIViewController
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *mCalendarView;

@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *mCalenderView;
@property (strong, nonatomic) JTCalendarManager *mCalendarManager;
@property (strong, nonatomic) IBOutlet JTHorizontalCalendarView *mMainCalendar;
@property (weak, nonatomic) IBOutlet UILabel *mCalanderMonthLabel;



// Table view

@property (weak, nonatomic) IBOutlet UITableView *mEventTableVu;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mEventTableVuHeight;


// Gift popup view

@property (weak, nonatomic) IBOutlet UIView *mGiftPopupVu;

@property (weak, nonatomic) IBOutlet UIView *mGiftPopupDialogueVu;

@property (weak, nonatomic) IBOutlet UIImageView *mGiftPopupVuImage;

@property (weak, nonatomic) IBOutlet UILabel *mGiftPopLabelName;

@property (weak, nonatomic) IBOutlet UILabel *mGiftPopupPhoneNumber;

// Sync contact/fb view

@property (weak, nonatomic) IBOutlet UIView *mSyncMainVu;

@property (weak, nonatomic) IBOutlet UIView *mSyncDialogueVu;




@end
