//
//  CXLoseView.m
//  ixcode
//
//  Created by DCX on 16/4/26.
//  Copyright © 2016年 macmac. All rights reserved.
//

#import "CXLoseView.h"
#import "UIView+DCX.h"
#import "UIColor+DCX.h"
#import "UIImageView+WebCache.h"
#define __font(__size) [UIFont systemFontOfSize:__size]

@interface CXLoseView ()
{
    dispatch_source_t _timer;
}
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * price;
@property (nonatomic,strong) NSString * imageURL;
@property (nonatomic,assign) NSInteger time;

@property (nonatomic,strong) UILabel * timeLabel;

@end

@implementation CXLoseView


- (void)setName:(NSString *)name price:(NSString *)price image:(NSString *)imageURL time:(NSInteger )time {
    self.name = name;
    self.price = price;
    self.imageURL = imageURL;
    self.time = time;
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
    for (UIView * view in self.subviews) {
        [view removeFromSuperview];
    }
    
    [self initView];
    [self startTime];
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
    
    [self addSubview:[self rightView]];
    
}

- (UIView *)rightView {
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 + 7,0, self.frame.size.width/2 - 7, self.frame.size.height)];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, view.frame.size.width, 16)];
    label.text = @"您即将失去";
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
    
    UILabel * priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, nameLabel.frameBottom + 7, view.frameWidth, 7)];
    priceLabel.font = __font(7);
    priceLabel.textAlignment = NSTextAlignmentCenter;
    priceLabel.text = [NSString stringWithFormat:@"价值%@元",_price];
    priceLabel.textColor = RGB_COLOR(102, 102, 102);
    [view addSubview:priceLabel];
    
    UILabel * infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, priceLabel.frameBottom + 10, view.frameWidth, 10)];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.font = __font(10);
    infoLabel.text = @"请尽快增强实力参与开始战斗";
    infoLabel.textColor = RGB_COLOR(254, 0, 0);
    [view addSubview:infoLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, view.frameBottom - 27, view.frameWidth, 10)];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.textColor = RGB_COLOR(63, 63, 63);
    NSInteger h = _time/3600;
    NSInteger f = (_time%3600)/60;
    NSInteger s = (_time%3600)%60;
    if (h<10) {
        _timeLabel.text = [NSString stringWithFormat:@"失去倒计时:0%ld:%ld:%ld",h,f,s];
    }else {
        _timeLabel.text = [NSString stringWithFormat:@"失去倒计时:%ld:%ld:%ld",h,f,s];
    }
    _timeLabel.font = __font(10);
    [view addSubview:_timeLabel];
    
    return view;
}

-(void)startTime{
    
    __block NSInteger timeout=_time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_timeLabel setText:@"倒计时结束"];
                self.userInteractionEnabled = YES;
            });
        }else{
            NSInteger h = timeout/3600;
            NSInteger f = (timeout%3600)/60;
            NSInteger s = (timeout%3600)%60;
            NSString *strTime = nil;
            if (h<10) {
                strTime = [NSString stringWithFormat:@"失去倒计时:0%ld:%ld:%ld",h,f,s];
            }else {
                strTime = [NSString stringWithFormat:@"失去倒计时:%ld:%ld:%ld",h,f,s];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_timeLabel setText:[NSString stringWithFormat:@"%@",strTime]];
                self.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
