//
//  UIColor+ColorHex.h
//  TaxiApp
//
//  Created by Venkat on 31/03/17.
//  Copyright © 2017 Quick Technosoft Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorHex)

+ (UIColor *)HexColorWithAlpha:(uint32_t)hexColor;

@end
