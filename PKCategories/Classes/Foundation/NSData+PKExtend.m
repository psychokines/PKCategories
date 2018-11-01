//
//  NSData+PKExtend.m
//  PKCategories
//
//  Created by jiaohong on 2018/10/27.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import "NSData+PKExtend.h"

@implementation NSData (PKExtend)

- (id)pk_jsonValueDecoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error = nil;
        id value = [NSJSONSerialization JSONObjectWithData:self options:kNilOptions error:&error];
        if (error) {
            NSLog(@"jsonValueDecoded error:%@", error);
        }
        return value;
    }
    return nil;
}

- (NSString *)pk_UTF8StringEncoded {
    if (self.length > 0) {
        return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    }
    return nil;
}

@end
