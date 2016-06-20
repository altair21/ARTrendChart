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


- (void)drawLine{
	
	//view是曲线的背景view
	UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 300, 300)];
	view.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:view];
	
	//第一、UIBezierPath绘制线段
	UIBezierPath *path = [UIBezierPath bezierPath];
	
	//四个点
	CGPoint point = CGPointMake(10, 10);
	CGPoint point1 = CGPointMake(200, 100);
	CGPoint point2 = CGPointMake(240, 200);
	CGPoint point3 = CGPointMake(290, 200);
	
	NSArray *arr = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:point],[NSValue valueWithCGPoint:point1],[NSValue valueWithCGPoint:point2],[NSValue valueWithCGPoint:point3], nil];
	NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, arr.count)];
	[arr enumerateObjectsAtIndexes:set options:0 usingBlock:^(NSValue *pointValue, NSUInteger idx, BOOL *stop){
		
		CGPoint point = [pointValue CGPointValue];
		[path addLineToPoint:point];
		
		//（一）rect折线画法
		CGRect rect;
		rect.origin.x = point.x - 1.5;
		rect.origin.y = point.y - 1.5;
		rect.size.width = 4;
		rect.size.height = 4;
		
		//（二）rect射线画法
//		        CGRect rect = CGRectMake(10, 10, 1, 1);
		
		UIBezierPath *arc= [UIBezierPath bezierPathWithOvalInRect:rect];
		[path appendPath:arc];
	}];
	//第三、UIBezierPath和CAShapeLayer关联
	CAShapeLayer *lineLayer = [CAShapeLayer layer];
	lineLayer.frame = CGRectMake(0, 150, 320, 400);
	lineLayer.fillColor = [UIColor redColor].CGColor;
	lineLayer.path = path.CGPath;
	lineLayer.strokeColor = [UIColor redColor].CGColor;
	[view.layer addSublayer:lineLayer];
	
	//以下代码为附加的
	//（一）像一个幕布一样拉开，显得有动画
	UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 100, 320, 400)];
	view1.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:view1];
	
	[UIView animateWithDuration:5 animations:^{
		view1.frame = CGRectMake(320, 100, 320, 400);
	}];
	
}

@end
