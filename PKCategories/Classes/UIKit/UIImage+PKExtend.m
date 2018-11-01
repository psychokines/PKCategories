//
//  UIImage+PKExtend.m
//  PKCategories
//
//  Created by zhanghao on 2018/10/28.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import "UIImage+PKExtend.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (PKExtend)

+ (UIImage *)pk_imageWithColor:(UIColor *)color {
    return [self pk_imageWithColor:color size:CGSizeMake(1.f, 1.f)];
}

+ (UIImage *)pk_imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (BOOL)pk_hasAlphaChannel {
    if (self.CGImage == NULL) return NO;
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage) & kCGBitmapAlphaInfoMask;
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

+ (UIImage *)pk_getLaunchImage {
    NSString *viewOrientation = @"Portrait";
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        viewOrientation = @"Landscape";
    }
    NSArray *imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    UIWindow *currentWindow = [[UIApplication sharedApplication].windows firstObject];
    NSString *launchImageName = nil;
    for (NSDictionary *dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, currentWindow.bounds.size) &&
            [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            launchImageName = dict[@"UILaunchImageName"];
        }
    }
    if (!launchImageName) return nil;
    return [UIImage imageNamed:launchImageName];
}

+ (UIImage *)pk_imageWithCapturedLayer:(CALayer *)layer {
    UIGraphicsBeginImageContextWithOptions(layer.bounds.size, NO, [UIScreen mainScreen].scale);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}

+ (UIImage *)pk_imageWithCapturedFromImage:(UIImage *)bigImage inRect:(CGRect)imageRect {
    CGImageRef imageRef = bigImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, imageRect);
    CGSize size = CGSizeMake(CGRectGetWidth(imageRect), CGRectGetHeight(imageRect));
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, imageRect, subImageRef);
    UIImage *smallImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    return smallImage;
}

- (UIImage *)pk_imageWithScaledToTargetSize:(CGSize)targetSize {
    if (targetSize.width <= 0 || targetSize.height <= 0) return nil;
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, self.scale);
    [self drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)pk_imageWithScaledToTargetWidth:(CGFloat)targetWidth {
    if (targetWidth <= 0) return nil;
    CGSize originSize = self.size;
    if (originSize.width > targetWidth) {
        CGFloat scaleFactor = originSize.height / originSize.width;
        CGFloat targetHeight = targetWidth * scaleFactor;
        CGSize targetSize = CGSizeMake(targetWidth, targetHeight);
        return [self pk_imageWithScaledToTargetSize:targetSize];
    }
    return self;
}

- (UIImage *)pk_imageWithScaledToTargetHeight:(CGFloat)targetHeight {
    if (targetHeight <= 0) return nil;
    CGSize originSize = self.size;
    if (originSize.height > targetHeight) {
        CGFloat scaleFactor = originSize.width / originSize.height;
        CGFloat targetWidth = targetHeight * scaleFactor;
        CGSize targetSize = CGSizeMake(targetWidth, targetHeight);
        return [self pk_imageWithScaledToTargetSize:targetSize];
    }
    return self;
}

- (NSData *)pk_imageWithCompressedQualityToTargetKb:(NSInteger)targetKb {
    if (targetKb <= 0) return nil;
    CGFloat compression = 1.0f;
    CGFloat minCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(self, compression);
    NSUInteger imageKb = [imageData length] / 1024;
    while (imageKb > targetKb && compression > minCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(self, compression);
        imageKb = [imageData length] / 1024;
    }
    return imageData;
}

@end


@implementation UIImage (PKRotate) //From<https://github.com/ibireme/YYKit>

- (UIImage *)pk_imageByRotate:(CGFloat)radians fitSize:(BOOL)fitSize {
    size_t width = (size_t)CGImageGetWidth(self.CGImage);
    size_t height = (size_t)CGImageGetHeight(self.CGImage);
    CGRect newRect = CGRectApplyAffineTransform(CGRectMake(0., 0., width, height),
                                                fitSize ? CGAffineTransformMakeRotation(radians) : CGAffineTransformIdentity);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 (size_t)newRect.size.width,
                                                 (size_t)newRect.size.height,
                                                 8,
                                                 (size_t)newRect.size.width * 4,
                                                 colorSpace,
                                                 kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    if (!context) return nil;
    
    CGContextSetShouldAntialias(context, true);
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    CGContextTranslateCTM(context, +(newRect.size.width * 0.5), +(newRect.size.height * 0.5));
    CGContextRotateCTM(context, radians);
    
    CGContextDrawImage(context, CGRectMake(-(width * 0.5), -(height * 0.5), width, height), self.CGImage);
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    UIImage *img = [UIImage imageWithCGImage:imgRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imgRef);
    CGContextRelease(context);
    return img;
}

- (UIImage *)pk_imageFlipHorizontal:(BOOL)horizontal vertical:(BOOL)vertical {
    if (!self.CGImage) return nil;
    size_t width = (size_t)CGImageGetWidth(self.CGImage);
    size_t height = (size_t)CGImageGetHeight(self.CGImage);
    size_t bytesPerRow = width * 4;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    if (!context) return nil;
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), self.CGImage);
    UInt8 *data = (UInt8 *)CGBitmapContextGetData(context);
    if (!data) {
        CGContextRelease(context);
        return nil;
    }
    vImage_Buffer src = { data, height, width, bytesPerRow };
    vImage_Buffer dest = { data, height, width, bytesPerRow };
    if (vertical) {
        vImageVerticalReflect_ARGB8888(&src, &dest, kvImageBackgroundColorFill);
    }
    if (horizontal) {
        vImageHorizontalReflect_ARGB8888(&src, &dest, kvImageBackgroundColorFill);
    }
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    UIImage *img = [UIImage imageWithCGImage:imgRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imgRef);
    return img;
}

- (UIImage *)pk_imageByFlipHorizontal {
    return [self pk_imageFlipHorizontal:YES vertical:NO];
}

- (UIImage *)pk_imageByFlipVertical {
    return [self pk_imageFlipHorizontal:NO vertical:YES];
}

- (UIImage *)pk_imageByRotate180 {
    return [self pk_imageFlipHorizontal:YES vertical:YES];
}

- (UIImage *)pk_imageByRotateLeft90 {
    CGFloat degrees = 90 * M_PI / 180;
    return [self pk_imageByRotate:degrees fitSize:YES];
}

- (UIImage *)pk_imageByRotateRight90 {
    CGFloat degrees = -90 * M_PI / 180;
    return [self pk_imageByRotate:degrees fitSize:YES];
}

@end
