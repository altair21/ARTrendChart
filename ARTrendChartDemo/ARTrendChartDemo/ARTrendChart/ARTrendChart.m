//
//  ARTrendChart.m
//  ARTrendChartDemo
//
//  Created by intern03 on 16/6/20.
//  Copyright © 2016年 curacloudcorp. All rights reserved.
//

#import "ARTrendChart.h"

@interface ARTrendChart()

//data
@property (weak, nonatomic) NSArray<NSString*>* xAxisItem;
@property (weak, nonatomic) NSArray<NSNumber*>* yAxisItem;

//view
@property (weak, nonatomic) UIScrollView* scrollView;
@property (weak, nonatomic) UIView* xAxisView;
@property (weak, nonatomic) UIView* yAxisView;

@end

@implementation ARTrendChart {
	CGFloat _yMax;
	CGFloat _yMin;
	CGFloat _yAxisTextFontSize;
	UIColor* _yAxisTextColor;
	int _numberOfYElements;
	
	CGFloat _xMax;
	CGFloat _xMin;
	CGFloat _xAxisTextFontSize;
	UIColor* _xAxisTextColor;
	int _numberOfXElements;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self ARTrendChartInit];
	}
	return self;
}

- (void)awakeFromNib {
	[self ARTrendChartInit];
}

- (void)layoutSubviews {
	[super layoutSubviews];
}

- (void)ARTrendChartInit {
	//init property
	self.backgroundColor = [UIColor colorWithRed:0.3568 green:0.5137 blue:0.8 alpha:1];
	self.trendAreaColor = [UIColor colorWithRed:0.4824 green:0.6118 blue:0.8392 alpha:1];
	self.trendLineColor = [UIColor whiteColor];
	_yAxisTextColor = [UIColor whiteColor];
	_yAxisTextFontSize = 14.0f;
	
	//add views
	UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	scrollView.backgroundColor = [UIColor colorWithRed:0.3568 green:0.5137 blue:0.8 alpha:1];
	self.scrollView = scrollView;
	[self addSubview:scrollView];
	
	UIView* yAxisView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width / 2, self.frame.size.height - 10)];
//	yAxisView.layer.borderColor = [UIColor blackColor].CGColor;
//	yAxisView.layer.borderWidth = 1.0f;
	self.yAxisView = yAxisView;
	[self addSubview:yAxisView];
	
	UIView* xAxisView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 25, self.frame.size.width, 25)];
	xAxisView.backgroundColor = [UIColor colorWithRed:0.9608 green:0.9608 blue:0.9608 alpha:0.9608];
//	xAxisView.layer.borderColor = [UIColor blackColor].CGColor;
//	xAxisView.layer.borderWidth = 1.0f;
	self.xAxisView = xAxisView;
	[self addSubview:xAxisView];
	
}

#pragma mark - setter

- (void)setYAxisItem:(NSArray*)yAxisItem yAxisItemSummary:(NSString*)yAxisSummary yAxisTextFontSize:(CGFloat)yAxisTextFontSize yAxisTextColor:(UIColor*)yAxisTextColor {
	self.yAxisItem = yAxisItem;
	_numberOfYElements = (int)yAxisItem.count;
	_yMax = [yAxisItem[_numberOfYElements - 1] doubleValue];
	_yMin = [yAxisItem[0] doubleValue];
	if (yAxisSummary && ![yAxisSummary isEqualToString:@""]) {
		_numberOfYElements += 1;
	}
	_yAxisTextFontSize = yAxisTextFontSize;
	_yAxisTextColor = yAxisTextColor;
	
	CGSize labelSize = [@"text" sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:yAxisTextFontSize]}];
	CGFloat padding = (_yAxisView.frame.size.height - _numberOfYElements * labelSize.height) / (_numberOfYElements + 1);
	__block int index = 1;
	for (NSNumber* num in yAxisItem) {
		UILabel* label = [[UILabel alloc] init];
		label.text = [NSString stringWithFormat:@"%.0lf", [num doubleValue]];
		label.textAlignment = NSTextAlignmentLeft;
		label.font = [UIFont systemFontOfSize:yAxisTextFontSize];
		label.textColor = yAxisTextColor;
		label.frame = CGRectMake(0, _yAxisView.frame.size.height - index * (padding + labelSize.height) - padding, self.frame.size.width / 2, labelSize.height);
		[self.yAxisView addSubview:label];
		index++;
	}
	if (yAxisSummary && ![yAxisSummary isEqualToString:@""]) {
		UILabel* label = [[UILabel alloc] init];
		label.text = yAxisSummary;
		label.textAlignment = NSTextAlignmentLeft;
		label.font = [UIFont systemFontOfSize:yAxisTextFontSize];
		label.textColor = yAxisTextColor;
		label.frame = CGRectMake(0, _yAxisView.frame.size.height - index * (padding + labelSize.height) - padding, self.frame.size.width / 2, labelSize.height);
		[self.yAxisView addSubview:label];
	}
}

- (void)setXAxisItem:(NSArray *)xAxisItem xAxisItemSummary:(NSString *)xAxisSummary xAxisTextFontSize:(CGFloat)xAxisTextFontSize xAxisTextColor:(UIColor *)xAxisTextColor {
	self.xAxisItem = xAxisItem;
	_numberOfXElements = (int)xAxisItem.count;
	
	if (xAxisSummary && ![xAxisSummary isEqualToString:@""]) {
		_numberOfXElements += 1;
	}
	_xAxisTextFontSize = xAxisTextFontSize;
	_xAxisTextColor = xAxisTextColor;
	
	CGSize labelSize = [@"text" sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:xAxisTextFontSize]}];
	labelSize = CGSizeMake(labelSize.width + 10, labelSize.height + 10);
	CGFloat padding = 10.0f;
	_xAxisView.frame = CGRectMake(padding * 0.5, self.frame.size.height - labelSize.height, self.frame.size.width, self.scrollView.frame.size.height);
	int index = 0;
	for (NSString* str in xAxisItem) {
		UILabel* label = [[UILabel alloc] init];
		label.text = str;
		label.textAlignment = NSTextAlignmentCenter;
		label.font = [UIFont systemFontOfSize:xAxisTextFontSize];
		label.textColor = xAxisTextColor;
		label.frame = CGRectMake(index * (padding + labelSize.width), 0, _numberOfXElements * (labelSize.width + padding) - padding * 0.5, labelSize.height);
		[self.xAxisView addSubview:label];
		index++;
	}
	if (xAxisSummary && ![xAxisSummary isEqualToString:@""]) {
		UILabel* label = [[UILabel alloc] init];
		label.text = xAxisSummary;
		label.textAlignment = NSTextAlignmentCenter;
		label.font = [UIFont systemFontOfSize:xAxisTextFontSize];
		label.textColor = xAxisTextColor;
		label.frame = CGRectMake(index * (padding + labelSize.width), 0, _numberOfXElements * (labelSize.width + padding) - padding * 0.5, labelSize.height);
		[self.xAxisView addSubview:label];
	}
	self.scrollView.contentSize = self.xAxisView.frame.size;
}

@end
