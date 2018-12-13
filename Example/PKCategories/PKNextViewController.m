
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
