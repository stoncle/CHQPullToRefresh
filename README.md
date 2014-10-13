CHQPullToRefresh
================
base on [SVPullToRefresh](https://github.com/samvermette/SVPullToRefresh) by [@samvermette](https://github.com/samvermette)  

Allow you to add a "pull to refresh view AND infinite scrolling" to any ScrollView(like TableView and CollectionView), also provide an easy way to change the refresh theme.  
Being a catagory of UIScrollView, you may find the following methods in it:  
```Objective-C
- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler;
- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler WithCurrentTheme:(CHQRefreshTheme)theme;
- (void)changeCurrentRefreshThemeToTheme:(CHQRefreshTheme)theme;
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
###Adding Infinite Scrolling
    [tableView addInfiniteScrollingWithActionHandler:^{
    // append data to data source, insert new cells at the end of table view
    // call [tableView.infiniteScrollingView stopAnimating] when done
    }];
###Changing refresh theme in runtime
    call [tableView changeCurrentRefreshThemeToTheme:] whenever you want to change the theme, remember that you have to add a pull to refresh view before this.
###Trigger Refreshing programmatically
    [tableView triggerPullToRefresh];
    [tableView triggerInfiniteScrolling];
###Hide Refresh view
    tableView.showsPullToRefresh = NO;
    tableView.showsInfiniteScrolling = NO;
##Supporting Theme so far
* CHQRefreshThemeArrow(Default)
  * normal refresh view with an arrow pointing directions.  
* CHQRefreshThemeSpiral
  * rectangle spiral from around gathering at middle. 
* CHQRefreshThemeEatBeans
  * little bite eating beans.
* New Theme coming soon...
  * you can also make your own theme and if you would like to make a pull request to me, I'd appreciate it !  

####arrow theme
![](https://github.com/stoncle/CHQPullToRefresh/blob/master/CHQPullToRefresh/testImage/arrow.png)
####spiral theme
![](https://github.com/stoncle/CHQPullToRefresh/blob/master/CHQPullToRefresh/testImage/spiral.png)
####eatBeans theme
![](https://github.com/stoncle/CHQPullToRefresh/blob/master/CHQPullToRefresh/testImage/eatBeans.png)

###You can design your own theme
  by subclassing the CHQPullToRefresh  
  I will place the detail for how to make your own theme.

