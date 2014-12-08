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

@property (nonatomic, assign) float originalTopInset;
@property (nonatomic, assign) float portraitTopInset;
@property (nonatomic, assign) float landscapeTopInset;

- (CHQPullToRefreshConfigurator *)initWithScrollView:(UIScrollView *)scrollView;

@end
