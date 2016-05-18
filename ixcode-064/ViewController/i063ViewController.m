//
//  i063ViewController.m
//  ixcode
//
//  Created by DCX on 16/4/28.
//  Copyright © 2016年 macmac. All rights reserved.
//

#import "i063ViewController.h"

#import "CXLosed_View.h"
#import "CXHeaderView.h"
#import "AppDelegate.h"
#import "UIView+DCX.h"
#import "UIColor+DCX.h"


#define KScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define KScreenHeight  [[UIScreen mainScreen] bounds].size.height
#define __font(__size) [UIFont systemFontOfSize:__size]

#define TOOLBOX_ACCOUNT @"test3123"
#define IXCODE_ACCOUNT @"test3210"

@interface i063ViewController ()


@property (nonatomic,strong) UIView * headerView;
@property (nonatomic,strong) UIView * loseView;
@property (nonatomic,strong) UIView * infoView;
@property (nonatomic,strong) UIView * bottomView;

@property (nonatomic,strong) NSDictionary *data;

@end

@implementation i063ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGB_COLOR(244, 244, 244);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conn_state_changed)
                                                 name:globalConn.stateChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(response_received)
                                                 name:globalConn.responseReceivedNotification object:nil];
    
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
    
}

static CGFloat kHeaderViewWitdht = 150.;
- (UIView *)headerView {
    if (!_headerView) {
        
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(12, 64+14, KScreenWidth - 24, 75)];
        
        CXHeaderView * header_L = [[CXHeaderView alloc] initWithFrame:CGRectMake(0, 0 , kHeaderViewWitdht, 75)];
        [header_L setName:@"李欣雨" hp:@"50000" AbilityValue:@"25000" headerImage:@"http://www.photophoto.cn/m15/032/003/0320030231.jpg" state:CXHeaderView_lift];
        header_L.tag = 100;
        [view addSubview:header_L];
        
        _headerView = view;
        
    }
    return _headerView;
}

- (UIView *)loseView {
    if (!_loseView) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, self.headerView.frameBottom + 2, KScreenWidth - 20, 42)];
        label.textColor = RGB_COLOR(63, 63, 63);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"               可惜，你距离胜利只差一点，下次请多摇一下或开启道具吧！";
        label.font = __font(9);
        
        UIImage * image = [UIImage imageNamed:@"fangkuang01"];
        NSInteger leftCapWidth = image.size.width * 0.5f;
        NSInteger topCapHeight = image.size.height * 0.5f;
        image = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
        
        UIImageView * bgImageView = [[UIImageView alloc] initWithImage:image];
        bgImageView.frame = label.bounds;
        [label addSubview:bgImageView];
        
        UIImageView * loseIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_bai"]];
        loseIconImageView.frame = CGRectMake(15, 3, 36, 32);
        [label addSubview:loseIconImageView];
        
        _loseView = label;
        
    }
    return _loseView;
}

- (UIView *)infoView {
    if (!_infoView) {
        
        CXLosed_View * view = [[CXLosed_View alloc] initWithFrame:CGRectMake(10, self.loseView.frameBottom + 5, KScreenWidth - 20, 130)];
        
        view.tag = 105;
        [view setName:@"iPhone6 S" image:@"http://www.photophoto.cn/m15/032/003/0320030231.jpg" companyName:@"爱情海购物公司"];
        _infoView = view;
        
    }
    return _infoView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(10, self.infoView.frameBottom + 5, KScreenWidth - 20, 890/3)];
        view.backgroundColor = [UIColor whiteColor];
        UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_mingren"]];
        imageView.frame = CGRectMake(20, 0, 390/2, view.frameHeight);
        [view addSubview: imageView];
        
        UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn1 setBackgroundImage:[UIImage imageNamed:@"icon_zaiqiangyici"] forState:UIControlStateNormal];
        btn1.frame = CGRectMake(view.frameRight - 100, 100, 70, 70);
        [btn1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn1.tag = 500;
        [view addSubview:btn1];
        
        _bottomView = view;
    }
    return _bottomView;
}

- (void)buttonClick:(UIButton *)button {
    [self buttonClick:button.tag withTitle:@"再抢一次"];
}


- (void)buttonClick:(NSInteger)button_tag withTitle:(NSString *)title /**<- segue 点击事件*/
{
    NSDictionary * dict = @{@"当前点击的按钮标题":title, /**<- 当前点击的按钮标题*/
                            @"当前点击的按钮tag":@(button_tag),
                            };
    [self sendRequest:[NSString stringWithFormat:@"点击【%@】-->> 切换界面",title] data:dict];
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
    if ([globalConn.response valueForKey:@"companyName"]) {
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
    CXHeaderView * View = (CXHeaderView *)[self.view viewWithTag:100];
    NSDictionary * rData = self.data[@"user"];
    [View setName:rData[@"name"] hp:rData[@"HP"] AbilityValue:rData[@"AB"] headerImage:rData[@"image_file"] state:CXHeaderView_lift];
}
- (void)reloadOtherView {
    CXLosed_View * view = (CXLosed_View *)[self.view viewWithTag:105];
    [view setName:self.data[@"l_name"] image:self.data[@"l_image"] companyName:self.data[@"companyName"]];
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
