//
//  UIColor+DCX.h
//  常用Category
//
//  Created by Ming on 15/12/28.
//  Copyright © 2015年 戴晨惜. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGB_COLOR(R, G, B) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:1]
#define RGBA_COLOR( R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]
#define HEX_COLOR(hexString) [UIColor colorWithHexString:hexString]

@interface UIColor (DCX)


+ (instancetype)colorWithHexString:(NSString *)hexString;
+ (instancetype)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;
+ (instancetype)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue;
+ (instancetype)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha;

- (NSString *)hexString;

@end
