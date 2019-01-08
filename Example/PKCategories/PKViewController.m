//
//  PKViewController.m
//  PKCategories
//
//  Created by gren-beans on 11/01/2018.
//  Copyright (c) 2018 gren-beans. All rights reserved.
//

#import "PKViewController.h"
#import <PKCategories/PKCategories.h>
#import "PKNextViewController.h"

@interface PKViewController ()

@end

@implementation PKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray *mud = [NSMutableArray array];
    [mud removeLastObject];
    
    NSString *aText = nil;
    [mud pk_addObject:aText];
    
    NSString *string = [NSNumber pk_stringWithDigits:@(0.1256) keepPlaces:3];
    NSLog(@"string is: %@", string);

    NSString *string5 = [NSNumber pk_percentStringWithDoubleDigits:@(0.126)];
    NSLog(@"string5 is: %@", string5);
    
    UIBezierPath *ppath = [UIBezierPath pk_bezierPathWithText:@"圣诞快乐" font:[UIFont systemFontOfSize:27]];
    [UIBezierPath pk_bezierPathWithText:@"圣诞快乐" font:[UIFont systemFontOfSize:27]];
    [ppath pk_addRect:CGRectMake(100, 300, 200, 100)];
    
    CAShapeLayer *aLayer = [CAShapeLayer layer];
    [self.view.layer addSublayer:aLayer];
    aLayer.frame = CGRectMake(100, 300, 200, 100);
    aLayer.backgroundColor = [UIColor redColor].CGColor;
    aLayer.path = ppath.CGPath;
    
    [self test];
}

- (void)test {
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    aButton.frame = CGRectMake(50, 200, 100, 100);
    aButton.backgroundColor = [UIColor orangeColor];
    [aButton setTitle:@"button" forState:UIControlStateNormal];
    [aButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:aButton];
    
    //    [aButton pk_badgeOffset:UIOffsetMake(50, 0)];
    [aButton pk_showBadgeWithText:@"新功能"];
    aButton.pk_badgeLabel.font = [UIFont systemFontOfSize:9];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage pk_imageWithColor:[UIColor pk_randomColor]] forBarMetrics:UIBarMetricsDefault];
}

- (void)buttonClicked:(UIButton *)sender {
    [sender pk_badgeRemove];
    
    PKNextViewController *vc = [PKNextViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
