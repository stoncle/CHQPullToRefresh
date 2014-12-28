//
//  CHQPullToRefreshConfigurator.h
//  CHQPullToRefresh
//
//  Created by 陈鸿强 on 12/8/14.
//  Copyright (c) 2014 陈鸿强. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CHQPullToRefreshConfigurator : NSObject

@property (nonatomic) bool treatAsSubView;
@property (nonatomic) bool shouldScrollWithScrollView;
@property (nonatomic, assign) float originalTopInset;
@property (nonatomic, assign) float portraitTopInset;
@property (nonatomic, assign) float landscapeTopInset;
@property (nonatomic) CGRect portraitFrame;
@property (nonatomic) CGRect landscapeFrame;
@property (nonatomic, assign) float pullToRefreshViewHeight;
@property (nonatomic, assign) float pullToRefreshViewTriggerHeight;
@property (nonatomic, assign) float pullToRefreshViewHangingHeight;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, assign) int theme;
@property (nonatomic, strong) NSString *progressImageName;
@property (nonatomic, strong) NSString *refreshingImageName;
@property (nonatomic, assign) float animateDuration;

- (CHQPullToRefreshConfigurator *)initWithScrollView:(UIScrollView *)scrollView;

@end
