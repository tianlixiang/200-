//
//  CXHeaderView.m
//  ixcode
//
//  Created by DCX on 16/4/26.
//  Copyright © 2016年 macmac. All rights reserved.
//

#import "CXHeaderView.h"
#import "UIView+DCX.h"
#import "UIColor+DCX.h"
#import "UIImageView+WebCache.h"
#define __font(__size) [UIFont systemFontOfSize:__size]

@interface CXHeaderView ()
{
    
    
    UILabel * nameLabel;
    UILabel * hpLabel;
    UILabel * abLabel;
    UIImageView * headerImageView;
    UILabel * hp;
    UILabel * ab;
    
}
/** 名称 */
@property (nonatomic,strong) NSString * name;
/** 生命值 */
@property (nonatomic,strong) NSString * HPValue;
/** 战斗力 */
@property (nonatomic,strong) NSString * AbilityValue;
/** 默认 lift */
@property (nonatomic,assign) CXHeaderViewState state;
/** 头像 */
@property (nonatomic,strong) NSString * headerImageURL;

@property (nonatomic,strong) UIView * infoView;
@property (nonatomic,strong) UIView * headerView;


@end

static NSInteger kMultiple = 3;

@implementation CXHeaderView



- (void)setName:(NSString *)name hp:(NSString *)hpValue AbilityValue:(NSString *)AbilityValue headerImage:(NSString *)imageURL state:(CXHeaderViewState)state {

    self.name = name;
    self.HPValue = hpValue;
    self.AbilityValue = AbilityValue;
    self.headerImageURL = imageURL;
    self.state = state;
    
    [self.headerView removeFromSuperview];
    self.headerView = nil;
    
    [self.infoView removeFromSuperview];
    self.infoView = nil;
    [self initView];
}


- (void)initView {
    [self addSubview:self.headerView];
    [self addSubview:self.infoView];
}

- (UIView *)headerView {
    if (!_headerView) {
    
        CGFloat viewx = _state == CXHeaderView_lift ? 18: self.frameWidth - 36 ;
        
        UIImageView * bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(viewx, 0, 36, 53)];
        bgImageView.image = [UIImage imageNamed:@"touxiang_kuang touying"];
        
        UIImageView * bgImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(-10, 0, 36, 53)];
        bgImageView1.image = [UIImage imageNamed:@"touxiang_heisetouxiangkuang"];
        [bgImageView addSubview:bgImageView1];
        
        headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 34, 34)];
        [headerImageView sd_setImageWithURL:[NSURL URLWithString:_headerImageURL]];
        headerImageView.clipsToBounds = YES;
        [headerImageView.layer setCornerRadius:17];
        [bgImageView1 addSubview:headerImageView];
        
        _headerView = bgImageView;
    }
    return _headerView;
}

- (UIView *)infoView {
    if (!_infoView) {
        
        CGFloat viewx = _state == CXHeaderView_lift ? 53: self.frameWidth/2 - 53;
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(viewx, 0, self.frameWidth /2 , self.frameHeight)];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, view.frameWidth, 8)];
        NSTextAlignment nameAm = _state == CXHeaderView_lift ? NSTextAlignmentLeft : NSTextAlignmentRight;
        nameLabel.textAlignment = nameAm;
        nameLabel.font = __font(8);
        nameLabel.text = _name;
        nameLabel.textColor = RGB_COLOR(63, 63, 63);
        [view addSubview:nameLabel];
        
        hpLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, nameLabel.frameBottom+6, view.frameWidth, 8)];
        NSTextAlignment hpAm = _state == CXHeaderView_lift ? NSTextAlignmentLeft : NSTextAlignmentRight;
        hpLabel.textAlignment = hpAm;
        hpLabel.font = __font(8);
        hpLabel.text = [NSString stringWithFormat:@"生命值：%@",_HPValue];
        hpLabel.textColor = RGB_COLOR(63, 63, 63);
        [view addSubview:hpLabel];
        
        CGFloat hpWitdth = [self gethpWidth:[_HPValue integerValue]];
        CGFloat hpx = _state == CXHeaderView_lift ? 0 : view.frameWidth - (hpWitdth/kMultiple);
        hp = [[UILabel alloc]initWithFrame:CGRectMake(hpx, hpLabel.frameBottom + 2, hpWitdth / kMultiple, 4)];
        hp.backgroundColor = RGB_COLOR(117, 239, 58);
        [view addSubview:hp];
        
        abLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, hpLabel.frameBottom + 7, view.frameWidth, 8)];
        NSTextAlignment abAm = _state == CXHeaderView_lift ? NSTextAlignmentLeft : NSTextAlignmentRight;
        abLabel.textAlignment = abAm;
        abLabel.font = __font(8);
        abLabel.text = [NSString stringWithFormat:@"战斗力：%@",_AbilityValue];
        abLabel.textColor = RGB_COLOR(63, 63, 63);
        [view addSubview:abLabel];
        
        CGFloat abWitdth = [self gethpWidth:[_AbilityValue integerValue]];
        CGFloat abx = _state == CXHeaderView_lift ? 0 : view.frameWidth - (abWitdth/kMultiple);
        ab = [[UILabel alloc]initWithFrame:CGRectMake(abx, abLabel.frameBottom + 2, abWitdth / kMultiple, 4)];
        ab.backgroundColor = RGB_COLOR(244, 167, 53);
        [view addSubview:ab];
        
        _infoView = view;
    }
    return _infoView;
}


- (CGFloat )gethpWidth:(NSInteger )value {
    CGFloat witdth = 0;
    
    if (value <= 1000) {
        witdth = value/1000 * 25;
    }
    if ( value <= 10000  && value > 1000) {
        witdth = 25 + (value - 1000)/9000 * 25;
    }
    if ( value <= 50000  && value > 10000) {
        witdth = 50 + (value - 10000)/40000 * 25;
    }
    if ( value <= 100000  && value > 50000) {
        witdth = 75 + (value - 50000)/50000 * 25;
    }
    if (value > 100000) {
        witdth = 100 + (value - 100000)/900000 * 25;
    }
    witdth = witdth>125? 125:witdth;
    return witdth;
}

@end
