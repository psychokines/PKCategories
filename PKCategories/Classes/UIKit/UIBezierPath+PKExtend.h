//
//  UIBezierPath+PKExtend.h
//  PKCategories
//
//  Created by jiaohong on 2019/1/8.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBezierPath (PKExtend)

/**
 Creates and returns a new UIBezierPath object initialized with the text glyphs
 generated from the specified font.
 
 @discussion It doesnot support apple emoji. If you want get emoji image, try
 [UIImage imageWithEmoji:size:] in `UIImage(YYAdd)`.
 
 @param text The text to generate glyph path.
 @param font The font to generate glyph path.
 
 @return A new path object with the text and font, or nil if an error occurs.
 */
+ (nullable UIBezierPath *)pk_bezierPathWithText:(NSString *)text font:(UIFont *)font;

/** 绘制矩形框 */
- (void)pk_addRect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
