//
//  ARTrendChart.h
//  ARTrendChartDemo
//
//  Created by intern03 on 16/6/20.
//  Copyright © 2016年 curacloudcorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARTrendChart : UIView


@property (weak, nonatomic) UIColor* backgroundColor;
@property (weak, nonatomic) UIColor* trendAreaColor;
@property (weak, nonatomic) UIColor* trendLineColor;
@property (weak, nonatomic) UIColor* selectColor;

- (void)setYAxisItem:(NSArray*)yAxisItem yAxisItemSummary:(NSString*)yAxisSummary yAxisTextFontSize:(CGFloat)yAxisTextFontSize yAxisTextColor:(UIColor*)yAxisTextColor;
- (void)setXAxisItem:(NSArray*)xAxisItem xAxisItemSummary:(NSString*)xAxisSummary xAxisTextFontSize:(CGFloat)xAxisTextFontSize xAxisTextColor:(UIColor*)xAxisTextColor;

@end
