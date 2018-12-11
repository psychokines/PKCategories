//
//  PKViewController.m
//  PKCategories
//
//  Created by gren-beans on 11/01/2018.
//  Copyright (c) 2018 gren-beans. All rights reserved.
//

#import "PKViewController.h"
#import <PKCategories/PKCategories.h>

@interface PKViewController ()

@end

@implementation PKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString *string = [NSNumber pk_stringWithDigits:@(0.1256) keepPlaces:3];
    NSLog(@"string is: %@", string);

    NSString *string5 = [NSNumber pk_percentStringWithDoubleDigits:@(0.126)];
    NSLog(@"string5 is: %@", string5);
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
