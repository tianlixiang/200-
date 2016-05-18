//
//  UIView+DCX.h
//  常用Category
//
//  Created by Ming on 15/12/15.
//  Copyright © 2015年 戴晨惜. All rights reserved.
//

#import <UIKit/UIKit.h>



#pragma mark - **************** drawRect ****************

@interface UIView (ViewRect)

@property (nonatomic,assign) CGPoint    frameOrigin;
@property (nonatomic,assign) CGSize     frameSize;

@property (nonatomic,assign) CGFloat    frameTop;
@property (nonatomic,assign) CGFloat    frameBottom;

@property (nonatomic,assign) CGFloat    frameWidth;
@property (nonatomic,assign) CGFloat    frameHeight;

@property (nonatomic,assign) CGFloat    frameLeft;
@property (nonatomic,assign) CGFloat    frameRight;

@property (nonatomic,assign) CGFloat    centerX;
@property (nonatomic,assign) CGFloat    centerY;

- (void)setRadius:(CGFloat)radius;

- (void)CXLogRect;

@end

