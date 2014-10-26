//
//  CHQGIFRefreshView.h
//  CHQPullToRefresh
//
//  Created by 陈鸿强 on 10/25/14.
//  Copyright (c) 2014 陈鸿强. All rights reserved.
//

#import "CHQPullToRefreshView.h"

@interface CHQGIFRefreshView : CHQPullToRefreshView

@property (nonatomic,assign) BOOL showAlphaTransition;
@property (nonatomic,assign) BOOL isVariableSize;
@property (nonatomic,assign) UIActivityIndicatorViewStyle activityIndicatorStyle;
- (id)initWithProgressImage:(UIImage *)progressImage RefreshingImage:(UIImage *)refreshingImage WithFrame:(CGRect)frame;

@end
