//
//  CX_PayTableViewCell.h
//  ixcode
//
//  Created by Ming on 16/1/4.
//  Copyright © 2016年 macmac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CXButtonBolock)(NSInteger button_tag,NSString * button_title);
@interface CX_PayTableViewCell : UITableViewCell

@property (nonatomic,strong) NSDictionary * data;

- (void)setData:(NSDictionary *)data block:(CXButtonBolock)block;

+(instancetype)cellWithTableView:(UITableView *)tableView indentifier:(NSString *)indentifier;

@end