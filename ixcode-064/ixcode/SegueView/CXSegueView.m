//
//  CXSegueView.m
//  MyOrder
//
//  Created by Ming on 15/11/24.
//  Copyright © 2015年 戴晨惜. All rights reserved.
//

#import "CXSegueView.h"
#import "NSString+Size.h"
#import "UIColor+DCX.h"
#define KScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define KScreenHeight  [[UIScreen mainScreen] bounds].size.height

@interface CXSegueView()
{
    CGFloat _width;
    /**
     *  选中指示标示
     */
    UIImageView * selectImage;
    
    UIButton * selectedButton;
    
    BOOL isFirst;
    
}

@end

@implementation CXSegueView

#define stateBtnFont    [UIFont systemFontOfSize:12]

static CGFloat selectImageHeight = 2.;


- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray  block:(CXStateButtonBolock)block
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addView:titleArray];
        isFirst = YES;
        self.block = block;
    }
    return  self;
}

#pragma mark - **************** setter ****************
-(void)setSelectImage_index:(NSInteger)selectImage_index
{
    _selectImage_index = selectImage_index;
    [self updateSelectImageViewFrame];
    
}

#pragma mark - **************** event ****************
-(void)stateBtnClick:(UIButton *)button
{
    selectedButton.selected = NO;
    [button setSelected:YES];
    selectedButton = button;
    if (_block) {
        _block(button.tag - 500);
    }
    self.selectImage_index = button.tag - 500;
}

#pragma mark - **************** UIAnimation ****************
-(void)updateSelectImageViewFrame
{
    UIButton * button = (UIButton *)[self viewWithTag:500 + _selectImage_index];
    
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        selectImage.frame = CGRectMake(button.frame.origin.x, button.frame.size.height - selectImageHeight, button.frame.size.width, selectImageHeight);

    } completion:nil];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        selectImage.frame = CGRectMake(button.frame.origin.x, button.frame.size.height - selectImageHeight, button.frame.size.width, selectImageHeight);
        
    } completion:nil];
}

#pragma mark - **************** initView and updateViewFrame ****************

- (void)addView:(NSArray *)titleArray
{
    _title_array = titleArray;
    if (titleArray) {
        
        for (NSInteger i = 0; i < titleArray.count ; i ++) {
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = 500 + i;
            btn.titleLabel.font = stateBtnFont;
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"0x7d7d7d"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"0xff6e8c"] forState:UIControlStateSelected];
            _width += [btn.titleLabel.text widthWithFont:btn.titleLabel.font constrainedToHeight:self.frame.size.height];
            [btn addTarget:self action:@selector(stateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
            if (i != 0) {
                UIView * lineView = [[UIView alloc]init];
                lineView.tag = 600 + i;
                lineView.backgroundColor = [UIColor colorWithHexString:@"0x7d7d7d"];
                lineView.alpha = 0.3;
                [btn addSubview:lineView];
            }else{
                btn.selected = YES;
                selectedButton = btn;
            }
        }
    }
    
    selectImage = [[UIImageView alloc]init];
    selectImage.tag = 499;
    selectImage.backgroundColor = [UIColor colorWithHexString:@"0xff3366"];
    [self addSubview:selectImage];
    
    [self setNeedsDisplay];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat buttonWidth = self.frame.size.width / _title_array.count;
    for (NSInteger i = 0; i < _title_array.count; i ++) {
        UIButton * button = (UIButton *)[self viewWithTag:500 + i];
        button.frame = CGRectMake(i * buttonWidth, 0, buttonWidth, self.frame.size.height);
        
        if (i == 0 && isFirst) {
            isFirst = NO;
            selectImage.frame = CGRectMake(button.frame.origin.x, button.frame.size.height - selectImageHeight, button.frame.size.width, selectImageHeight);
        }
        
        if (i != 0) {
            UIView * view = [self viewWithTag:600 + i];
            view.frame = CGRectMake(0, 9, 1, button.frame.size.height - 18);
        }
        
    }
}
    


@end
