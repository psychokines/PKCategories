//
//  UIView+PKExtend.m
//  PKCategories
//
//  Created by jiaohong on 2018/10/28.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import "UIView+PKExtend.h"
#import <objc/runtime.h>

@implementation UIView (PKFrameAdjust)

- (CGFloat)pk_left {
    return self.frame.origin.x;
}

- (void)setPk_left:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)pk_top {
    return self.frame.origin.y;
}

- (void)setPk_top:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)pk_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setPk_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)pk_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setPk_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)pk_width {
    return self.frame.size.width;
}

- (void)setPk_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)pk_height {
    return self.frame.size.height;
}

- (void)setPk_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)pk_centerX {
    return self.center.x;
}

- (void)setPk_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)pk_centerY {
    return self.center.y;
}

- (void)setPk_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)pk_origin {
    return self.frame.origin;
}

- (void)setPk_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)pk_size {
    return self.frame.size;
}

- (void)setPk_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

@end


@implementation UIView (PKVisuals)

- (void)pk_addCornerRadius:(CGFloat)radius byRoundingCorners:(UIRectCorner)corners {
    if (!self.translatesAutoresizingMaskIntoConstraints) {
        [self.superview layoutIfNeeded];
    }
    CGRect rect = self.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (CAShapeLayer *)pk_edgeLineAssociated {
    CAShapeLayer *edgeLayer = objc_getAssociatedObject(self, _cmd);
    if (!edgeLayer) {
        edgeLayer = [CAShapeLayer layer];
        edgeLayer.zPosition = 2999;
        objc_setAssociatedObject(self, _cmd, edgeLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return edgeLayer;
}

- (void)pk_addEdgeLineWidth:(CGFloat)width color:(UIColor *)color byEdgePosition:(PKEdgeLinePosition)position {
    if (!self.translatesAutoresizingMaskIntoConstraints) {
        [self.superview layoutIfNeeded];
    }
    if (CGRectIsEmpty(self.frame) || !position) return;
    if (width <= 0) {
        CALayer *layer = objc_getAssociatedObject(self, @selector(pk_edgeLineAssociated));
        if (layer) {
            [layer removeFromSuperlayer];
            objc_setAssociatedObject(self, @selector(pk_edgeLineAssociated), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        return;
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat halfWidth = width * 0.5;
    if (position & PKEdgeLinePositionLeft) {
        [path moveToPoint:CGPointMake(halfWidth, 0)];
        [path addLineToPoint:CGPointMake(halfWidth, self.frame.size.height)];
    }
    if (position & PKEdgeLinePositionRight) {
        [path moveToPoint:CGPointMake(self.frame.size.width - halfWidth, 0)];
        [path addLineToPoint:CGPointMake(self.frame.size.width - halfWidth, self.frame.size.height)];
    }
    if (position & PKEdgeLinePositionTop) {
        [path moveToPoint:CGPointMake(0, halfWidth)];
        [path addLineToPoint:CGPointMake(self.frame.size.width, halfWidth)];
    }
    if (position & PKEdgeLinePositionBottom) {
        [path moveToPoint:CGPointMake(0, self.frame.size.height - halfWidth)];
        [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height - halfWidth)];
    }
    self.pk_edgeLineAssociated.path = path.CGPath;
    self.pk_edgeLineAssociated.strokeColor = color.CGColor;
    self.pk_edgeLineAssociated.lineWidth = width;
    self.pk_edgeLineAssociated.fillColor = [UIColor clearColor].CGColor;
    if (!self.pk_edgeLineAssociated.superlayer) {
        [self.layer addSublayer:self.pk_edgeLineAssociated];
    }
}

- (void)pk_addDefaultEdgeLineByPosition:(PKEdgeLinePosition)position {
    return [self pk_addEdgeLineWidth:1 / [UIScreen mainScreen].scale color:[UIColor grayColor] byEdgePosition:position];
}

@end


@implementation UIView (PKExtend)

- (void)pk_removeAllSubviews {
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}

- (UIViewController *)pk_inViewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end


static void *UIViewAssociatedPKBadgeLabelKey = &UIViewAssociatedPKBadgeLabelKey;
@implementation UIView (PKBadge)

- (CGRect)_badgeDefaultRect {
    return CGRectMake(0, 0, 18, 18);
}

- (UILabel *)pk_badgeLabel {
    UILabel *badgeLabel = objc_getAssociatedObject(self, UIViewAssociatedPKBadgeLabelKey);
    if (!badgeLabel) {
        badgeLabel = [[UILabel alloc] init];
        badgeLabel.backgroundColor = [UIColor redColor];
        badgeLabel.textColor = [UIColor whiteColor];
        badgeLabel.font = [UIFont systemFontOfSize:13];
        badgeLabel.textAlignment = NSTextAlignmentCenter;
        badgeLabel.frame = [self _badgeDefaultRect];
        badgeLabel.center = CGPointMake(self.bounds.size.width, 0);
        badgeLabel.layer.cornerRadius = badgeLabel.frame.size.height / 2;
        badgeLabel.layer.masksToBounds = YES;
        badgeLabel.alpha = 0;
        [self addSubview:badgeLabel];
        [self bringSubviewToFront:badgeLabel];
        objc_setAssociatedObject(self, UIViewAssociatedPKBadgeLabelKey, badgeLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return badgeLabel;
}

- (void)setBadgeText:(NSString *)text {
    self.pk_badgeDisplaying = YES;
    self.pk_badgeLabel.transform = CGAffineTransformIdentity;
    self.pk_badgeLabel.text = text;
    
    if (text && text.length) {
        self.pk_badgeLabel.frame = [self _badgeDefaultRect];
        CGFloat _width = [self.pk_badgeLabel sizeThatFits:CGSizeMake(MAXFLOAT, self.pk_badgeLabel.frame.size.height)].width;
        CGRect originRect = self.pk_badgeLabel.frame;
        originRect.size.width = _width + 8;
        if (originRect.size.height > originRect.size.width) {
            originRect.size.width = originRect.size.height; // 使宽度>=高度
        }
        self.pk_badgeLabel.frame = originRect;
    }
    
    if ([self pk_badgeAlwaysRound]) {
        CGPoint originCenter = self.pk_badgeLabel.center;
        CGRect originRect = self.pk_badgeLabel.frame;
        originRect.size.height = originRect.size.width;
        self.pk_badgeLabel.frame  = originRect;
        self.pk_badgeLabel.layer.cornerRadius = self.pk_badgeLabel.frame.size.height / 2;
        self.pk_badgeLabel.center = originCenter;
    }
    
    CGFloat transformHeight = [self pk_badgeTransformHeight];
    if (transformHeight > 0) {
        CGFloat scale = transformHeight / self.pk_badgeLabel.frame.size.height;
        CGAffineTransform transform = self.pk_badgeLabel.transform;
        self.pk_badgeLabel.transform = CGAffineTransformScale(transform, scale, scale);
    }
    
    [self pk_badgeOffset:[self pk_badgeOffset]];
}

- (void)pk_showBadgeWithText:(NSString *)text {
    [self setBadgeText:text];
    if (self.pk_badgeLabel.alpha > 0) return;
    self.pk_badgeLabel.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.pk_badgeLabel.alpha = 1;
    }];
}

- (void)pk_badgeHide {
    if (!self.pk_badgeDisplaying) return;
    [UIView animateWithDuration:0.25 animations:^{
        self.pk_badgeLabel.alpha = 0;
    } completion:^(BOOL finished) {
        self.pk_badgeDisplaying = NO;
    }];
}

- (void)pk_badgeRemove {
    if (!self.pk_badgeDisplaying) return;
    [UIView animateWithDuration:0.25 animations:^{
        self.pk_badgeLabel.alpha = 0;
    } completion:^(BOOL finished) {
        self.pk_badgeDisplaying = NO;
        [self.pk_badgeLabel removeFromSuperview];
        objc_setAssociatedObject(self, @selector(pk_badgeAlwaysRound), @(NO), OBJC_ASSOCIATION_ASSIGN);
        objc_setAssociatedObject(self, @selector(pk_badgeOffset), [NSValue valueWithUIOffset:UIOffsetZero], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, UIViewAssociatedPKBadgeLabelKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }];
}

- (UIOffset)pk_badgeOffset {
    return [objc_getAssociatedObject(self, _cmd) UIOffsetValue];
}

- (void)pk_badgeOffset:(UIOffset)offset {
    self.pk_badgeDisplaying = YES;
    NSValue *value = [NSValue valueWithUIOffset:offset];
    objc_setAssociatedObject(self, @selector(pk_badgeOffset), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    CGSize originSize = self.pk_badgeLabel.frame.size;
    CGFloat offsetX = (self.bounds.size.width - self.pk_badgeLabel.frame.size.width / 2) + offset.horizontal;
    CGFloat offsetY = (-self.pk_badgeLabel.frame.size.height / 2) + offset.vertical;
    self.pk_badgeLabel.frame = CGRectMake(offsetX, offsetY, originSize.width, originSize.height);
}

- (BOOL)pk_badgeAlwaysRound {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)pk_badgeAlwaysRound:(BOOL)isRound {
    objc_setAssociatedObject(self, @selector(pk_badgeAlwaysRound), @(isRound), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setBadgeText:self.pk_badgeLabel.text];
}

- (CGFloat)pk_badgeTransformHeight {
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)pk_badgeTransformHeight:(CGFloat)height {
    objc_setAssociatedObject(self, @selector(pk_badgeTransformHeight), @(height), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setBadgeText:self.pk_badgeLabel.text];
}

- (BOOL)pk_badgeDisplaying {
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)setPk_badgeDisplaying:(BOOL)pk_badgeDisplaying {
    objc_setAssociatedObject(self, @selector(pk_badgeDisplaying), @(pk_badgeDisplaying), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
