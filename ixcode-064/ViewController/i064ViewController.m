//
//  i064ViewController.m
//  ixcode
//
//  Created by DCX on 16/4/26.
//  Copyright © 2016年 macmac. All rights reserved.
//

#import "i064ViewController.h"
#import "CXLoseView.h"
#import "CXHeaderView.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>
#import <CoreMotion/CoreMotion.h>
#import "UIImage+WebP.h"
#import "UIView+DCX.h"
#import "UIColor+DCX.h"

#define KScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define KScreenHeight  [[UIScreen mainScreen] bounds].size.height
#define __font(__size) [UIFont systemFontOfSize:__size]

#define TOOLBOX_ACCOUNT @"test3123"
#define IXCODE_ACCOUNT @"test3210"


@interface i064ViewController ()

@property (nonatomic,strong) UIView * headerView;
@property (nonatomic,strong) UIView * loseView;
@property (nonatomic,strong) UIView * infoView;
@property (nonatomic,strong) UIView * bottomView;


@property (nonatomic,strong) CMMotionManager * motionManager;
@property (nonatomic,assign) BOOL isADD;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) BOOL isShaked;

@property (nonatomic,strong) NSString * odds;

@property (nonatomic,strong) NSDictionary * data;

@end

@implementation i064ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB_COLOR(244, 244, 244);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conn_state_changed)
                                                 name:globalConn.stateChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(response_received)
                                                 name:globalConn.responseReceivedNotification object:nil];
    
    _motionManager = [[CMMotionManager alloc]init];

    _odds = @"0%";
    

    
    if (KScreenHeight < self.bottomView.frameBottom) {
        
        UIView * view = [UIView new];
        [self.view addSubview:view];

        UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.contentSize = CGSizeMake(0, self.bottomView.frameBottom);
        scrollView.bounces = NO;
        [self.view addSubview:scrollView];
        [scrollView addSubview:self.headerView];
        [scrollView addSubview:self.loseView];
        [scrollView addSubview:self.infoView];
        [scrollView addSubview:self.bottomView];
        
    }else {
        [self.view addSubview:self.headerView];
        [self.view addSubview:self.loseView];
        [self.view addSubview:self.infoView];
        [self.view addSubview:self.bottomView];
    }
    

    [UIApplication sharedApplication].applicationSupportsShakeToEdit = NO;

}


static CGFloat kHeaderViewWitdht = 150.;
- (UIView *)headerView {
    
    if (!_headerView) {
        
        CGFloat  x_view = (12/414)* KScreenWidth;
        
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(x_view, 64+14, KScreenWidth - 2 * x_view, 75)];
        
        CXHeaderView * header_R = [[CXHeaderView alloc] initWithFrame:CGRectMake(view.frameWidth - kHeaderViewWitdht, 0 , kHeaderViewWitdht, 75)];
        header_R.tag = 100;
        [header_R setName:@"王子面" hp:@"35000" AbilityValue:@"1600" headerImage:@"http://www.photophoto.cn/m15/032/003/0320030232.jpg" state:CXHeaderView_right];
        [view addSubview:header_R];
        
        CXHeaderView * header_L = [[CXHeaderView alloc] initWithFrame:CGRectMake(0, 0 , kHeaderViewWitdht, 75)];
        [header_L setName:@"李欣雨" hp:@"50000" AbilityValue:@"25000" headerImage:@"http://www.photophoto.cn/m15/032/003/0320030231.jpg" state:CXHeaderView_lift];
        header_L.tag = 101;
        [view addSubview:header_L];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, view.frameWidth, 20)];
        label.font = __font(20);
        label.textColor = RGB_COLOR(0, 0, 0);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"略有小败";
        [view addSubview:label];
        
        UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, label.frameBottom + 7, view.frameWidth, 12)];
        label2.font = __font(12);
        label2.textColor = RGB_COLOR(0, 0, 0);
        label2.textAlignment = NSTextAlignmentCenter;
        label2.text = [NSString stringWithFormat:@"%@胜率",_odds];
        label2.tag = 102;
        [view addSubview:label2];
        
        _headerView = view;
    }
    return _headerView;
}
- (UIView *)loseView {
    if (!_loseView) {
        CXLoseView * view = [[CXLoseView alloc] initWithFrame:CGRectMake(10, self.headerView.frameBottom + 10, KScreenWidth - 20, 131)];
        view.tag = 105;
        [view setName:@"iPhone6 S" price:@"6000" image:@"http://www.photophoto.cn/m15/032/003/0320030231.jpg" time:9000];
        _loseView = view;
    }
    return _loseView;
}

- (UIView *)infoView {
    if (!_infoView) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, self.loseView.frameBottom + 8, KScreenWidth - 20, 42)];
        label.textColor = RGB_COLOR(63, 63, 63);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"胜利秘诀:疯摇手机可增强守护礼物的机会";
        label.font = __font(14);
        
        UIImage * image = [UIImage imageNamed:@"fangkuang01"];
        NSInteger leftCapWidth = image.size.width * 0.5f;
        NSInteger topCapHeight = image.size.height * 0.5f;
        image = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
        
        UIImageView * bgImageView = [[UIImageView alloc] initWithImage:image];
        bgImageView.frame = label.bounds;
        [label addSubview:bgImageView];
        
        _infoView = label;
    }
    return _infoView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(10, self.infoView.frameBottom + 8, KScreenWidth - 20, 890/3)];
        view.backgroundColor = [UIColor whiteColor];
        UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"beiqiangrenwu"]];
        imageView.frame = CGRectMake(0, 0, view.frameWidth - 290/3, view.frameHeight);
        [view addSubview: imageView];
        
        UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn1 setBackgroundImage:[UIImage imageNamed:@"icon_shiyongdaoju"] forState:UIControlStateNormal];
        btn1.frame = CGRectMake(imageView.frameRight, 70, 70, 70);
        [btn1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn1.tag = 500;
        [view addSubview:btn1];
        
        UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn2 setBackgroundImage:[UIImage imageNamed:@"icon_dianjikaiyao"] forState:UIControlStateNormal];
        btn2.frame = CGRectMake(imageView.frameRight, btn1.frameBottom + 18, 70, 70);
        [btn2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn2.tag = 501;
        [btn2 setTitle:@" " forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn2.titleLabel.font = __font(30);
        btn2.titleLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:btn2];
        
        _bottomView = view;
    }
    return _bottomView;
}


- (void)buttonClick:(UIButton *)button {
    
    if (!_isShaked) {
        if (button.tag == 500) {
            [self buttonClick:button.tag withTitle:@"使用道具"];
            
            
        }else {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            [self buttonClick:button.tag withTitle:@"点击开摇"];
            [button setBackgroundImage:nil forState:UIControlStateNormal];
            [self startTime:button];
            [self coreMotion:YES];

            [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
            [self becomeFirstResponder];
        }
    }else {
        if (button.tag == 500) {
            [self buttonClick:button.tag withTitle:@"查看胜负"];
        }else {
            
        }
    }
}

/** 摇动的阀值 */
static CGFloat value = 2.0;
/** 只有在 x 轴上的摇动才计数 */
- (void)coreMotion:(BOOL)begin {
    //判断传感器是否可以使用
    if ([_motionManager isAccelerometerAvailable] && begin) {//传感器可用
        [_motionManager setAccelerometerUpdateInterval:1 / 5];
        [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            CGFloat tempX = fabs(accelerometerData.acceleration.x);
            BOOL X_isADD = _isADD;
            
            if (tempX > value) {
                if (tempX > _x) {
                    CGFloat tempX = accelerometerData.acceleration.x;
                    _x = tempX;
                    _isADD = YES;
                } else {
                    _x = tempX;
                    _isADD = NO;
                }
                if (X_isADD == !_isADD && _isADD == NO) {
                    X_isADD = _isADD;
                    _count ++;
                    NSLog(@"摇动次数＋1   %ld",_count);
                    return ;
                }
            }
        }];
        
    } else {//传感器不可用
        [_motionManager stopAccelerometerUpdates];
        NSLog(@"传感器不可用");
    }
}
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"开始摇动,motion is %ld",(long)motion);
    return;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake) { // 判断是否是摇动结束
        [_motionManager stopAccelerometerUpdates];
        NSLog(@"摇动结束");
    }
    return;
}

- (NSString *)buffWithCount:(NSInteger )count {
    CGFloat i = count/250.0 ;
    return [NSString stringWithFormat:@"%.0f",i * 100];
}

-(void)startTime:(UIButton *)button{
    
    __block NSInteger timeout=8; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                UIButton *btn1 = (UIButton *)[self.view viewWithTag:500];
                [btn1 setBackgroundImage:[UIImage imageNamed:@"icon_chakanshengfu"] forState:UIControlStateNormal];
                NSString * title = [NSString stringWithFormat:@"8秒内摇了%ld次\n+%@％武力值",_count,[self buffWithCount:_count]];
                [button setBackgroundImage:[UIImage imageNamed:@"icon_chakanshengfu"] forState:UIControlStateNormal];
                
                
                
                button.titleLabel.numberOfLines = 2;
                [button setTitle:title forState:UIControlStateNormal];
                button.titleLabel.font = __font(8);
                button.userInteractionEnabled = YES;
                _isShaked = YES;
                
                /** 震动三次 */
                
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                [UIApplication sharedApplication].applicationSupportsShakeToEdit = NO;
                
                [self sendRequest:@"摇动结束" data:@{@"摇动次数":@(_count)}];
                
            });
        }else{
            NSString *strTime = [NSString stringWithFormat:@"%ld",timeout];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [button setTitle:strTime forState:UIControlStateNormal];
                button.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - **************** Notification 事件 ****************
- (void)conn_state_changed {
    if (globalConn.state == LOGIN_SCREEN_ENABLED) {
        
        if (globalConn.from_state == INITIAL_LOGIN || globalConn.from_state == SESSION_LOGIN) {
            
            return;
        }
        if (globalConn.from_state == REGISTRATION) {
            
            return;
        }
        
        NSLog(@" * * * * * * * * * * * * * * * * * * * * * * *");
        
        NSLog(@"链接");
        
        NSLog(@" * * * * * * * * * * * * * * * * * * * * * * *\n\n");
        
        [globalConn credential:IXCODE_ACCOUNT withPasswd:@"1"];
        [globalConn connect];
        
        
    } else if (globalConn.state == IN_SESSION) {
        NSLog(@" * * * * * * * * * * * * * * * * * * * * * * *");
        
        NSLog(@"成功");
        
        NSLog(@" * * * * * * * * * * * * * * * * * * * * * * *\n\n");
    }
}

- (void)response_received {
    
    NSLog(@"response: %@:%@ uerr:%@",
          [globalConn.response objectForKey:@"obj"],
          [globalConn.response objectForKey:@"act"],
          [globalConn.response objectForKey:@"uerr"]);
    
    NSLog(@" * * * * * * * * * * * * * * * * * * * * * * *");
    
    NSLog(@"成功 -  - - - -- - - %@",[globalConn.response o:@"data"]);
    if ([globalConn.response valueForKey:@"odds"]) {
        self.data  =[NSDictionary dictionaryWithDictionary:globalConn.response];
        [self reloadViews];
    }
    NSLog(@" * * * * * * * * * * * * * * * * * * * * * * *\n\n");
    
}

- (void)reloadViews {
    [self reloadHeaderView];
    [self reloadOtherView];
}

- (void)reloadHeaderView {
    CXHeaderView * rView = (CXHeaderView *)[self.view viewWithTag:100];
    NSDictionary * rData = self.data[@"user_r"];
    [rView setName:rData[@"name"] hp:rData[@"HP"] AbilityValue:rData[@"AB"] headerImage:rData[@"image_file"] state:CXHeaderView_right];
    CXHeaderView * lView = (CXHeaderView *)[self.view viewWithTag:101];
    
    NSDictionary * lData = self.data[@"user_l"];
    [lView setName:lData[@"name"] hp:lData[@"HP"] AbilityValue:lData[@"AB"] headerImage:lData[@"image_file"] state:CXHeaderView_lift];
    
    UILabel * oddsL = (UILabel *)[self.view viewWithTag:102];
    oddsL.text = self.data[@"odds"];
    
}

- (void)reloadOtherView {
    CXLoseView * view = (CXLoseView *)[self.view viewWithTag:105];
    [view setName:self.data[@"l_name"] price:self.data[@"l_price"] image:self.data[@"l_image"] time:[self.data[@"l_time"] integerValue]];
}

- (void)buttonClick:(NSInteger)button_tag withTitle:(NSString *)title /**<- segue 点击事件*/
{
    NSDictionary * dict = @{@"当前点击的按钮标题":title, /**<- 当前点击的按钮标题*/
                            @"当前点击的按钮tag":@(button_tag),
                            };
    [self sendRequest:[NSString stringWithFormat:@"点击【%@】-->> 切换界面",title] data:dict];
}

#pragma mark - **************** send Request ****************

/**
 *  @author 发送请求
 *
 *  @param info  交互
 *  @param input 对应 操作
 *  @param dict  交互数据
 */
-(void)sendRequest:(NSString *)info  data:(NSDictionary *)dict;
{
    NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
    
    [data setObject:info forKey:@"交互"];
    [data setObject:dict forKey:@"交互数据"];
    
    NSMutableDictionary* DATA = [[NSMutableDictionary alloc] init];
    [DATA setObject:@"test" forKey:@"obj"];
    [DATA setObject:@"input1" forKey:@"act"];
    [DATA setObject:data forKey:@"data"];
    
    
    NSMutableDictionary* req = [[NSMutableDictionary alloc] init];
    [req setObject:@"associate" forKey:@"obj"];
    [req setObject:@"mock" forKey:@"act"];
    [req setObject:TOOLBOX_ACCOUNT forKey:@"to_login_name"];
    [req setObject:DATA forKey:@"data"];
    [globalConn send:req];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
