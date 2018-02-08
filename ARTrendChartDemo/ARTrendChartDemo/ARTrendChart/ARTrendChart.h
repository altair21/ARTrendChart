//
//  ARTrendChart.h
//  ARTrendChartDemo
//
//  Created by intern03 on 16/6/20.
//  Copyright © 2016年 altair21. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARTrendChart : UIView


@property (weak, nonatomic) UIView* trendChart;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)setYAxisItem:(NSArray*)yAxisItem yAxisItemSummary:(NSString*)yAxisSummary yAxisTextFontSize:(CGFloat)yAxisTextFontSize yAxisTextColor:(UIColor*)yAxisTextColor;
- (void)setXAxisItem:(NSArray*)xAxisItem xAxisItemSummary:(NSString*)xAxisSummary xAxisTextFontSize:(CGFloat)xAxisTextFontSize xAxisTextColor:(UIColor*)xAxisTextColor;
- (void)setBackgroundColor:(UIColor*)backgroundColor trendAreaColor:(UIColor*)trendAreaColor trendLineColor:(UIColor*)trendLineColor selectColor:(UIColor*)selectColor;
- (void)setData:(NSArray*)dataArr;

- (void)appear;

@end
