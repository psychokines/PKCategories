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
