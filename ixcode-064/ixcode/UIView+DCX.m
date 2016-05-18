//
//  UIView+DCX.m
//  常用Category
//
//  Created by Ming on 15/12/15.
//  Copyright © 2015年 戴晨惜. All rights reserved.
//

#import "UIView+DCX.h"

#pragma mark - **************** View Rect 属性配置 ****************

@implementation UIView (ViewRect)

- (CGPoint)frameOrigin {
    return self.frame.origin;
}

- (void)setFrameOrigin:(CGPoint)frameOrigin {
    CGRect frame = self.frame;
    frame.origin = frameOrigin;
    self.frame = frame;
}

- (CGSize)frameSize {
    return self.frame.size;
}

- (void)setFrameSize:(CGSize)frameSize {
    CGRect frame = self.frame;
    frame.size = frameSize;
    self.frame = frame;
}

- (CGFloat)frameTop {
    return CGRectGetMinX(self.frame);
}

- (void)setFrameTop:(CGFloat)frameTop {
    CGRect frame = self.frame;
    frame.origin.y = frameTop;
    self.frame = frame;
}

- (CGFloat)frameBottom {
    return CGRectGetMaxY(self.frame);
}

- (void)setFrameBottom:(CGFloat)frameBottom {
    CGRect frame = self.frame;
    frame.origin.y = frameBottom - self.frameHeight;
    self.frame = frame;
}

- (CGFloat)frameWidth {
    return CGRectGetWidth(self.frame);
}

- (void)setFrameWidth:(CGFloat)frameWidth {
    CGRect frame = self.frame;
    frame.size.width = frameWidth;
    self.frame = frame;
}

- (CGFloat)frameHeight {
    return CGRectGetHeight(self.frame);
}

- (void)setFrameHeight:(CGFloat)frameHeight {
    CGRect frame = self.frame;
    frame.size.height = frameHeight;
    self.frame = frame;
}

- (CGFloat)frameLeft {
    return CGRectGetMinX(self.frame);
}

- (void)setFrameLeft:(CGFloat)frameLeft {
    CGRect frame = self.frame;
    frame.origin.x = frameLeft;
    self.frame = frame;
}

- (CGFloat)frameRight {
    return CGRectGetMaxX(self.frame);
}

- (void)setFrameRight:(CGFloat)frameRight {
    CGRect frame = self.frame;
    frame.origin.x = frameRight - self.frameWidth;
    self.frame = frame;
}

- (CGFloat)centerX {
    return CGRectGetMidX(self.frame);
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return CGRectGetMidY(self.frame);
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
    
}

- (void)setRadius:(CGFloat)radius {
    self.layer.cornerRadius = radius;
}

- (void)CXLogRect {
    NSLog(@"%@",[NSString stringWithFormat:@"x : %lf , y = %lf \n            width = %lf , height = %lf",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height]);
}

@end
