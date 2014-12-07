CHQPullToRefresh
================
base on [SVPullToRefresh](https://github.com/samvermette/SVPullToRefresh) by [@samvermette](https://github.com/samvermette)  

Allow you to add a "pull to refresh view AND infinite scrolling" to any ScrollView(like TableView and CollectionView), also provide an easy way to change the refresh theme.You are able to display a gif picture when triggering refreshing(both PullToRefresh and InfiniteScrolling).
Being a catagory of UIScrollView, you may find the following methods in it:  
```Objective-C
- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler;
- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler WithCurrentTheme:(CHQRefreshTheme)theme;
- (void)changeCurrentRefreshThemeToTheme:(CHQRefreshTheme)theme;
- (void)changeCurrentInfiniteScrollingThemeToTheme:(CHQInfiniteScrollingTheme)theme;
- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler WithProgressImageName:(NSString *)progressImageName RefreshingImageName:(NSString *)refreshingImageName;
- (void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler;
- (void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler WithCurrentTheme:(CHQInfiniteScrollingTheme)theme;
- (void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler WithLoadingImageName:(NSString *)loadingImageName;
```
##Installation
* Drag the CHQPullToRefreshView folder into your project.
* Add the QuartzCore framework to your project.
* Import UIScrollView+SVPullToRefresh.h and/or UIScrollView+SVInfiniteScrolling.h

##Usage
###Adding Pull to Refresh
    [collectionView addPullToRefreshWithActionHandler:^{
        // prepend data to dataSource, insert cells at top of table view
        // call [collectionView.pullToRefreshView stopAnimating] when done
    }];
###Adding Pull to Refresh with a Theme
    [collectionView addPullToRefreshWithActionHandler:^{
        // prepend data to dataSource, insert cells at top of table view
        // call [collectionView.pullToRefreshView stopAnimating] when done
    } WithCurrentTheme:CHQRefreshThemeDefault];
###Adding Pull to Refresh with gif picture
    [_collectionView addPullToRefreshWithActionHandler:^{
        // prepend data to dataSource, insert cells at top of table view
        // call [collectionView.pullToRefreshView stopAnimating] when done
        });
    } WithProgressImageName:@"cat.gif" RefreshingImageName:@"run@2x.gif"];
###Adding Infinite Scrolling
    [tableView addInfiniteScrollingWithActionHandler:^{
    // append data to data source, insert new cells at the end of table view
    // call [tableView.infiniteScrollingView stopAnimating] when done
    }];
###Adding infinite scrolling with a Theme
    [collectionView addInfiniteScrollingWithActionHandler:^{
        // prepend data to dataSource, insert cells at top of table view
        // call [collectionView.infiniteScrollingView stopAnimating] when done
    } WithCurrentTheme:CHQInfiniteScrollingThemeDefault];
###Adding Infinite Scrolling with a gif picture
    [_collectionView addInfiniteScrollingWithActionHandler:^{
        // append data to data source, insert new cells at the end of table view
        // call [tableView.infiniteScrollingView stopAnimating] when done
        });
    } WithLoadingImageName:@"run@2x.gif"];
###Changing refresh theme in runtime
    call [tableView changeCurrentRefreshThemeToTheme:] whenever you want to change the theme, remember that you have to add a pull to refresh view before this.
###Changing infinite scrolling theme in runtime
    call [tableView changeCurrentInfiniteScrollingThemeToTheme:] whenever you want to change the theme, remember that you have to add a pull to infinite scrolling view before this.
###Trigger Refreshing programmatically
    [tableView triggerPullToRefresh];
    [tableView triggerInfiniteScrolling];
###Hide Refresh view
    tableView.showsPullToRefresh = NO;
    tableView.showsInfiniteScrolling = NO;
##Supporting Refresh Theme so far
* CHQRefreshThemeArrow(Default)
  * normal refresh view with an arrow pointing directions.  
* CHQRefreshThemeSpiral
  * rectangle spiral from around gathering at middle. 
* CHQRefreshThemeEatBeans
  * little bite eating beans.
* CHQRefreshThemePandulum
  * pandulum tick tock...
* CHQRefreshThemeEllipsis
  * wavy ellipsis.
* CHQRefreshThemeBalloon
  * spiral colorful balloons.
* CHQRefreshThemePinterest
  * pinterest refreshing style.
* New Theme coming soon...
  * you can also make your own theme and if you would like to make a pull request to me, I'd appreciate it ! 
##Supporting Infinite scrolling Theme so far
* CHQInfiniteScrollingThemeEllipsis
  * wavy ellipsis.
* New Theme coming soon...
  * you can also make your own theme and if you would like to make a pull request to me, I'd appreciate it !

####arrow theme
![](https://github.com/stoncle/CHQPullToRefresh/blob/master/CHQPullToRefresh/testImage/arrow.png)
####spiral theme
![](https://github.com/stoncle/CHQPullToRefresh/blob/master/CHQPullToRefresh/testImage/spiral.png)
####eatBeans theme
![](https://github.com/stoncle/CHQPullToRefresh/blob/master/CHQPullToRefresh/testImage/eatBeans.png)
####gif theme
![](https://github.com/stoncle/CHQPullToRefresh/blob/master/CHQPullToRefresh/testImage/gif.png)
####pandulum theme
![](https://github.com/stoncle/CHQPullToRefresh/blob/master/CHQPullToRefresh/testImage/pandulum.png)
####ellipsis theme
![](https://github.com/stoncle/CHQPullToRefresh/blob/master/CHQPullToRefresh/testImage/ellipsis.png)
####balloon theme
![](https://github.com/stoncle/CHQPullToRefresh/blob/master/CHQPullToRefresh/testImage/balloon.png)
####pinterest theme
![](https://github.com/stoncle/CHQPullToRefresh/blob/master/CHQPullToRefresh/testImage/pinterest.png)
####gif infinite scrolling
![](https://github.com/stoncle/CHQPullToRefresh/blob/master/CHQPullToRefresh/testImage/gifinfinite.png)
####ellipsis infinite scrolling
![](https://github.com/stoncle/CHQPullToRefresh/blob/master/CHQPullToRefresh/testImage/ellipsisScrolling.png)

###You can design your own theme
  by subclassing the CHQPullToRefresh  
  I will place the detail for how to make your own theme.

