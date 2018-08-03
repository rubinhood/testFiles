//
//  UIColor+ColorHex.m
//  TaxiApp
//
//  Created by Venkat on 31/03/17.
//  Copyright © 2017 Quick Technosoft Pvt. Ltd. All rights reserved.
//

#import "UIColor+ColorHex.h"

@implementation UIColor (ColorHex)

+ (UIColor *)HexColorWithAlpha:(uint32_t)hexColor {
    return [UIColor colorWithRed:((float)((hexColor & 0x00FF0000) >> 16))/255.0 \
                green:((float)((hexColor & 0x0000FF00) >>  8))/255.0 \
                 blue:((float)((hexColor & 0x000000FF) >>  0))/255.0 \
                    alpha:((float)((hexColor & 0xFF000000) >>  24))/255.0];
}

@end
