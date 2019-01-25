//
//  NSDictionary+PKSafeAccess.m
//  PKCategories
//
//  Created by zhanghao on 2018/10/25.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import "NSDictionary+PKSafeAccess.h"

@implementation NSDictionary (PKSafeAccess)

- (BOOL)pk_containsKey:(NSString *)aKey {
    if (aKey == nil) {
        return NO;
    }
    return [[self allKeys] containsObject:aKey];
}

- (id)pk_objectForKey:(id)aKey {
    if (aKey == nil) {
        return nil;
    }
    id value = [self objectForKey:aKey];
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}

- (id)pk_objectForKey:(id)aKey defaultObj:(id)defObj {
    id value = [self pk_objectForKey:aKey];
    if (value) {
        return value;
    }
    return defObj;
}

- (NSArray *)pk_arrayForKey:(id)aKey {
    id value = [self pk_objectForKey:aKey];
    if ([value isKindOfClass:[NSArray class]]) {
        return value;
    }
    return nil;
}

- (NSDictionary *)pk_dictionaryForKey:(id)aKey {
    id value = [self pk_objectForKey:aKey];
    if ([value isKindOfClass:[NSDictionary class]]) {
        return value;
    }
    return nil;
}

- (NSString *)pk_stringForKey:(id)aKey {
    id value = [self pk_objectForKey:aKey];
    if (value == nil || value == [NSNull null]) {
        return nil;
    }
    if ([value isKindOfClass:[NSString class]]) {
        return (NSString *)value;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    }
    return nil;
}

- (NSNumber *)pk_numberForKey:(id)aKey {
    id value = [self pk_objectForKey:aKey];
    if ([value isKindOfClass:[NSNumber class]]) {
        return (NSNumber *)value;
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

- (BOOL)pk_boolForKey:(id)aKey {
    return [self pk_numberForKey:aKey].boolValue;
}

- (NSInteger)pk_integerForKey:(id)aKey {
    return [self pk_numberForKey:aKey].integerValue;
}

- (CGFloat)pk_CGFloatForKey:(id)aKey {
    return [self pk_numberForKey:aKey].doubleValue;
}

- (CGPoint)pk_CGPointForKey:(id)aKey {
    return CGPointFromString([self pk_stringForKey:aKey]);
}

- (CGSize)pk_CGSizeForKey:(id)aKey {
    return CGSizeFromString([self pk_stringForKey:aKey]);
}

- (CGRect)pk_CGRectForKey:(id)aKey {
    return CGRectFromString([self pk_stringForKey:aKey]);
}
@end

@implementation NSMutableDictionary (PKSafeAccess)

- (void)pk_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (anObject != nil) {
        [self setObject:anObject forKey:aKey];
    }
}

- (void)pk_setCGPoint:(CGPoint)p forKey:(id<NSCopying>)aKey {
    self[aKey] = NSStringFromCGPoint(p);
}

- (void)pk_setCGSize:(CGSize)s forKey:(id<NSCopying>)aKey {
    self[aKey] = NSStringFromCGSize(s);
}

- (void)pk_setCGRect:(CGRect)r forKey:(id<NSCopying>)aKey {
    self[aKey] = NSStringFromCGRect(r);
}

@end
