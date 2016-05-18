//
//  CXHeaderView.h
//  ixcode
//
//  Created by DCX on 16/4/26.
//  Copyright © 2016年 macmac. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, CXHeaderViewState) {
    CXHeaderView_lift = 0 ,
    CXHeaderView_right,
};
@interface CXHeaderView : UIView


- (void)setName:(NSString *)name hp:(NSString *)hpValue AbilityValue:(NSString *)AbilityValue headerImage:(NSString *)imageURL state:(CXHeaderViewState)state;


@end
