//
//  ARTrendChart.m
//  ARTrendChartDemo
//
//  Created by intern03 on 16/6/20.
//  Copyright © 2016年 curacloudcorp. All rights reserved.
//

#import "ARTrendChart.h"
#import "UIBezierPath+LxThroughPointsBezier.h"

@interface ARTrendChart() <UIScrollViewDelegate, UIGestureRecognizerDelegate>

//data
@property (weak, nonatomic) NSArray<NSString*>* xAxisItem;
@property (weak, nonatomic) NSArray<NSNumber*>* yAxisItem;

//view
@property (weak, nonatomic) UIScrollView* scrollView;
@property (weak, nonatomic) UIView* xAxisView;
@property (weak, nonatomic) UIView* yAxisView;

@end

@implementation ARTrendChart {
	UIColor* _backgroundColor;
	UIColor* _trendAreaColor;
	UIColor* _trendLineColor;
	UIColor* _selectColor;
	
	CGFloat _screenWidth;
	
	CGFloat _yMax;
	CGFloat _yMin;
	CGFloat _yAxisTextFontSize;
	UIColor* _yAxisTextColor;
	int _numberOfYElements;
	
	CGFloat _yMaxCenterY;
	CGFloat _yMinCenterY;
	CGFloat _yAxisUnitLength;
	
	CGFloat _xMax;
	CGFloat _xMin;
	CGFloat _xAxisTextFontSize;
	UIColor* _xAxisTextColor;
	int _numberOfXElements;
	
	CGFloat _xAxisTrailing;
	CGSize _xAxisLabelSize;
	CGFloat _xAxisPadding;
	CGFloat _canvasWidth;
	CGFloat _maxScrollViewContentOffset;
	CGRect _trendChartFrame;
	UILabel* _currentSelectLabel;
	UIView* _currentSelectPointView;
	UILabel* _currentSelectPointLabel;
	
	NSMutableArray* _pointArr;	//存储数据点原始高度
	NSMutableArray* _pointCenterArr;	//存储数据点中心位置坐标，高度为转换后的高度
	NSArray* _dataArr;	//数据点信息
	
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self ARTrendChartInit];
	}
	return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
	[self ARTrendChartInit];
}

- (void)layoutSubviews {
	[super layoutSubviews];
}

- (void)ARTrendChartInit {
	//init property
	_backgroundColor = [UIColor colorWithRed:0.3568 green:0.5137 blue:0.8 alpha:1];
	_trendAreaColor = [UIColor colorWithRed:0.4824 green:0.6118 blue:0.8392 alpha:1];
	_trendLineColor = [UIColor whiteColor];
	_selectColor = [UIColor colorWithRed:0.3568 green:0.5137 blue:0.8 alpha:1];
	_yAxisTextColor = [UIColor whiteColor];
	_yAxisTextFontSize = 14.0f;
	_canvasWidth = 0;
	_pointCenterArr = [[NSMutableArray alloc] init];
	_screenWidth = [UIApplication sharedApplication].keyWindow.bounds.size.width;
	_currentSelectLabel = [[UILabel alloc] init];
	_currentSelectPointView = [[UIView alloc] init];
	_currentSelectPointLabel = [[UILabel alloc] init];
	
	//add views
	UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	scrollView.backgroundColor = [UIColor colorWithRed:0.3568 green:0.5137 blue:0.8 alpha:1];
//	[scrollView setCanCancelContentTouches:YES];
	[scrollView setDelaysContentTouches:NO];
	[scrollView setBounces:NO];
	[scrollView setShowsHorizontalScrollIndicator:NO];
	self.scrollView = scrollView;
	[self addSubview:scrollView];
	
	UIView* yAxisView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width / 2, self.frame.size.height - 10)];
	self.yAxisView = yAxisView;
	[self addSubview:yAxisView];
	
	UIView* xAxisView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 25, self.frame.size.width, 25)];
	xAxisView.backgroundColor = [UIColor colorWithRed:0.9608 green:0.9608 blue:0.9608 alpha:0.9608];
	self.xAxisView = xAxisView;
	[self.scrollView addSubview:xAxisView];
	
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
	
	CGSize labelSize = [@"20000" sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:yAxisTextFontSize]}];
	CGFloat padding = (_yAxisView.frame.size.height - _numberOfYElements * labelSize.height) / (_numberOfYElements + 1);
	_yAxisView.frame = CGRectMake(_yAxisView.frame.origin.x, _yAxisView.frame.origin.y, 0, _yAxisView.frame.size.height);
	__block int index = 1;
	for (NSNumber* num in yAxisItem) {
		UILabel* label = [[UILabel alloc] init];
		label.text = [NSString stringWithFormat:@"%.0lf", [num doubleValue]];
		label.textAlignment = NSTextAlignmentLeft;
		label.font = [UIFont systemFontOfSize:yAxisTextFontSize];
		label.textColor = yAxisTextColor;
		label.frame = CGRectMake(0, _yAxisView.frame.size.height - index * (padding + labelSize.height) - padding, self.frame.size.width / 2, labelSize.height);
		[self.yAxisView addSubview:label];
		if (index == 1) {
			_yMinCenterY = label.center.y;
		} else if (index == yAxisItem.count) {
			_yMaxCenterY = label.center.y;
		}
		index++;
	}
	_yAxisUnitLength = (_yMinCenterY - _yMaxCenterY) / (_yMax - _yMin);
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
	
	_xAxisLabelSize = [@"06/04" sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:xAxisTextFontSize]}];
	_xAxisPadding = 5.0f;
	_xAxisLabelSize = CGSizeMake(_xAxisLabelSize.width + 20, _xAxisLabelSize.height + 0.333333 * _xAxisPadding);
	_canvasWidth = _numberOfXElements * (_xAxisLabelSize.width + _xAxisPadding) + _xAxisLabelSize.width;
	_xAxisView.frame = CGRectMake(0, self.scrollView.frame.size.height - _xAxisLabelSize.height - 3 * _xAxisPadding, _canvasWidth, _xAxisLabelSize.height + 3 * _xAxisPadding);
	_xAxisTrailing = _xAxisLabelSize.width;
	
	[_pointCenterArr removeAllObjects];
	int index = 0;
	for (NSString* str in xAxisItem) {
		[self setXAxisLabelWithStr:str index:index];
		index++;
	}
	if (xAxisSummary && ![xAxisSummary isEqualToString:@""]) {
		[self setXAxisLabelWithStr:xAxisSummary index:index];
	}
	self.scrollView.contentSize = CGSizeMake(_xAxisView.frame.size.width, self.scrollView.frame.size.height);
	_maxScrollViewContentOffset = [self.scrollView contentSize].width - self.scrollView.frame.size.width;
	[self.scrollView setScrollEnabled:YES];
}

- (void)setXAxisLabelWithStr:(NSString*)str index:(int)index {
	UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xAxisLabelTapped:)];
	tapGesture.delegate = self;
	UILabel* label = [[UILabel alloc] init];
	label.text = str;
	label.tag = index;
	label.textAlignment = NSTextAlignmentCenter;
	label.font = [UIFont systemFontOfSize:_xAxisTextFontSize];
	label.textColor = _xAxisTextColor;
	label.frame = CGRectMake(index * (_xAxisPadding + _xAxisLabelSize.width) + _xAxisLabelSize.width, _xAxisPadding, _xAxisLabelSize.width, _xAxisLabelSize.height + _xAxisPadding * 0.5);
	label.layer.borderColor = _selectColor.CGColor;
	label.layer.cornerRadius = _xAxisPadding * 2;
	label.userInteractionEnabled = YES;
	[label addGestureRecognizer:tapGesture];
	[self.xAxisView addSubview:label];
	[_pointCenterArr addObject:[NSValue valueWithCGPoint:CGPointMake(label.center.x, 0)]];
	
}

- (void)setBackgroundColor:(UIColor *)backgroundColor trendAreaColor:(UIColor *)trendAreaColor trendLineColor:(UIColor *)trendLineColor selectColor:(UIColor *)selectColor {
	_backgroundColor = backgroundColor;
	self.backgroundColor = backgroundColor;
	self.scrollView.backgroundColor = backgroundColor;
	_trendAreaColor = trendAreaColor;
	_trendLineColor = trendLineColor;
	_selectColor = selectColor;
}

- (void)setData:(NSArray *)dataArr {
	_dataArr = dataArr;
	
	UIView* trendChart = [[UIView alloc] init];
	self.trendChart = trendChart;
    _pointArr = [[NSMutableArray alloc] init];
	NSLog(@"%lf", _xAxisTrailing);
	for (int i = 0; i < dataArr.count; i++) {
		CGPoint point = CGPointMake([_pointCenterArr[i] CGPointValue].x, [self convertYAxisToChart:dataArr[i]]);
		_pointCenterArr[i] = [NSValue valueWithCGPoint:point];
		[_pointArr addObject:[NSValue valueWithCGPoint:point]];
		UIView* pointView = [[UIView alloc] initWithFrame:CGRectMake(point.x - 1, point.y - 1, 2, 2)];
		pointView.backgroundColor = [UIColor whiteColor];
//		[self.scrollView addSubview:pointView];
	}
	CGFloat areaLeft = [_pointCenterArr[0] CGPointValue].x;
	CGFloat areaRight = [_pointCenterArr[dataArr.count-1] CGPointValue].x;
	
	//填充区域
	CGPoint point1 = CGPointMake([_pointCenterArr[dataArr.count-1] CGPointValue].x, _xAxisView.frame.origin.y + 10);
	CGPoint point2 = CGPointMake([_pointCenterArr[0] CGPointValue].x, _xAxisView.frame.origin.y + 10);
	[_pointArr addObject:[NSValue valueWithCGPoint:point1]];
	[_pointArr addObject:[NSValue valueWithCGPoint:point2]];
	
    //绘制
    UIBezierPath* curve = [UIBezierPath bezierPath];
    [curve moveToPoint:[_pointArr.firstObject CGPointValue]];
    [curve addBezierThroughPoints:_pointArr];
	
    CAShapeLayer* shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = _trendLineColor.CGColor;
    shapeLayer.fillColor = _trendAreaColor.CGColor;
    shapeLayer.lineWidth = 1;
    shapeLayer.path = curve.CGPath;
    shapeLayer.lineCap = kCALineCapRound;
	_trendChartFrame = CGRectMake(0, 0, areaRight, self.frame.size.height - _xAxisView.frame.size.height);
	self.trendChart.layer.masksToBounds = YES;
    [self.trendChart.layer addSublayer:shapeLayer];
	self.trendChart.frame = CGRectMake(0, 0, 0, _trendChartFrame.size.height);
	[self.scrollView addSubview:self.trendChart];
}

- (CGFloat)convertYAxisToChart:(NSNumber*)number {
	CGFloat height = [number doubleValue];
	CGFloat offset = (height - _yMin) * _yAxisUnitLength;
	return _yMinCenterY - offset + 10;	//+10因为YAxisView的y坐标从10开始
}

- (void)xAxisLabelTapped:(UITapGestureRecognizer*)sender {
	NSLog(@"tap");
	[self generatePointView:sender];
	
	//滚动scrollView
	CGFloat offset = sender.view.frame.origin.x - (_screenWidth - _xAxisLabelSize.width) * 0.5;
	if (offset < 0) {
		offset = 0;
	} else if (offset > _maxScrollViewContentOffset) {
		offset = _maxScrollViewContentOffset;
	}
	[self.scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}

- (void)generatePointView:(UITapGestureRecognizer*)sender {
	NSInteger index = sender.view.tag;
	[_currentSelectPointView removeFromSuperview];
	[_currentSelectPointLabel removeFromSuperview];
	_currentSelectLabel.layer.borderWidth = 0.0f;
	_currentSelectLabel.textColor = _xAxisTextColor;
	
	_currentSelectLabel = (UILabel*)sender.view;
	_currentSelectLabel.layer.borderWidth = 1.0f;
	_currentSelectLabel.textColor = _selectColor;
	
	UIView* pointView = [[UIView alloc] initWithFrame:CGRectMake([_pointCenterArr[index] CGPointValue].x - 5,
																 [_pointCenterArr[index] CGPointValue].y - 5,
																 10, 10)];
	pointView.backgroundColor = _backgroundColor;
	pointView.layer.borderWidth = 1.0;
	pointView.layer.borderColor = _trendLineColor.CGColor;
	pointView.layer.masksToBounds = YES;
	pointView.layer.cornerRadius = pointView.frame.size.width * 0.5;
	_currentSelectPointView = pointView;
	[self.scrollView addSubview:pointView];
	
	CGSize size = [[NSString stringWithFormat:@"%.0lf", [_dataArr[index] doubleValue]] sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:_xAxisTextFontSize]}];
	size = CGSizeMake(size.width + 15, size.height);
	UILabel* pointLabel = [[UILabel alloc] init];
	pointLabel.backgroundColor = _backgroundColor;
	pointLabel.layer.borderColor = _trendLineColor.CGColor;
	pointLabel.layer.borderWidth = 1.0f;
	pointLabel.layer.masksToBounds = YES;
	pointLabel.layer.cornerRadius = size.width * 0.22;
	pointLabel.textColor = _trendLineColor;
	pointLabel.font = [UIFont systemFontOfSize:_xAxisTextFontSize];
	pointLabel.text = [NSString stringWithFormat:@"%.0lf", [_dataArr[index] doubleValue]];
	pointLabel.textAlignment = NSTextAlignmentCenter;
	pointLabel.frame = CGRectMake(pointView.center.x - size.width * 0.5,
								  pointView.frame.origin.y - size.height - 5,
								  size.width, size.height);
	_currentSelectPointLabel = pointLabel;
	[self.scrollView addSubview:pointLabel];
	
}

- (void)appear {
	[UIView animateWithDuration:2.0 animations:^{
		self.trendChart.frame = _trendChartFrame;
		self.scrollView.contentOffset = CGPointMake(_maxScrollViewContentOffset, 0);
	}];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
	if ([NSStringFromClass([touch.view class]) isEqualToString:@"UILabel"]) {
		return YES;
	}
	return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	return YES;
}

@end
