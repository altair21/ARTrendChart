//
//  ViewController.m
//  ARTrendChartDemo
//
//  Created by intern03 on 16/6/20.
//  Copyright © 2016年 curacloudcorp. All rights reserved.
//

#import "ViewController.h"
#import "ARTrendChart.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	ARTrendChart* chart = [[ARTrendChart alloc] initWithFrame:CGRectMake(0, 40, 320, 230)];
	[chart setYAxisItem:@[@70.0, @90.0, @110.0, @130.0] yAxisItemSummary:@"血压 mm.HG" yAxisTextFontSize:14.0 yAxisTextColor:[UIColor whiteColor]];
	[chart setXAxisItem:@[@"06/01", @"06/02", @"06/03", @"06/04", @"06/05", @"06/06", @"06/07", @"06/08", @"06/09"] xAxisItemSummary:nil xAxisTextFontSize:14.0 xAxisTextColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1]];
	[self.view addSubview:chart];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
