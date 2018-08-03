//
//  CommonUtils.m
//  GiftInTime
//
//  Created by Telugu Desham  on 20/03/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import "CommonUtils.h"

@implementation CommonUtils
+ (BOOL)validateEmailWithString:(NSString*)email
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return ![emailTest evaluateWithObject:email];
}
@end
