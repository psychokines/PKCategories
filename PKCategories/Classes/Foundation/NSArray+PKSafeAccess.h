//
//  NSArray+PKSafeAccess.h
//  PKCategories
//
//  Created by zhanghao on 2018/10/28.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<ObjectType> (PKSafeAccess)

/**
 *  根据数组下标获取对象，避免数组越界导致的crach，若传入index大于数组个数时，则返回nil
 *
 *  @param index 下标
 *
 *  @return 对象或nil
 */
- (nullable ObjectType)pk_objectAtIndex:(NSUInteger)index;

/**
 *  根据对象获取在数组内的下标，避免访问不存在对象时导致的crach，若对象不存在返回0
 *
 *  @param anObject 对象
 *
 *  @return 下标
 */
- (NSUInteger)pk_indexOfObject:(ObjectType)anObject;

- (nullable NSString *)pk_stringAtIndex:(NSInteger)index;

- (nullable NSNumber *)pk_numberAtIndex:(NSUInteger)index;

- (nullable NSArray *)pk_arrayAtIndex:(NSUInteger)index;

- (nullable NSDictionary *)pk_dictionaryAtIndex:(NSUInteger)index;

- (NSInteger)pk_integerAtIndex:(NSUInteger)index;

- (BOOL)pk_boolAtIndex:(NSUInteger)index;

- (CGFloat)pk_CGFloatAtIndex:(NSUInteger)index;

- (CGPoint)pk_CGPointAtIndex:(NSUInteger)index;

- (CGSize)pk_CGSizeAtIndex:(NSUInteger)index;

- (CGRect)pk_CGRectAtIndex:(NSUInteger)index;

@end
NS_ASSUME_NONNULL_END
