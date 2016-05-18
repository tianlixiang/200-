//
//  CXJson.m
//  常用Category
//
//  Created by Ming on 15/11/16.
//  Copyright © 2015年 戴晨惜. All rights reserved.
//

#import "CXJson.h"


@implementation NSString (Json)


- (id)objectFromJSONString{
    
    return [self objectFromJSONStringError:nil];
}
- (id)objectFromJSONStringError:(NSError **)error{
    
    if (self == nil) return nil;
    
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:error];
    if(error) return nil;
    
    return dic;
}

@end

@implementation NSDictionary (Json)

- (NSData *)JSONData{
    return [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:nil];;
}
- (NSData *)JSONDataWithError:(NSError **)error{
    return [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:error];;
}

- (NSString *)JSONString{
    if ([NSJSONSerialization isValidJSONObject:self])
    {
        return [[NSString alloc] initWithData:self.JSONData encoding:NSUTF8StringEncoding];
    }
    return nil;
}
- (NSString *)JSONStringWithError:(NSError **)error{
    return [[NSString alloc] initWithData:[self JSONDataWithError:error] encoding:NSUTF8StringEncoding];
}

@end

@implementation NSArray (Json)

- (NSData *)JSONData{
    return [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:nil];;
}
- (NSData *)JSONDataWithError:(NSError **)error{
    return [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:error];;
}

- (NSString *)JSONString{
    if ([NSJSONSerialization isValidJSONObject:self])
    {
        return [[NSString alloc] initWithData:self.JSONData encoding:NSUTF8StringEncoding];
    }
    return nil;
}
- (NSString *)JSONStringWithError:(NSError **)error{
    return [[NSString alloc] initWithData:[self JSONDataWithError:error] encoding:NSUTF8StringEncoding];
}

@end

@implementation NSObject (Json)

- (NSData *)JSONData{
    return  [self JSONDataWithError:nil];
}
- (NSData *)JSONDataWithError:(NSError **)error{
    if ([self isKindOfClass:[NSString class]]) {
        return [((NSString *)self) dataUsingEncoding:NSUTF8StringEncoding];
    } else if ([self isKindOfClass:[NSData class]]) {
        return (NSData *)self;
    }
    
    return [NSJSONSerialization dataWithJSONObject:[self JSONObject] options:kNilOptions error:error];
}

- (NSString *)JSONString{
    return  [self JSONStringWithError:nil];
}
- (NSString *)JSONStringWithError:(NSError **)error{
    if ([self isKindOfClass:[NSString class]]) {
        return (NSString *)self;
    } else if ([self isKindOfClass:[NSData class]]) {
        return [[NSString alloc] initWithData:(NSData *)self encoding:NSUTF8StringEncoding];
    }
    
    return [[NSString alloc] initWithData:[self JSONDataWithError:error] encoding:NSUTF8StringEncoding];
}

- (id)JSONObject{
    return  [self JSONObjectWithError:nil];
}

- (id)JSONObjectWithError:(NSError **)error{
    
    if ([self isKindOfClass:[NSString class]]) {
        return [NSJSONSerialization JSONObjectWithData:[((NSString *)self) dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:error];
    } else if ([self isKindOfClass:[NSData class]]) {
        return [NSJSONSerialization JSONObjectWithData:(NSData *)self options:kNilOptions error:error];
    }
    return self;
}

@end

