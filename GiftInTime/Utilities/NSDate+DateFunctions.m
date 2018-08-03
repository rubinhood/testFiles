//
//  NSDate+DateFunctions.m
//  ZyimeStudent
//
//  Created by Telugu Desham  on 06/03/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import "NSDate+DateFunctions.h"

@implementation NSDate (DateFunctions)


- (NSCalendar*) calendar{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    return calendar;
}

- (NSDate *) lastDayOfMonth {
    //NSDate *curDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekday fromDate:self]; // Get necessary date components
    
    // set last of month
    [comps setMonth:[comps month]+1];
    [comps setDay:0];
    NSDate *tDateMonth = [calendar dateFromComponents:comps];
    NSLog(@"%@", tDateMonth);
    
    return tDateMonth;
}

- (NSDate *) firstDayOfMonth {
    //NSDate *curDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekday fromDate:self]; // Get necessary date components
    
    // set last of month
    [comps setMonth:[comps month]];
    [comps setDay:1];
    NSDate *tFirstDateMonth = [calendar dateFromComponents:comps];
    NSLog(@"%@", tFirstDateMonth);
    
    return tFirstDateMonth;
}

+ (NSString *) convertStringDateFormat:(NSString *)date formatFrom:(NSString *)format1 formatFinal:(NSString *)format2{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:format1];
    NSDate *dateDate = [dateFormatter dateFromString:date];

    [dateFormatter setDateFormat:format2];
    NSString *dateString = [dateFormatter stringFromDate:dateDate];
    return dateString;

}

+ (NSString *) convertDateToStringWithFormat:(NSDate *)date withformat:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:format];
     NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (NSDate *) stringToDateConversion:(NSString *) dateString withStringFormat:(NSString *) dateFormate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter setDateFormat:dateFormate];
    NSDate *selectedDate = [formatter dateFromString:dateString];
    return selectedDate;
}
@end
