//
//  SliderMenuVC.h
//  TaxiApp
//
//  Created by Quick on 9/29/16.
//  Copyright © 2016 Quick Technosoft Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol sliderMenuDelegates <NSObject>

- (void)sliderMenu_clickedIndexPath:(NSString *)menustring;

@end


@interface SliderMenuVC : UIViewController

@property(weak, nonatomic) id <sliderMenuDelegates> delegate;

@property (weak, nonatomic) IBOutlet UIView *black_view;
@property (weak, nonatomic) IBOutlet UIImageView *profile_imgView;
@property (weak, nonatomic) IBOutlet UILabel *name_lbl;
@property (weak, nonatomic) IBOutlet UILabel *email_lbl;


@property (weak, nonatomic) IBOutlet UITableView *table_view;

@property (weak, nonatomic) IBOutlet UIView *mProfileOuterView;

@end
