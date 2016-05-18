//
//  i400ViewController.m
//  ixcode
//
//  Created by Ming on 16/1/4.
//  Copyright © 2016年 macmac. All rights reserved.
//

#import "i400ViewController.h"
#import "AppDelegate.h"

#import "CX_AllTableViewCell.h"
#import "CX_PayTableViewCell.h"
#import "CX_DeliveryTableViewCell.h"
#import "CX_ChargeTableViewCell.h"
#import "CX_EndTableViewCell.h"

#import "CXSegueView.h"
#import "MJRefresh.h"

#import "CXJson.h"

#define KScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define KScreenHeight  [[UIScreen mainScreen] bounds].size.height

#define TOOLBOX_ACCOUNT @"test3123"
#define IXCODE_ACCOUNT @"test3210"

@interface i400ViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    NSMutableArray * numberOfSec;
    
    NSInteger selectOfSegue;
}

@property (nonatomic,strong) NSMutableArray * dataArray; /**<- 模拟数据*/

@property (nonatomic,strong) CXSegueView * segueView;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSArray * cellIDArray;
@end

@implementation i400ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conn_state_changed)
                                                 name:globalConn.stateChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(response_received)
                                                 name:globalConn.responseReceivedNotification object:nil];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.title = @"我的订单";
    
    [self.view addSubview:self.segueView];
    [self.view addSubview:self.tableView];
    
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    
    selectOfSegue = 0;
}

#pragma mark - **************** 下拉刷新 上提加载 事件 ****************

 /**<- 下拉刷新事件*/
- (void)loadNewData
{
    self.dataArray = nil;
    
    NSDictionary * dict = @{@"刷新":@"模拟 延时一秒"};
    [self sendRequest:@"下拉刷新 -- >> 恢复数据" data:dict];
    
    [self performSelector:@selector(endRefresh:) withObject:@YES afterDelay:1];
}
/**<- 上提加载事件*/
- (void)loadMoreData {

    NSMutableArray * array = self.dataArray[selectOfSegue];
    
    [array addObject:array[0]];
    
    self.dataArray[selectOfSegue] = array;
    
    NSDictionary * dict = @{@"加载":@"模拟 延时一秒"};
    [self sendRequest:@"上提加载 -- >> 加一条数据" data:dict];
    
    [self performSelector:@selector(endRefresh:) withObject:@NO afterDelay:1];
    
}

- (void)endRefresh:(NSNumber *)number
{
    if ([number boolValue]) {
        [self.tableView.header endRefreshing];
    }else{
        [self.tableView.footer endRefreshing];
    }
    [_tableView reloadData];
}

#pragma mark - **************** table datasource  and  delegate****************
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.dataArray) {
        return [self.dataArray[selectOfSegue] count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (selectOfSegue) {
        case 0: /**<- 全部*/
        {
            NSString * cellID = self.cellIDArray[selectOfSegue];
            
            CX_AllTableViewCell * cell = [CX_AllTableViewCell cellWithTableView:tableView indentifier:cellID];
            
            __weak typeof(self) weak_self = self;
            [cell setData:self.dataArray[selectOfSegue][indexPath.section] block:^(NSInteger button_tag, NSString *button_title) {
                [weak_self cellButtonClick:button_tag title:button_title indexPath:indexPath.section];
            }];
            
            return cell;
        }
            break;
        case 1: /**<- 待付款*/
        {
            NSString * cellID = self.cellIDArray[selectOfSegue];
            
            CX_PayTableViewCell * cell = [CX_PayTableViewCell cellWithTableView:tableView indentifier:cellID];
            
            __weak typeof(self) weak_self = self;
            [cell setData:self.dataArray[selectOfSegue][indexPath.section] block:^(NSInteger button_tag, NSString *button_title) {
                [weak_self cellButtonClick:button_tag title:button_title indexPath:indexPath.section];
            }];
            
            return cell;
        }
            break;
        case 2: /**<- 待发货*/
        {
            NSString * cellID = self.cellIDArray[selectOfSegue];
            
            CX_DeliveryTableViewCell * cell = [CX_DeliveryTableViewCell cellWithTableView:tableView indentifier:cellID];
            
            __weak typeof(self) weak_self = self;
            [cell setData:self.dataArray[selectOfSegue][indexPath.section] block:^(NSInteger button_tag, NSString *button_title) {
                [weak_self cellButtonClick:button_tag title:button_title indexPath:indexPath.section];
            }];
            
            return cell;
        }
            break;
        case 3: /**<- 待收货*/
        {
            NSString * cellID = self.cellIDArray[selectOfSegue];
            
            CX_ChargeTableViewCell * cell = [CX_ChargeTableViewCell cellWithTableView:tableView indentifier:cellID];
            
            __weak typeof(self) weak_self = self;
            [cell setData:self.dataArray[selectOfSegue][indexPath.section] block:^(NSInteger button_tag, NSString *button_title) {
                [weak_self cellButtonClick:button_tag title:button_title indexPath:indexPath.section];
            }];
            
            return cell;
        }
            break;
        default: /**<- 已完成*/
        {
            NSString * cellID = self.cellIDArray[selectOfSegue];
            
            CX_EndTableViewCell * cell = [CX_EndTableViewCell cellWithTableView:tableView indentifier:cellID];
            
            __weak typeof(self) weak_self = self;
            [cell setData:self.dataArray[selectOfSegue][indexPath.section] block:^(NSInteger button_tag, NSString *button_title) {
                [weak_self cellButtonClick:button_tag title:button_title indexPath:indexPath.section];
            }];
            
            return cell;
        }
            break;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{    
    
    NSDictionary * dict = @{@"当前点击的订单类别":@(selectOfSegue), /**<- 当前选中的订单类别*/
                            @"当前点击的行数":@(indexPath.section)  /**<- 当前选中的行数*/
                            };
    [self sendRequest:@"点击【商品栏目】 ->> 离开界面" data:dict];
}

- (NSArray *)cellIDArray
{
    if (_cellIDArray) {
        _cellIDArray = [NSArray arrayWithObjects:@"cellIDWithAll",@"cellIDWithPay",@"cellIDWithDelivery",@"cellIDWithCharge" ,@"cellIDWithEvaluation",nil];
    }
    return _cellIDArray;
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
    
    // {"obj":"associate","act":"mock","to_login_name":"TOOLBOX_ACCOUNT","data":{"obj":"test","act":"output1","data":"blah"}}
    if ([(NSString*)[globalConn.response objectForKey:@"obj"] isEqualToString:@"test"]) {
        if ([(NSString*)[globalConn.response objectForKey:@"act"] isEqualToString:@"output1"]) {
            
            NSLog(@" * * * * * * * * * * * * * * * * * * * * * * *");
            
            NSLog(@"成功 -  - - - -- - - %@",[globalConn.response a:@"data"]);
            
            self.dataArray =[NSMutableArray arrayWithArray:[globalConn.response a:@"data"]];
            
            [self.tableView reloadData];
            
            NSLog(@" * * * * * * * * * * * * * * * * * * * * * * *\n\n");
            
        }
    }
    
    return;
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


#pragma mark - **************** initView ****************

- (CXSegueView *)segueView{
    if (!_segueView) {
        NSArray * titleArray = [NSArray arrayWithObjects:@"全部",@"待付款",@"待发货",@"待收货",@"待评价", nil];
        __weak typeof(self) weak_self = self;
        _segueView = [[CXSegueView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, 40) titleArray:titleArray block:^(NSInteger button_tag) {
            [weak_self buttonClick:button_tag withTitle:titleArray[button_tag]];
        }];
    }
    return _segueView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 104, KScreenWidth, KScreenHeight - 106) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, KScreenWidth, 10.0f)];
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, KScreenWidth, 0.01f)];
        _tableView.sectionFooterHeight = 0;
        _tableView.sectionHeaderHeight = 10;
        _tableView.rowHeight = 183.;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


#pragma mark - **************** event ****************

- (void)buttonClick:(NSInteger)button_tag withTitle:(NSString *)title /**<- segue 点击事件*/
{
    NSDictionary * dict = @{@"当前点击的按钮标题":title, /**<- 当前点击的按钮标题*/
                            @"当前点击的按钮tag":@(button_tag),
                            };
    [self sendRequest:[NSString stringWithFormat:@"点击【%@】-->> 切换界面",title] data:dict];
    selectOfSegue = button_tag;
    [_tableView reloadData];
}

-(void)cellButtonClick:(NSInteger)tag title:(NSString *)title indexPath:(NSInteger )index /**<- 单元格内点击事件*/
{
    NSLog(@"- %ld   %@",(long)tag,title);
    
    if ([title isEqualToString:@"不满意退货"]){
        NSDictionary * dict = @{@"当前点击的订单类别":@(selectOfSegue), /**<- 当前选中的订单类别*/
                                @"当前点击的行数":@(index),  /**<- 当前选中的行数*/
                                @"当前点击的按钮tag":@(tag),    /**<- 当前点击的按钮tag*/
                                @"当前点击的按钮标题":title, /**<- 当前点击的按钮标题*/
                                };
        [self sendRequest:@"点击【退货】 ->> 离开界面" data:dict];
    }
    
    if ([title isEqualToString:@"删除订单"]){
        NSLog(@"订单被删除,删除 第%ld 区 ",(long)index);
        
        NSDictionary * dict = @{@"当前点击的订单类别":@(selectOfSegue), /**<- 当前选中的订单类别*/
                                @"当前点击的行数":@(index),  /**<- 当前选中的行数*/
                                @"当前点击的按钮标题":title, /**<- 当前点击的按钮标题*/
                                };
        [self sendRequest:@"点击【删除】 ->> 删除当前行" data:dict];
        
        [self.dataArray[selectOfSegue] removeObjectAtIndex:index];
        
        [_tableView reloadData];
    }
    if ([title isEqualToString:@"立即付款"]){
        NSDictionary * dict = @{@"当前点击的订单类别":@(selectOfSegue), /**<- 当前选中的订单类别*/
                                @"当前点击的行数":@(index),  /**<- 当前选中的行数*/
                                @"当前点击的按钮标题":title, /**<- 当前点击的按钮标题*/
                                };
        [self sendRequest:@"点击【付款】 ->> 离开界面" data:dict];
    }
    if ([title isEqualToString:@"提醒卖家发货"]){
        NSDictionary * dict = @{@"当前点击的订单类别":@(selectOfSegue), /**<- 当前选中的订单类别*/
                                @"当前点击的行数":@(index),  /**<- 当前选中的行数*/
                                @"当前点击的按钮标题":title, /**<- 当前点击的按钮标题*/
                                };
        [self sendRequest:@"点击【发货】 ->> 离开界面" data:dict];
    }
    if ([title isEqualToString:@"查看物流"]){
        NSDictionary * dict = @{@"当前点击的订单类别":@(selectOfSegue), /**<- 当前选中的订单类别*/
                                @"当前点击的行数":@(index),  /**<- 当前选中的行数*/
                                @"当前点击的按钮标题":title, /**<- 当前点击的按钮标题*/
                                };
        [self sendRequest:@"点击【物流】 ->> 离开界面" data:dict];
    }
    if ([title isEqualToString:@"立即评价"]){
        NSDictionary * dict = @{@"当前点击的订单类别":@(selectOfSegue), /**<- 当前选中的订单类别*/
                                @"当前点击的行数":@(index),  /**<- 当前选中的行数*/
                                @"当前点击的按钮标题":title, /**<- 当前点击的按钮标题*/
                                };
        [self sendRequest:@"点击【评价】 ->> 离开界面" data:dict];
    }
}

//TODO: 获取模拟数据 正式时删除
- (NSMutableArray *)dataArray {

    numberOfSec = [NSMutableArray arrayWithObjects:@(3),@(4),@(5),@(6),@(7), nil];
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        for (NSInteger i = 0 ; i < numberOfSec.count; i ++) {
            NSMutableArray * tempArray = [NSMutableArray array];
            for (NSInteger j = 0; j < [numberOfSec[i] integerValue]; j ++) {
                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                [dict setValue:[NSString stringWithFormat:@"-%ld-模拟之-%ld-",i,j] forKey:@"name"];
                [dict setValue:[NSString stringWithFormat:@"-%ld-模拟之详情-%ld-",i,j] forKey:@"d_name"];
                [dict setValue:[NSString stringWithFormat:@"-%ld-模拟之类别-%ld-",i,j] forKey:@"d_state"];
                [dict setValue:[NSString stringWithFormat:@"数量：1%ld%ld 件",i,j] forKey:@"d_number"];
                [dict setValue:[NSString stringWithFormat:@"￥2%ld%ld.00",i,j] forKey:@"d_price"];
                [tempArray addObject:dict];
            }
            [_dataArray addObject:tempArray];
        }
    }
    return _dataArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
