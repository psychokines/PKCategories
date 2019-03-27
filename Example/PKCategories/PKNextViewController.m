
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
    [self.view pk_beginIndicatorLoading];
    
    [self.view pk_showToastText:@"加载失败" delay:2];
    
    NSArray<NSString *> *array = @[@"~~~~~~~~~~", @"abc", @"abcdef", @"zhang-zhang-zheng"];
    NSArray *mapArray = [array pk_map:^id _Nonnull(NSString * _Nonnull obj) {
        return [obj stringByAppendingString:@"666"];
    }];
    NSLog(@"mapArray is: %@", mapArray);
    
    NSArray *filerArray = [array pk_filer:^BOOL(NSString * _Nonnull obj) {
        return obj.length < 5;
    }];
    NSLog(@"filerArray is: %@", filerArray);
    
    NSInteger lastLength = [array pk_filer:^BOOL(NSString * _Nonnull obj) {
        return obj.length > 3;
    }].lastObject.length;
    NSLog(@"lastLength is: %ld", (long)lastLength);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
