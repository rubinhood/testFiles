//
//  HomeVC.h
//  GiftInTime
//
//  Created by Telugu Desham  on 08/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

@interface HomeVC : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *mPictureScroller;
@property (weak, nonatomic) IBOutlet UIPageControl *mPageController;

@property (weak, nonatomic) IBOutlet UIView *mPlayerVu;
@property (weak, nonatomic) IBOutlet UIButton *mPlayerControlBtn;

@property (weak, nonatomic) IBOutlet UIWebView *mYTPlayer;


@property (weak, nonatomic) IBOutlet UIButton *mProfileBtn;

@property (weak, nonatomic) IBOutlet UILabel *mWelcomeMsg;

@property (weak, nonatomic) IBOutlet UILabel *mUserPoints;


@end
