//
//  CXLosed_View.m
//  ixcode
//
//  Created by DCX on 16/4/28.
//  Copyright © 2016年 macmac. All rights reserved.
//

#import "CXLosed_View.h"
#import "UIView+DCX.h"
#import "UIColor+DCX.h"
#import "UIImageView+WebCache.h"
#define __font(__size) [UIFont systemFontOfSize:__size]


@interface CXLosed_View ()

@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * imageURL;
@property (nonatomic,strong) NSString * companyName;

@property (nonatomic,strong) UILabel * infoLabel;

@end

@implementation CXLosed_View

- (void)setName:(NSString *)name image:(NSString *)imageURL companyName:(NSString *)companyName {
    self.name = name;
    self.imageURL = imageURL;
    self.companyName = companyName;

    for (UIView * view in self.subviews) {
        [view removeFromSuperview];
    }
    
    [self initView];
}

- (void)initView {
    
    UIImage * image = [UIImage imageNamed:@"fangkuang01"];
    NSInteger leftCapWidth = image.size.width * 0.5f;
    NSInteger topCapHeight = image.size.height * 0.5f;
    image = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    
    UIImageView * bgImageView = [[UIImageView alloc] initWithImage:image];
    bgImageView.frame = self.bounds;
    [self addSubview:bgImageView];
    
    
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(0, 0, self.frame.size.width/2 + 7, self.frame.size.height);
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageURL]];
    [self addSubview:imageView];
    
    UIImageView * angleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_suipian"]];
    angleImageView.frame = CGRectMake(imageView.frameRight-37, 0, 37, 32);
    [imageView addSubview:angleImageView];
    
    
    [self addSubview:[self rightView]];
    
}

- (UIView *)rightView {
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 + 7,0, self.frame.size.width/2 - 7, self.frame.size.height)];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, view.frame.size.width, 16)];
    label.text = @"你失败了，丢失掉";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = __font(16);
    label.textColor = RGB_COLOR(63, 63, 63);
    [view addSubview:label];
    
    UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, label.frameBottom + 11, view.frameWidth, 12)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = __font(12);
    nameLabel.text = _name;
    nameLabel.textColor = RGB_COLOR(102, 102, 102);
    [view addSubview:nameLabel];
    
    _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, view.frameBottom - 30, view.frameWidth, 10)];
    _infoLabel.textAlignment = NSTextAlignmentCenter;
    _infoLabel.font = __font(10);
    _infoLabel.text = [NSString stringWithFormat:@"本礼品由%@提供",self.companyName];
    _infoLabel.textColor = RGB_COLOR(254, 0, 0);
    [view addSubview:_infoLabel];
    
    return view;
}

@end
