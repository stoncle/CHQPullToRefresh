//
//  CHQArrowRefreshView.h
//  CHQPullToRefresh
//
//  Created by 陈鸿强 on 10/6/14.
//  Copyright (c) 2014 陈鸿强. All rights reserved.
//

#import "CHQPullToRefreshView.h"

@interface CHQArrowRefreshView : CHQPullToRefreshView

@property (nonatomic, strong) UIColor *arrowColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *subtitleLabel;
@property (nonatomic, strong, readwrite) UIColor *activityIndicatorViewColor NS_AVAILABLE_IOS(5_0);
@property (nonatomic, readwrite) UIActivityIndicatorViewStyle activityIndicatorViewStyle;


- (void)setTitle:(NSString *)title forState:(CHQPullToRefreshState)state;
- (void)setSubtitle:(NSString *)subtitle forState:(CHQPullToRefreshState)state;
- (void)setCustomView:(UIView *)view forState:(CHQPullToRefreshState)state;

// deprecated; use setSubtitle:forState: instead
@property (nonatomic, strong, readonly) UILabel *dateLabel DEPRECATED_ATTRIBUTE;
@property (nonatomic, strong) NSDate *lastUpdatedDate DEPRECATED_ATTRIBUTE;
@property (nonatomic, strong) NSDateFormatter *dateFormatter DEPRECATED_ATTRIBUTE;

@end

