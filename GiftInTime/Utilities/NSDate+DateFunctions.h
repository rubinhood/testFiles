//
//  NSDate+DateFunctions.h
//  ZyimeStudent
//
//  Created by Telugu Desham  on 06/03/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DateFunctions)

- (NSDate *) lastDayOfMonth ;
- (NSDate *) firstDayOfMonth ;
+ (NSString *) convertStringDateFormat:(NSString *)date formatFrom:(NSString *)format1 formatFinal:(NSString *)format2;
+ (NSString *) convertDateToStringWithFormat:(NSDate *)date withformat:(NSString *)format;
+ (NSDate *) stringToDateConversion:(NSString *) dateString withStringFormat:(NSString *) dateFormate  ;
@end
