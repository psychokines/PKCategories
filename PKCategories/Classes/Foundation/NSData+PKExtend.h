//
//  NSData+PKExtend.h
//  PKCategories
//
//  Created by jiaohong on 2018/10/27.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (PKExtend)

/**
 *  返回一个json格式的对象(NSDictionary或NSArray)，如果出现错误则返回nil
 *
 *  @return json对象或nil
 */
- (nullable id)pk_jsonValueDecoded;

/**
 *  将NSData转换UTF8格式的字符串，如果出现错误则返回nil
 *
 *  @return UTF8格式的字符串或nil
 */
- (nullable NSString *)pk_UTF8StringEncoded;

@end

NS_ASSUME_NONNULL_END
