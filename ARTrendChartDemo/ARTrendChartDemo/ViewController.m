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
	
	ARTrendChart* chart = [[ARTrendChart alloc] initWithFrame:CGRectMake(0, 40, 320, 200)];
	[chart setYAxisItem:@[@70.0, @90.0, @110.0, @130.0] yAxisItemSummary:@"血压 mm.HG" yAxisTextFontSize:14.0 yAxisTextColor:[UIColor whiteColor]];
	[self.view addSubview:chart];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
