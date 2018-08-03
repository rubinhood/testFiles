//
//  DatePickerVC.h
//  GiftInTime
//
//  Created by Telugu Desham  on 30/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol DatePickerProtocol <NSObject>

- (void) dateFromDatePickerSelected:(NSString *) day withMonth:(NSString *) month withYear:(NSString *) year;
- (void) dateFromDatePickerSelected:(NSDate*)date;


@end


@interface DatePickerVC : UIViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *mDatePicker;

@property (assign, nonatomic)   id<DatePickerProtocol> delegate;

@end
