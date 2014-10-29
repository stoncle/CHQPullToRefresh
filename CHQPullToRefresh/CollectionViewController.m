//
//  STCollectionViewController.m
//  MyCollectionvView
//
//  Created by stoncle on 14-9-29.
//  Copyright (c) 2014年 stoncle. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionViewCell.h"
#import "CollectionViewHeader.h"
#define kCellIdentifier @"collectionViewCell"
#define kHeaderIdentifier @"collectionHeader"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "ScaleAnimation.h"
#import "DetailViewController.h"


@interface CollectionViewController () <CollectionViewClickCellDelegate>
{
    UICollectionView *_collectionView;
    NSMutableArray *_displayArray;
    ScaleAnimation *_presentAnimation;
    NSIndexPath *_lastClickCell;
}
@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation CollectionViewController

- (void)loadView
{
    self.view = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc]init];
//    THSpringyFlowLayout *springFlowLayout = [[THSpringyFlowLayout alloc]init];
//    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:springFlowLayout];
//    ASHSpringyCollectionViewFlowLayout *springFlowLayout = [[ASHSpringyCollectionViewFlowLayout alloc]init];
//    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:springFlowLayout];
    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:collectionLayout];
    
    [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
    [_collectionView registerClass:[CollectionViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderIdentifier];
    
}

- (void)viewDidLoad
{
//    self.automaticallyAdjustsScrollViewInsets = NO;
    _presentAnimation = [[ScaleAnimation alloc]initWithNavigationController:self.navigationController];
    self.navigationController.delegate = self;
    _presentAnimation.delegate = self;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    _data = [[NSMutableArray alloc]initWithCapacity:10];
    _displayArray = [[NSMutableArray alloc]init];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_collectionView];
    __block UICollectionView *d = _collectionView;
    __block NSMutableArray *a = _data;
//    [_collectionView addPullToRefreshWithActionHandler:^{
//        NSMutableArray *arr = [[NSMutableArray alloc]init];
//        if(a.count > 20)
//        {
//            for(int i=0; i<20; i++)
//            {
//                [a removeObjectAtIndex:i];
//                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//                [arr addObject:indexPath];
//            }
//        }
//        if(arr.count > 0)
//        {
//            [d deleteItemsAtIndexPaths:arr];
//        }
//        
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC));
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            [d.pullToRefreshView stopAnimating];
//        });
//    } WithCurrentTheme:CHQRefreshThemeSpiral];
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
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC));
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [d.pullToRefreshView stopAnimating];
        });
    } WithProgressImageName:@"cat.gif" RefreshingImageName:@"run@2x.gif"];
//    [_collectionView addInfiniteScrollingWithActionHandler:^{
//        // append data to data source, insert new cells at the end of table view
//        // call [tableView.infiniteScrollingView stopAnimating] when done
//        
////        NSLog(@"good");
//        int j = [a count];
//        NSMutableArray *arr = [[NSMutableArray alloc]init];
//        
//        for(int i=0; i<20; i++)
//        {
//            [a addObject:@"hhh"];
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j+i inSection:0];
//            [arr addObject:indexPath];
//        }
//        
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC));
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            [d insertItemsAtIndexPaths:arr];
//            srand((unsigned)time(0));
//            int i = rand() % 3;
//            [d changeCurrentRefreshThemeToTheme:i];
//            [d.infiniteScrollingView stopAnimating];
//        });
//    
//        
//    }];
    [self addConstraints];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addConstraints
{
    [_collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_collectionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_collectionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    CollectionViewHeader *header = nil;
    if([kind isEqual:UICollectionElementKindSectionHeader]){
        header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHeaderIdentifier forIndexPath:indexPath];
        header.label.text = @"123";
        header.label.textColor = [UIColor blackColor];
    }
    return header;
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _data.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor grayColor];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    static CGFloat duration = .3;
    static NSUInteger xOffset = 0;
    static NSUInteger yOffset = 300;
    if(indexPath.row >= _displayArray.count)
    {
        [_displayArray addObject:[NSNumber numberWithBool:NO]];
    }//    if(collectionView.visibleCells.count <12 && ![collectionView.visibleCells containsObject:cell])
//    NSLog(@"%@", [_displayArray objectAtIndex:indexPath.row]);
//    if(collectionView.infiniteScrollingView.state == SVInfiniteScrollingStateLoading && ![collectionView.visibleCells containsObject:cell] && [_displayArray objectAtIndex:indexPath.row] == NO)
    if(collectionView.infiniteScrollingView.state == SVInfiniteScrollingStateLoading)
    if(![collectionView.visibleCells containsObject:cell])
    if([_displayArray objectAtIndex:indexPath.row] == [NSNumber numberWithBool:NO])
    {
        cell.frame = CGRectMake(cell.frame.origin.x - xOffset, cell.frame.origin.y+yOffset, cell.frame.size.width, cell.frame.size.height);
        [UIView animateWithDuration:duration
                         animations:^{
                             cell.frame = CGRectMake(cell.frame.origin.x + xOffset, cell.frame.origin.y - yOffset, cell.frame.size.width, cell.frame.size.height);
                         } completion:^(BOOL finished) {
                         }];
    }
    [_displayArray setObject:[NSNumber numberWithBool:YES] atIndexedSubscript:indexPath.row];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _lastClickCell = indexPath;
    DetailViewController *dvc = [[DetailViewController alloc]init];
    dvc.transitioningDelegate = self;
    dvc.title = @"Apple";
    _presentAnimation.viewForInteraction = dvc.view;
    [self.navigationController pushViewController:dvc animated:YES];
}


#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect r = [UIScreen mainScreen].applicationFrame;
    NSLog(@"%f, %f", r.size.width, r.size.height);
    if(r.size.width > r.size.height)
        return CGSizeMake((r.size.height+20)/3.09, (r.size.height+20)/3*1.15);
    else
        return CGSizeMake(r.size.width/3.09, r.size.width/3*1.15);
//    NSLog(@"%f", r.size.width/3.05);
	
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGRect r = [UIScreen mainScreen].applicationFrame;
    if(r.size.width > r.size.height)
        return CGSizeMake(r.size.width, (r.size.width-20)/4);
    else
        return CGSizeMake(r.size.width, r.size.height/4);
}

#pragma mark UIViewControllerTransitioningDelegate
-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    if ([fromVC isKindOfClass:DetailViewController.class] && ![toVC isEqual:self]) return nil;
    
    BaseAnimation *animationController;
    animationController = _presentAnimation;
    switch (operation) {
        case UINavigationControllerOperationPush:
            animationController.type = AnimationTypePresent;
            return  animationController;
        case UINavigationControllerOperationPop:
            animationController.type = AnimationTypeDismiss;
            return animationController;
        default: return nil;
    }
    
}

-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if ([animationController isKindOfClass:[ScaleAnimation class]]) {
        ScaleAnimation *controller = (ScaleAnimation *)animationController;
        if (controller.isInteractive) return controller;
        else return nil;
    } else return nil;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return _presentAnimation;
}

#pragma mark CollectionViewClickCellDelegate
- (CGPoint) collctionViewClickOnCell
{
    UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:_lastClickCell];
    return CGPointMake(cell.frame.origin.x + cell.frame.size.width/2, cell.frame.origin.y + cell.frame.size.height/2 - _collectionView.contentOffset.y);
}


@end
