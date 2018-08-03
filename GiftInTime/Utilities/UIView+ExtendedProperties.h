//
//  UIView+ExtendedProperties.h
//  TaxiApp
//
//  Created by Telugu Desham  on 28/07/17.
//  Copyright © 2017 Quick Technosoft Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ExtendedProperties)

@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable CGFloat cornerAndShadow;

@property (nonatomic) IBInspectable UIColor *shadowColor;
@property (nonatomic) IBInspectable CGFloat shadowOpacity;
@property (nonatomic) IBInspectable CGFloat shadowRadius;
@property (nonatomic) IBInspectable CGFloat shadowOffset;



@property (nonatomic) IBInspectable BOOL masksToBounds;

@end
