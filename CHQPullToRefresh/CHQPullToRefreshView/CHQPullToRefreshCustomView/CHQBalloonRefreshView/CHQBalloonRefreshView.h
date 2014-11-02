//
//  CHQBalloonRefreshView.h
//  CHQPullToRefresh
//
//  Created by 陈鸿强 on 11/2/14.
//  Copyright (c) 2014 陈鸿强. All rights reserved.
//

#import "CHQPullToRefreshView.h"

typedef enum {
    BalloonPullToRefreshWaitAnimationSpin = 0,
    BalloonPullToRefreshWaitAnimationFade
} BalloonPullToRefreshWaitAnimation;

@interface CHQBalloonRefreshView : CHQPullToRefreshView {
    BOOL isRefreshing;
    NSTimer *animationTimer;
    float lastOffset;
    int animationStep;
}
@property (nonatomic, assign) BalloonPullToRefreshWaitAnimation waitingAnimation;
@property (nonatomic) int particlesCount;


@end