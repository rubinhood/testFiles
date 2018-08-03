//
//  DatePickerVC.m
//  GiftInTime
//
//  Created by Telugu Desham  on 30/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import "DatePickerVC.h"

@interface DatePickerVC () < UIPickerViewDelegate>

@end


@implementation DatePickerVC


{
    
    
    NSString *mDay;
    NSString *mMonth;
    NSString *mYear;
    NSDateFormatter *mDayFormatter;
    NSDateFormatter *mMonthFormatter;
    NSDateFormatter *mYearFormatter;
}
    
    
- (void)viewDidLoad {
        [super viewDidLoad];
        // Do any additional setup after loading the view.
    mDayFormatter = [[NSDateFormatter alloc] init];
    [mDayFormatter setDateFormat:@"dd"];
    
    mMonthFormatter = [[NSDateFormatter alloc] init];
    [mMonthFormatter setDateFormat:@"MM"];
    
    
    mYearFormatter = [[NSDateFormatter alloc] init];
    [mYearFormatter setDateFormat:@"yyyy"];
    
    [self getDateComponents:_mDatePicker];


}
    
- (IBAction)canceldatePicker:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)selectDateFromDatePicker:(id)sender {
    
    if ([self.delegate conformsToProtocol:@protocol(DatePickerProtocol) ]) {
        //[self.delegate dateFromDatePickerSelected:mDay withMonth:mMonth withYear:mYear];
        [self.delegate dateFromDatePickerSelected:_mDatePicker.date];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dissmissCurrentController:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dateValueScrolled:(UIDatePicker *)datePicker {
    [self getDateComponents:datePicker];
}


- (void) getDateComponents : (UIDatePicker *)datePicker {
    
    mDay = [mDayFormatter stringFromDate:   datePicker.date];
    mMonth = [mMonthFormatter stringFromDate:   datePicker.date];
    mYear = [mYearFormatter stringFromDate:   datePicker.date];
}

@end
