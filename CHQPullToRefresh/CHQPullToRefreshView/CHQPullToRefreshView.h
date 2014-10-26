//
//  CHQPullToRefreshView.h
//  MyCollectionvView
//
//  Created by stoncle on 14-10-4.
//  Copyright (c) 2014年 stoncle. All rights reserved.
//

#import <UIKit/UIKit.h>
#define CHQPullToRefreshViewHeight 60
#define CHQPullToRefreshViewTriggerHeight 65
#define CHQPullToRefreshViewHangingHeight 60
typedef NS_ENUM(NSUInteger, CHQPullToRefreshState) {
    CHQPullToRefreshStateStopped = 0,
    CHQPullToRefreshStateTriggered,
    CHQPullToRefreshStateLoading,
    CHQPullToRefreshStateAll = 10
};

@interface CHQPullToRefreshView : UIView

@property (nonatomic, copy) void (^pullToRefreshActionHandler)(void);
@property (nonatomic, readwrite) CHQPullToRefreshState state;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, readwrite) CGFloat originalTopInset;
@property (nonatomic, readwrite) CGFloat originalBottomInset;
@property (nonatomic, assign) BOOL wasTriggeredByUser;
@property (nonatomic, assign) BOOL showsPullToRefresh;
@property(nonatomic, assign) BOOL isObserving;
@property (nonatomic, strong) NSMutableArray *viewForState;

- (void)startAnimating;
- (void)stopAnimating;
- (void)resetScrollViewContentInset:(void (^)(void))actionHandler;
- (void)setScrollViewContentInsetForLoading;
- (void)setScrollViewContentInset:(UIEdgeInsets)insets Handler:(void (^)(void))actionHandler;
- (void)rotateArrow:(float)degrees hide:(BOOL)hide;
- (void)scrollViewDidScroll:(CGPoint)contentOffset;
- (void)didFinishRefresh;
- (void)addNotifications:(CHQPullToRefreshView *)view;
- (void)removeNotifications:(CHQPullToRefreshView *)view;
- (void)statusBarFrameOrOrientationChanged:(NSNotification *)notification;
@end

