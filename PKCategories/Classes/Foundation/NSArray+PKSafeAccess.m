//
//  NSArray+PKSafeAccess.m
//  PKCategories
//
//  Created by zhanghao on 2018/10/28.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import "NSArray+PKSafeAccess.h"

@implementation NSArray (PKSafeAccess)

- (id)pk_objectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self objectAtIndex:index];
    }
    return nil;
}

- (NSUInteger)pk_indexOfObject:(id)anObject {
    NSParameterAssert(self.count);
    if ([self containsObject:anObject]) {
        return [self indexOfObject:anObject];
    }
    return 0;
}

- (NSString *)pk_stringAtIndex:(NSInteger)index {
    id value = [self pk_objectAtIndex:index];
    if (value == nil || value == [NSNull null] || [[value description] isEqualToString:@"<null>"]) {
        return nil;
    }
    if ([value isKindOfClass:[NSString class]]) {
        return (NSString*)value;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    }
    return nil;
}

- (NSNumber *)pk_numberAtIndex:(NSUInteger)index {
    id value = [self pk_objectAtIndex:index];
    if ([value isKindOfClass:[NSNumber class]]) {
        return (NSNumber*)value;
    }
    if ([value isKindOfClass:[NSString class]]) {
        static NSNumberFormatter *f;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
        });
        return [f numberFromString:(NSString*)value];
    }
    return nil;
}

- (NSArray *)pk_arrayAtIndex:(NSUInteger)index {
    id value = [self pk_objectAtIndex:index];
    if (value == nil || value == [NSNull null]) {
        return nil;
    }
    if ([value isKindOfClass:[NSArray class]]) {
        return value;
    }
    return nil;
}

- (NSDictionary *)pk_dictionaryAtIndex:(NSUInteger)index {
    id value = [self pk_objectAtIndex:index];
    if (value == nil || value == [NSNull null]) {
        return nil;
    }
    if ([value isKindOfClass:[NSDictionary class]]) {
        return value;
    }
    return nil;
}

- (NSInteger)pk_integerAtIndex:(NSUInteger)index {
    id value = [self pk_objectAtIndex:index];
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value integerValue];
    }
    return 0;
}

- (BOOL)pk_boolAtIndex:(NSUInteger)index {
    id value = [self pk_objectAtIndex:index];
    if (value == nil || value == [NSNull null]) {
        return NO;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value boolValue];
    }
    if ([value isKindOfClass:[NSString class]]) {
        return [value boolValue];
    }
    return NO;
}

- (CGFloat)pk_CGFloatAtIndex:(NSUInteger)index {
    id value = [self pk_objectAtIndex:index];
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value doubleValue];
    }
    return 0;
}

- (CGPoint)pk_CGPointAtIndex:(NSUInteger)index {
    id value = [self pk_objectAtIndex:index];
    if ([value isKindOfClass:[NSString class]]) {
        return CGPointFromString(value);
    }
    return CGPointZero;
}

- (CGSize)pk_CGSizeAtIndex:(NSUInteger)index {
    id value = [self pk_objectAtIndex:index];
    if ([value isKindOfClass:[NSString class]]) {
        return CGSizeFromString(value);
    }
    return CGSizeZero;
}

- (CGRect)pk_CGRectAtIndex:(NSUInteger)index {
    id value = [self pk_objectAtIndex:index];
    if ([value isKindOfClass:[NSString class]]) {
        return CGRectFromString(value);
    }
    return CGRectZero;
}

@end
