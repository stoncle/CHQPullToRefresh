//
//  CHQInfiniteScrollingView.h
//  CHQPullToRefresh
//
//  Created by 陈鸿强 on 10/28/14.
//  Copyright (c) 2014 陈鸿强. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CHQInfiniteScrollingViewHeight 60
#define InfiniteScrollingViewWidth self.bounds.size.width
typedef NS_ENUM(NSUInteger, CHQInfiniteScrollingState){
    CHQInfiniteScrollingStateStopped = 0,
    CHQInfiniteScrollingStateTriggered,
    CHQInfiniteScrollingStateLoading,
    CHQInfiniteScrollingStateAll = 10
};

@interface CHQInfiniteScrollingView : UIView


@property (nonatomic, copy) void (^infiniteScrollingHandler)(void);
@property (nonatomic, readwrite) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
@property (nonatomic, readwrite) BOOL enabled;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, readwrite) CHQInfiniteScrollingState state;
@property (nonatomic, strong) NSMutableArray *viewForState;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, readwrite) CGFloat originalBottomInset;
@property (nonatomic, assign) BOOL wasTriggeredByUser;
@property (nonatomic, assign) BOOL isObserving;

- (void)configureView;
- (void)resetScrollViewContentInset;
- (void)setScrollViewContentInsetForInfiniteScrolling;
- (void)setScrollViewContentInset:(UIEdgeInsets)insets;

- (void)setCustomView:(UIView *)view forState:(CHQInfiniteScrollingState)state;

- (void)doSomethingWhenScrolling:(CGPoint)contentOffset;
- (void)doSomethingWhenStartingAnimating;
- (void)doSomethingWhenStopingAnimating;
- (void)startAnimating;
- (void)stopAnimating;

@end