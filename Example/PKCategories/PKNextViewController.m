
//
//  PKNextViewController.m
//  PKCategories_Example
//
//  Created by zhanghao on 2018/12/12.
//  Copyright © 2018年 gren-beans. All rights reserved.
//

#import "PKNextViewController.h"
#import <PKCategories/PKCategories.h>

@interface PKNextViewController ()

@end

@implementation PKNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self example1];
    [self example2];
    
//    [self example3];
//    [self example4];
//    [self example5];
}

- (void)example1 {
    UIImage *loadingImage = [UIImage imageNamed:@"hud_loading_03"];
    [self.view pk_showHud:@"正在加载" image:loadingImage spin:YES layout:PKHudLayoutTop];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view pk_hideHud];
        UIImage *successImage = [UIImage imageNamed:@"hud_success_01"];
        [self.view pk_showHud:@"加载完成" image:successImage layout:PKHudLayoutTop];
    });
}

- (void)example2 {
    PKHudStyle *style = [[PKHudStyle alloc] init];
    style.positionOffset = 200;
    style.cornerRadius = 4;
    
    UIImage *loadingImage = [UIImage imageNamed:@"hud_loading_03"];
    [self.view pk_showHud:@"正在加载" image:loadingImage spin:YES layout:PKHudLayoutLeft position:PKHudPositionTop style:style];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view pk_hideHud];
        UIImage *failureImage = [UIImage imageNamed:@"hud_failure_01"];
        [self.view pk_showHud:@"加载失败" image:failureImage spin:NO layout:PKHudLayoutLeft position:PKHudPositionTop style:style];
    });
    
    
//    NSArray<NSString *> *array = @[@"~~~~~~~~~~", @"abc", @"abcdef", @"zhang-zhang-zheng"];
//    NSArray *mapArray = [array pk_map:^id _Nonnull(NSString * _Nonnull obj) {
//        return [obj stringByAppendingString:@"666"];
//    }];
//    NSLog(@"mapArray is: %@", mapArray);
//
//    NSArray *filerArray = [array pk_filer:^BOOL(NSString * _Nonnull obj) {
//        return obj.length < 5;
//    }];
//    NSLog(@"filerArray is: %@", filerArray);
//
//    NSInteger lastLength = [array pk_filer:^BOOL(NSString * _Nonnull obj) {
//        return obj.length > 3;
//    }].lastObject.length;
//    NSLog(@"lastLength is: %ld", (long)lastLength);
}

- (void)example3 {
    UIImageView *imageView = [UIImageView new];
    imageView.frame = CGRectMake(50, 100, 100, 100);
    imageView.layer.cornerRadius = 50;
    imageView.layer.masksToBounds = YES;
    [self.view addSubview:imageView];
    imageView.image = [self getImageWithName:@"PsychokinesisTeam" size:100];
}

- (UIImage *)getImageWithName:(NSString *)name size:(CGFloat)size {
    if (name.length == 0) {
        name = @"#";
    } else {
        if ([name pk_isAllChineseCharacters]) {
            name = [name substringFromIndex:name.length - 1];
        } else {
            name = [[name substringToIndex:1] uppercaseString];
        }
    }
    return [UIImage pk_imageWithString:name fontSize:size margin:20];
}

- (void)example4 {
    UIColor *color = [[UIColor pk_colorWithHexString:@"#FFC0CB"] colorWithAlphaComponent:0.2];
    NSArray<NSNumber *> *array = [color pk_RGBAValues];
    NSLog(@"%@", array);
}

- (void)example5 {
    NSString *bundle = [NSBundle pk_mainBundleWithName:@"pk_filesA.json"];
    NSString *jsonStriing = [[NSString alloc] initWithContentsOfFile:bundle
                                                            encoding:NSUTF8StringEncoding
                                                               error:nil];
    NSArray *array = [NSArray pk_arrayWithJSONString:jsonStriing];
    NSLog(@"array======> %@", array);
}

@end
