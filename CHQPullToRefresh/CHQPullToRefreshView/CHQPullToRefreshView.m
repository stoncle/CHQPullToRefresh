//
//  CHQPullToRefreshView.m
//  MyCollectionvView
//
//  Created by stoncle on 14-10-4.
//  Copyright (c) 2014年 stoncle. All rights reserved.
//
#import "UIScrollView+SVPullToRefresh.h"
#import "CHQPullToRefreshView.h"
#import "CHQPullToRefreshConfigurator.h"

@interface CHQPullToRefreshView()
@property (nonatomic, assign) CGFloat PrevWidth;
@end

@implementation CHQPullToRefreshView

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.state = CHQPullToRefreshStateStopped;
        self.wasTriggeredByUser = YES;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (self.superview && newSuperview == nil) {
        UIScrollView *scrollView = self.scrollView;
            if (self.isObserving) {
                [scrollView removeObserver:self forKeyPath:@"contentOffset"];
                [scrollView removeObserver:self forKeyPath:@"frame"];
                self.isObserving = NO;
            }
    }
}

- (void)configureView
{
    
}

- (void)setConstraints
{
    
}

#pragma mark private methods
- (void)addNotifications:(CHQPullToRefreshView *)view
{
    if([view respondsToSelector:@selector(statusBarFrameOrOrientationChanged:)])
    {
        [[NSNotificationCenter defaultCenter]
         addObserver:view
         selector:@selector(statusBarFrameOrOrientationChanged:)
         name:UIApplicationDidChangeStatusBarOrientationNotification
         object:nil];
    }
}
- (void)removeNotifications:(CHQPullToRefreshView *)view
{
    [[NSNotificationCenter defaultCenter] removeObserver:view name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}
#pragma mark notificatios
- (void)statusBarFrameOrOrientationChanged:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
        {
            if(cNotEqualFloats( self.landscapeTopInset , 0.0 , cDefaultFloatComparisonEpsilon))
                self.originalTopInset = self.landscapeTopInset;
        }
        else
        {
            if(cNotEqualFloats( self.portraitTopInset , 0.0 , cDefaultFloatComparisonEpsilon))
                self.originalTopInset = self.portraitTopInset;
        }
    });
    [self doSomethingWhenChangingOrientation];
}

- (void)doSomethingWhenChangingOrientation
{
    
}


#pragma mark - Scroll View

- (void)resetScrollViewContentInset:(void (^)(void))actionHandler{
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.top = self.originalTopInset;
    [self setScrollViewContentInset:currentInsets Handler:actionHandler];
}

- (void)setScrollViewContentInsetForLoading {
    CGFloat offset = MAX(self.scrollView.contentOffset.y * -1, 0);
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.top = MIN(offset, self.originalTopInset + self.pullToRefreshViewHangingHeight);
    [self setScrollViewContentInset:currentInsets
                            Handler:nil];
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset Handler:(void (^)(void))actionHandler{
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.scrollView.contentInset = contentInset;
                     }
                     completion:^(BOOL finished){
                         if(actionHandler)
                         {
                             actionHandler();
                         }
                     }];
}

- (void)doSomethingWhenLayoutSubviews
{
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if(self.PrevWidth != PullToRefreshViewWidth && self.PrevWidth != 0)
    {
        [self configureView];
    }
    self.PrevWidth = PullToRefreshViewWidth;
    [self doSomethingWhenLayoutSubviews];
}

#pragma mark - Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"])
    {
        if(self.superview != self.scrollView && self.shouldScrollWithScrollView)
        {
            [self changeFrameWithContentOffsetNew:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue] Old:[[change valueForKey:NSKeyValueChangeOldKey]CGPointValue]];
        }
        if([[change valueForKey:NSKeyValueChangeNewKey] CGPointValue].y > 0)
        {
            return;
        }
        

        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    }
    else if([keyPath isEqualToString:@"frame"])
    {
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}

- (void)doSomethingWhenScrolling:(CGPoint)contentOffset
{
    
}

- (void)changeFrameWithContentOffsetNew:(CGPoint)contentOffsetNew Old:(CGPoint)contentOffsetOld
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - (contentOffsetNew.y-contentOffsetOld.y), self.frame.size.width, self.frame.size.height);
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset {
    [self doSomethingWhenScrolling:contentOffset];
    if(self.state != CHQPullToRefreshStateLoading) {
        CGFloat scrollOffsetThreshold = 0;
        scrollOffsetThreshold = -self.pullToRefreshViewTriggerHeight - self.originalTopInset;
        if(!self.scrollView.isDragging && self.state == CHQPullToRefreshStateTriggered)
            self.state = CHQPullToRefreshStateLoading;
        else if(contentOffset.y < scrollOffsetThreshold && self.scrollView.isDragging && self.state == CHQPullToRefreshStateStopped)
            self.state = CHQPullToRefreshStateTriggered;
        else if(contentOffset.y >= scrollOffsetThreshold && self.state != CHQPullToRefreshStateStopped)
            self.state = CHQPullToRefreshStateStopped;
    } else {
        CGFloat offset;
        UIEdgeInsets contentInset;
        offset = MAX(self.scrollView.contentOffset.y * -1, 0.0f);
        offset = MIN(offset, self.originalTopInset + self.pullToRefreshViewHangingHeight);
        contentInset = self.scrollView.contentInset;
        self.scrollView.contentInset = UIEdgeInsetsMake(offset, contentInset.left, contentInset.bottom, contentInset.right);
    }
}




#pragma mark -

- (void)triggerRefresh {
    [self.scrollView triggerPullToRefresh];
}

- (void)doSomethingWhenStartingAnimating
{
    
}

- (void)startAnimating{
    NSLog(@"refreshing...");
    [self doSomethingWhenStartingAnimating];
    
    if(fequalzero(self.scrollView.contentOffset.y)) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, -self.pullToRefreshViewHangingHeight) animated:YES];
        self.wasTriggeredByUser = NO;
    }
    else
        self.wasTriggeredByUser = YES;
    if(self.pullToRefreshActionHandler)
        self.pullToRefreshActionHandler();
    
}

- (void)doSomethingWhenStopingAnimating
{
    
}

- (void)stopAnimating {
    NSLog(@"refresh finished.");
    self.state = CHQPullToRefreshStateStopped;
    [self doSomethingWhenStopingAnimating];
    
            if(!self.wasTriggeredByUser)
                [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, -self.originalTopInset) animated:YES];
}

- (void)setState:(CHQPullToRefreshState)newState {
    if(_state == newState)
        return;
    CHQPullToRefreshState prevState = _state;
    _state = newState;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [self doSomethingWhenStateChanges];
    
    switch (newState) {
        case CHQPullToRefreshStateAll:
        case CHQPullToRefreshStateStopped:
            if(prevState == CHQPullToRefreshStateLoading)
                [self resetScrollViewContentInset:nil];
            break;
            
        case CHQPullToRefreshStateTriggered:
            NSLog(@"triggered.");
            break;
            
        case CHQPullToRefreshStateLoading:
            [self setScrollViewContentInsetForLoading];
            [self startAnimating];
            break;
    }
}

- (void)doSomethingWhenStateChanges
{
    
}

@end
