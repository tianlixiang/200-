//
//  CX_AllTableViewCell.m
//  ixcode
//
//  Created by Ming on 16/1/4.
//  Copyright © 2016年 macmac. All rights reserved.
//

#import "CX_AllTableViewCell.h"
#import "UIColor+DCX.h"
#define screen_width [UIScreen mainScreen].bounds.size.width

@interface CX_AllTableViewCell()
{
    UILabel * _nameLabel; /**<- 名字*/
    UILabel * _stateLabel;  /**<- 状态*/

    UIImageView * _iconImageView; /**<- 图片*/
    UILabel * _detailNameLabel; /**<- 详细 名称*/
    UILabel * _detailStateLabel; /**<- 详细 类别*/
    UILabel * _detailNumberLabel; /**<- 详细 数目*/
    
    UILabel * _priceLabel; /**<- 价格*/
    UIButton * _deteleButton; /**<- 删除 按钮*/
    UIButton * _returnButton; /**<- 脱货 按钮*/
    
    
}
@property (nonatomic,copy)CXButtonBolock block;

@end

@implementation CX_AllTableViewCell

#pragma mark - **************** 初始化单元格 ****************
+(instancetype)cellWithTableView:(UITableView *)tableView indentifier:(NSString *)indentifier
{
    CX_AllTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indentifier];
    if(!cell){
        cell=[[CX_AllTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self.contentView addSubview:[self topView]];
        [self.contentView addSubview:[self detailView]];
        [self.contentView addSubview:[self bottomView]];
    }
    
    return self;
}

- (UIView *)topView {
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 44)];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, (topView.frame.size.height - 10))];
    
    _nameLabel.font = [UIFont systemFontOfSize:14];
    
    _nameLabel.textColor = [UIColor colorWithHexString:@"0x252525"];
    
    [topView addSubview:_nameLabel];
    
    _stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(220, 5, screen_width - 230, (topView.frame.size.height - 10))];
    _stateLabel.textColor = [UIColor colorWithHexString:@"0xff3366"];
    
    _stateLabel.textAlignment = NSTextAlignmentRight;
    
    _stateLabel.font = [UIFont systemFontOfSize:12];
    
    [topView addSubview:_stateLabel];
    
    [self addLineView:topView];
    
    return topView;
}

- (UIView *)detailView {
    
    UIView * detailView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, screen_width, 95)];
    
    _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 70.5, 70.)];
    
    [detailView addSubview:_iconImageView];
    
    _detailNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 15, screen_width - 140, 20)];
    
    _detailNameLabel.textColor = [UIColor colorWithHexString:@"0x252525"];
    
    _detailNameLabel.font = [UIFont systemFontOfSize:14];
    
    [detailView addSubview:_detailNameLabel];
    
    _detailStateLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 15 + 25, screen_width - 140, 15)];
    
    _detailStateLabel.textColor = [UIColor colorWithHexString:@"0x7d7d7d"];
    
    _detailStateLabel.font = [UIFont systemFontOfSize:12];
    
    [detailView addSubview:_detailStateLabel];
    
    _detailNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 15 + 25 + 20 , screen_width - 140, 15)];
    
    _detailNumberLabel.textColor = [UIColor colorWithHexString:@"0x7d7d7d"];
    
    _detailNumberLabel.font = [UIFont systemFontOfSize:12];
    
    [detailView addSubview:_detailNumberLabel];
    
    [self addLineView:detailView];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(detailView.frame.size.width - 30, detailView.center.y - 12.5 , 15, 25)];
    imageView.image = [UIImage imageNamed:@"icon_lgright_arrow"];
    [self.contentView addSubview:imageView];
    
    return detailView;
}

- (UIView *)bottomView {
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 139, screen_width, 44)];
    
    _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, (bottomView.frame.size.height - 10))];
    
    _priceLabel.textColor = [UIColor colorWithHexString:@"0xff3366"];
    
    _priceLabel.font = [UIFont systemFontOfSize:15];
    
    [bottomView addSubview:_priceLabel];
    
    _deteleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _deteleButton.frame = CGRectMake(_priceLabel.frame.size.width + 10, 7, ((bottomView.frame.size.width - (_priceLabel.frame.size.width + 10)) - 15) / 2, (bottomView.frame.size.height - 14));
    
    [_deteleButton setTitle:@"删除订单" forState:UIControlStateNormal];
    
    _deteleButton.backgroundColor = [UIColor colorWithHexString:@"0xec384b"];
    
    [_deteleButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _deteleButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [_deteleButton setTag:0];
    
    [bottomView addSubview:_deteleButton];
    
    _returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _returnButton.frame = CGRectMake(_deteleButton.frame.size.width + _deteleButton.frame.origin.x + 5, 7, _deteleButton.frame.size.width, (bottomView.frame.size.height - 14));
    
    [_returnButton setTitle:@"不满意退货" forState:UIControlStateNormal];
    
    [_returnButton setBackgroundImage:[UIImage imageNamed:@"bg_orange"] forState:UIControlStateNormal];
    
    [_returnButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _returnButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [_returnButton setTag:1];
    
    [bottomView addSubview:_returnButton];
    
    return bottomView;
}

- (void)addLineView:(UIView *)view
{
    UIView * line_view = [[UIView alloc]initWithFrame:CGRectMake(0, view.frame.size.height - 0.5, screen_width, 0.5)];
    line_view.backgroundColor = [UIColor lightGrayColor];
    line_view.alpha = 0.7;
    [view addSubview:line_view];
}

- (void)setData:(NSDictionary *)data block:(CXButtonBolock)block
{
    [self setData:data];
    self.block = block;
}

- (void)setData:(NSDictionary *)data
{
    
    _nameLabel.text = [data valueForKey:@"name"]; /**<- 名字*/
    _stateLabel.text = @"交易完成";  /**<- 状态*/
    
    _iconImageView.image = [UIImage imageNamed:@"bg_red"]; /**<- 图片*/
    _detailNameLabel.text = [data valueForKey:@"d_name"];//@"有乐 沙冰杯 冰激凌杯"; /**<- 详细 名称*/
    _detailStateLabel.text = [data valueForKey:@"d_state"];//@"ZW150 紫色"; /**<- 详细 类别*/
    _detailNumberLabel.text = [data valueForKey:@"d_number"];//@"数量： 1件"; /**<- 详细 数目*/
    
    _priceLabel.text = [data valueForKey:@"d_price"];//@"￥300.00"; /**<- 价格*/
}

- (void)buttonClick:(UIButton *)button
{
    if (_block) {
        _block(button.tag,button.titleLabel.text);
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
