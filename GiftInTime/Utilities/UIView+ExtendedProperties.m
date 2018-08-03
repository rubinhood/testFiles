//
//  UIView+ExtendedProperties.m
//  TaxiApp
//
//  Created by Telugu Desham  on 28/07/17.
//  Copyright © 2017 Quick Technosoft Pvt. Ltd. All rights reserved.
//

#import "UIView+ExtendedProperties.h"

@implementation UIView (ExtendedProperties)

@dynamic borderColor,borderWidth,cornerRadius, cornerAndShadow, shadowColor, shadowOpacity, shadowRadius, shadowOffset, masksToBounds;


-(void)setBorderColor:(UIColor *)borderColor{
    [self.layer setBorderColor:borderColor.CGColor];
    [self setNeedsDisplay];
}

-(void)setBorderWidth:(CGFloat)borderWidth{
    [self.layer setBorderWidth:borderWidth];
    [self setNeedsDisplay];

}

-(void)setCornerRadius:(CGFloat)cornerRadius{
    [self.layer setCornerRadius:cornerRadius];
    [self setNeedsDisplay];

}

-(void)setShadowColor:(UIColor *)shadowColor{
    [self.layer setShadowColor:shadowColor.CGColor];
    [self setNeedsDisplay];

    
}

-(void)setShadowOpacity:(CGFloat)shadowOpacity{
    [self.layer setShadowOpacity:shadowOpacity];
    [self setNeedsDisplay];

}

-(void)setShadowRadius:(CGFloat)shadowRadius{
    [self.layer setShadowRadius:shadowRadius];
    [self setNeedsDisplay];

}

-(void)setMasksToBounds:(BOOL)masksToBounds{
    [self.layer setMasksToBounds:masksToBounds];
    [self setNeedsDisplay];

}


-(void) layoutSubviews {
    
    UIBezierPath *shadowPath = [UIBezierPath
                                bezierPathWithRoundedRect: self.bounds
                                cornerRadius: self.layer.cornerRadius];
    
    
    self.layer.shadowColor = self.layer.shadowColor;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = self.layer.shadowOpacity;
    self.layer.shadowPath = shadowPath.CGPath;
    [self setNeedsDisplay];

    
}


@end
