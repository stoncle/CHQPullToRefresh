CHQPullToRefresh
================
base on [SVPullToRefresh](https://github.com/samvermette/SVPullToRefresh) by [@samvermette](https://github.com/samvermette)  

Allow you to add a "pull to refresh view AND infinite scrolling" to any ScrollView(like TableView and CollectionView), also provide an easy way to change the refresh theme.You are able to display a gif picture when triggering refreshing(both PullToRefresh and InfiniteScrolling).You can also customize it.
Being a catagory of UIScrollView, you may find the following methods in it:  
```Objective-C
- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler;
- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler WithConfigurator:(CHQPullToRefreshConfigurator *)configurator;
- (void)changeCurrentRefreshThemeToTheme:(CHQRefreshTheme)theme;
- (void)changeCurrentInfiniteScrollingThemeToTheme:(CHQInfiniteScrollingTheme)theme;
- (void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler;
- (void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler WithCurrentTheme:(CHQInfiniteScrollingTheme)theme;
- (void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler WithLoadingImageName:(NSString *)loadingImageName;
- (void)triggerPullToRefresh;
- (void)triggerInfiniteScrolling;
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
####Adding Pull to Refresh with a configurator
    configurator.theme = CHQRefreshThemeGif;
    configurator.treatAsSubView = NO;
    configurator.progressImageName = @"run@2x.gif";
    configurator.refreshingImageName = @"run@2x.gif";
    [collectionView addPullToRefreshWithActionHandler:^{
        // prepend data to dataSource, insert cells at top of table view
        // call [collectionView.pullToRefreshView stopAnimating] when done
    } WithConfigurator:configurator];
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
    
#Configurator
a configurator is offered as a customise class, you can create your own configurator to design your refresh view, including portrait and landscape top content inset of your scrollview and etc.
use [[CHQPullToRefreshConfigurator alloc]initWithScrollView:] to create a configurator, and set the properties freely for yourself!If you don't set them, they will remain in default way, like 60 for refreshview height and 0 for originalcontentinset.You can custom your configurator in the following way:
####portraitTopInset
    the content inset of the scrollview when in portrait mode, set this when the default inset of the pulltorefreshview doesn't meet your demand.
####landscapeTopInset
    the content inset of the scrollview when in landscape mode.
####treatAsSubView
    if set to Yes, the pulltorefresh view would be added to your scrollview as a subview, if set to NO, it would be added as a sibling view. Default is yes.(to tell the differences, for example, as a subview, the refreshview would cover the content of the scrollview, when set to sibling view, it could be covered by the scrollview.)
####shouldScrollWithScrollView
    When treatAsSubView is No, if this property is set to Yes, the pulltorefresh view would scroll with the scrollview.
####customiseFrame
    bool value, set it to yes if you want to cusromise the frame of the pull to refresh view.
####portraitFrame
    the frame you want to add your pulltorefreshview to when in portrait mode.With setting this, you may add the refresh view to anywhere of your scrollview,default is on the top of the scrollview. this property won't take effect if customiseFrame is set to NO
####landscapeFrame
    the frame you want to add your pulltorefreshview to when in landscape mode.this property won't take effect if customiseFrame is set to NO
####pullToRefreshViewHeight
    the height of the refresh view.
####pullToRefreshViewTriggerHeight
    the triggering height of the refresh view.
####pullToRefreshViewHangingHeight
    the hanging height of the refresh view.
####backgroundColor
    the background color of the refresh view.
####theme
    the theme of the refresh theme.Supporting themes for now are as follows.
####progressImageName
    display image when dragging the scrollview, when theme being set to CHQRefreshThemeGif, you can set this to the name of your favorite gif image.
####refreshingImageName
    display image when refreshing, hen theme being set to CHQRefreshThemeGif, you can set this to the name of your favorite gif image.
####animateDuration
    the duration when pulltorefresh animate your scrollview.
feel free to customize your configurator, just don't forget to attach it to the refresh view.
```Objective-C
    configurator.frame = CGRectMake(0, 200, 768, 60);
    configurator.theme = CHQRefreshThemeDefault;
    configurator.progressImageName = @"run@2x.gif";
    configurator.refreshingImageName = @"run@2x.gif";
    [_collectionView addPullToRefreshWithActionHandler:^{
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        if(a.count > 20)
        {
            for(int i=0; i<20; i++)
            {
                [a removeObjectAtIndex:i];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [arr addObject:indexPath];
            }
        }
        if(arr.count > 0)
        {
            [d deleteItemsAtIndexPaths:arr];
        }
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [d.pullToRefreshView stopAnimating];
        });
    } WithConfigurator:configurator];
```
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
  by subclassing the CHQPullToRefreshView
  
  to create your own refresh view, you need to subclassing the CHQPullToRefreshView, the parent class itself implement the refreshing logic already, so you just need to focus on configuring your personalized view.
  
  the parent CHQPullToRefreshView provide the following methods for you to implement:
```Objective-C
- (void)configureView;
- (void)doSomethingWhenScrolling:(CGPoint)contentOffset;
- (void)doSomethingWhenStartingAnimating;
- (void)doSomethingWhenStopingAnimating;
- (void)doSomethingWhenChangingOrientation;
- (void)doSomethingWhenStateChanges;
- (void)doSomethingWhenLayoutSubviews;
```
    # configureView
        this method would be called when first time the view is generated, and each time the scroll view change
        its orientation. You can implement this method to configure your view and recaculate it when orientation changes.
    # doSomethingWhenScrolling:(*)
        this method would be called when the refresh view is about to appear in your sights, implement it to 
        define the behavior of your refresh view when it scrolls with your scroll view.
    # doSomethingWhenStartingAnimating(*)
        this method would be called right before the refresh view animating, implement it to define the behavior 
        of your refresh view when it is in refreshing process.
    # doSomethingWhenStopingAnimating(*)
        this method would be called right after the refresh view finishing its animating, implement it to define
        the behavior or your refresh view when it is finishing refreshing.
    # doSomethingWhenChangingOrientation
        this method would be called when the orientation of the scrollview changes, implement it if you need to
        offer behavior on orientation changes.
    # doSomethingWhenStateChanges(*)
        this method would be called when the state of the state of the refresh view changes, change your label text
        or colors in this method.
    # doSomethingWhenLayoutSubviews
        this method would be called when refresh view called layoutSubviews.
