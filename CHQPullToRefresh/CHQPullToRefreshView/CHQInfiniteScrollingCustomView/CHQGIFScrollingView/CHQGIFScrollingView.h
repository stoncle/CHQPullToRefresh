//
//  CHQGIFScrollingView.h
//  CHQPullToRefresh
//
//  Created by 陈鸿强 on 10/29/14.
//  Copyright (c) 2014 陈鸿强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHQInfiniteScrollingView.h"

@interface CHQGIFScrollingView : CHQInfiniteScrollingView
@property (nonatomic,assign) BOOL showAlphaTransition;
@property (nonatomic,assign) BOOL isVariableSize;
@property (nonatomic,assign) UIActivityIndicatorViewStyle activityIndicatorStyle;
- (id)initWithRefreshingImage:(UIImage *)refreshingImage WithFrame:(CGRect)frame;
@end
