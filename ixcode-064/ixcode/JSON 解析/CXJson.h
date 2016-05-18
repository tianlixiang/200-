//
//  CXJson.h
//  常用Category
//
//  Created by Ming on 15/11/16.
//  Copyright © 2015年 戴晨惜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Json)

- (NSData *)JSONData;
- (NSData *)JSONDataWithError:(NSError **)error;

- (NSString *)JSONString;
- (NSString *)JSONStringWithError:(NSError **)error;

- (id)JSONObject;
- (id)JSONObjectWithError:(NSError **)error;

@end

