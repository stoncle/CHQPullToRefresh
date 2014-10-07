CHQPullToRefresh
================
###NOT COMPLETE YET
base on [SVPullToRefresh](https://github.com/samvermette/SVPullToRefresh) by [@samvermette](https://github.com/samvermette)  

Allow you to add a "pull to refresh view AND infinite scrolling" to any ScrollView(like TableView and CollectionView), also provide an easy way to change the refresh theme.  
Being a catagory of UIScrollView, you may find the following methods in it:  
```Objective-C
- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler;
- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler WithCurrentTheme:(CHQRefreshTheme)theme;
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
###Change refresh theme in runtime
    --still on working--
###Trigger Refreshing programmatically
    [tableView triggerPullToRefresh];
    [tableView triggerInfiniteScrolling];
###Hide Refresh view
    tableView.showsPullToRefresh = NO;
    tableView.showsInfiniteScrolling = NO;
##Supporting Theme so far
* CHQRefreshThemeArrow(Default)
  normal refresh view with an arrow pointing directions.
* CHQRefreshThemeSpiral
  rectangle spiral from around gathering at middle.
* New Theme coming soon...

###You can design your own theme
  by subclassing the CHQPullToRefresh
  ...

