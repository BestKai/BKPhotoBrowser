//
//  BKPhotoBrowser.m
//  BKPhotoBrowser
//
//  Created by BestKai on 16/5/30.
//  Copyright © 2016年 BestKai. All rights reserved.
//

#import "BKPhotoBrowser.h"
#import "BKPhotoItemView.h"
#import "SDWebImageManager.h"

#define kPadding 20


@interface BKPhotoBrowser()<UIScrollViewDelegate,UIGestureRecognizerDelegate,BKPhotoItemViewDelegate>

@property (nonatomic, weak) UIView *fromView;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *cells;
@property (nonatomic, strong) UIPageControl *pager;
@property (nonatomic, assign) CGFloat pagerCurrentPage;

@property (nonatomic, assign) NSInteger fromItemIndex;
@property (nonatomic, assign) BOOL isPresented;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) CGPoint panGestureBeginPoint;


@end


@implementation BKPhotoBrowser

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(-kPadding / 2, 0, self.view.frame.size.width + kPadding, self.view.frame.size.height)];
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.alwaysBounceHorizontal = self.cells.count>1;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
    }
    return _scrollView;
}

- (UIPageControl *)pager
{
    if (!_pager) {
        _pager = [[UIPageControl alloc] init];
        _pager.hidesForSinglePage = YES;
        _pager.userInteractionEnabled = NO;
        _pager.frame = CGRectMake(0, 0, self.view.frame.size.width-36, 10);
        _pager.center =  CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 18);
        _pager.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }
    return _pager;
}


- (NSMutableArray *)cells
{
    if (!_cells) {
        _cells = [[NSMutableArray alloc] init];
    }
    return _cells;
}


- (instancetype)initWithPhotoItems:(NSArray *)PhotoItems
{
    self = [super init];
    
    if (self) {
        _groupItems = PhotoItems;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    _contentView = UIView.new;
    _contentView.frame = self.view.bounds;
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _contentView.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:_contentView];
    [_contentView addSubview:self.scrollView];
    [_contentView addSubview:self.pager];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.groupItems.count, self.scrollView.frame.size.height);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.delegate = self;
    doubleTap.numberOfTapsRequired = 2;
    [tap requireGestureRecognizerToFail: doubleTap];
    [self.view addGestureRecognizer:doubleTap];
}


- (void)showFromImageView:(UIView *)fromView andCurrentIndex:(NSInteger)currentIndex completion:(void (^)(void))completion
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.view];
    [window.rootViewController addChildViewController:self];
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];

    
    _fromView = fromView;
    
    _fromItemIndex = currentIndex;
    
    BOOL fromViewHidden = fromView.hidden;
    fromView.hidden = YES;
    fromView.hidden = fromViewHidden;
    
    
    self.pager.alpha = 0;
    self.pager.numberOfPages = self.groupItems.count;
    self.pager.currentPage = currentIndex;
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * self.groupItems.count, _scrollView.frame.size.height);
    [_scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width * _pager.currentPage, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:NO];
    [self scrollViewDidScroll:_scrollView];
    
    [UIView setAnimationsEnabled:YES];
    
    
    BKPhotoItemView *cell = [self cellForPage:self.currentPage];
    BKPhotoItem *item = _groupItems[self.currentPage];
    cell.fromView = fromView;
    
    [cell zoomSelfWithItem:item];
    
    
    _scrollView.userInteractionEnabled = NO;

    if (item.thumbClippedToTop) {
        
        [UIView animateWithDuration:SlowAnimateTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _pager.alpha = 1;
        }completion:^(BOOL finished) {
            if (completion) completion();
        }];
        
    } else {
        
        [UIView animateWithDuration:FastAnimateTime delay:FastAnimateTime options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            _pager.alpha = 1;

        }completion:^(BOOL finished) {
            
            if (completion) completion();
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateCellsForReuse];
    
    CGFloat floatPage = _scrollView.contentOffset.x / _scrollView.frame.size.width;
    NSInteger page = _scrollView.contentOffset.x / _scrollView.frame.size.width + 0.5;
    
    for (NSInteger i = page - 1; i <= page + 1; i++) { // preload left and right cell
        if (i >= 0 && i < self.groupItems.count) {
            BKPhotoItemView *cell = [self cellForPage:i];
            if (!cell) {
                BKPhotoItemView *cell = [self dequeueReusableCell];
                cell.zoomDelegate = self;
                cell.page = i;
                
                CGRect cellFrame = cell.frame;
                
                cellFrame.origin.x = (self.view.frame.size.width + kPadding) * i + kPadding / 2;
                
                cell.frame = cellFrame;
                
                if (_isPresented) {
                    cell.item = self.groupItems[i];
                }
                [self.scrollView addSubview:cell];
            } else {
                if (_isPresented && !cell.item) {
                    cell.item = self.groupItems[i];
                }
            }
        }
    }
    
    NSInteger intPage = floatPage + 0.5;
    intPage = intPage < 0 ? 0 : intPage >= _groupItems.count ? (int)_groupItems.count - 1 : intPage;
    _pager.currentPage = intPage;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        _pager.alpha = 1;
    }completion:^(BOOL finish) {
    }];
}

#pragma mark ----- BKPhotoItemViewDelegate
- (void)zoomEnd
{
    _isPresented = YES;
    [self scrollViewDidScroll:_scrollView];
    _scrollView.userInteractionEnabled = YES;
    [self hidePager];
}

- (void)narrowEnd
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [self hidePager];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self hidePager];
}


- (void)hidePager {
    [UIView animateWithDuration:0.3 delay:0.8 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut animations:^{
        _pager.alpha = 0;
    }completion:^(BOOL finish) {
    }];
}

/// enqueue invisible cells for reuse
- (void)updateCellsForReuse {
    for (BKPhotoItemView *cell in _cells) {
        if (cell.superview) {
            
            CGRect celllFrame = cell.frame;
            if (celllFrame.origin.x > _scrollView.contentOffset.x + _scrollView.frame.size.width * 2||
                CGRectGetMaxX(celllFrame) < _scrollView.contentOffset.x - _scrollView.frame.size.width) {
                [cell removeFromSuperview];
                cell.page = -1;
                cell.item = nil;
            }
        }
    }
}

/// dequeue a reusable cell
- (BKPhotoItemView *)dequeueReusableCell {
    BKPhotoItemView *cell = nil;
    for (cell in _cells) {
        if (!cell.superview) {
            return cell;
        }
    }
    
    cell = [BKPhotoItemView new];
    cell.frame = self.view.bounds;
    cell.imageContainerView.frame = self.view.bounds;
    cell.imageView.frame = cell.bounds;
    cell.page = -1;
    cell.item = nil;
    [_cells addObject:cell];
    return cell;
}

/// get the cell for specified page, nil if the cell is invisible
- (BKPhotoItemView *)cellForPage:(NSInteger)page {
    for (BKPhotoItemView *cell in _cells) {
        if (cell.page == page) {
            return cell;
        }
    }
    return nil;
}

- (NSInteger)currentPage {
    NSInteger page = _scrollView.contentOffset.x / _scrollView.frame.size.width + 0.5;
    if (page >= _groupItems.count) page = (NSInteger)_groupItems.count - 1;
    if (page < 0) page = 0;
    return page;
}

- (void)doubleTap:(UITapGestureRecognizer *)gesture
{
    if (!_isPresented) return;
    BKPhotoItemView *itemView = [self cellForPage:self.currentPage];
    if (itemView) {
        if (itemView.zoomScale > 1) {
            [itemView setZoomScale:1 animated:YES];
        } else {
            CGPoint touchPoint = [gesture locationInView:itemView.imageView];
            CGFloat newZoomScale = itemView.maximumZoomScale;
            CGFloat xsize = self.view.frame.size.width / newZoomScale;
            CGFloat ysize = self.view.frame.size.height / newZoomScale;
            [itemView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
        }
    }
}


- (void)dismiss
{
    [self dismissAnimated:YES completion:nil];
}


- (void)dismissAnimated:(BOOL)animated completion:(void(^)(void))completion
{
    [UIView setAnimationsEnabled:YES];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];

    
    NSInteger currentPage = self.currentPage;
    BKPhotoItemView *cell = [self cellForPage:currentPage];
    BKPhotoItem *item = _groupItems[currentPage];
    
    UIView *fromView = nil;
    if (_fromItemIndex == currentPage) {
        fromView = _fromView;
    } else {
        fromView = item.thumbView;
    }
    
    
    [self cancelAllImageLoad];
    _isPresented = NO;
    BOOL isFromImageClipped = fromView.layer.contentsRect.size.height < 1;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    if (isFromImageClipped) {
        CGRect frame = cell.imageContainerView.frame;
        cell.imageContainerView.layer.anchorPoint = CGPointMake(0.5, 0);
        cell.imageContainerView.frame = frame;
    }
    cell.progressLayer.hidden = YES;
    [CATransaction commit];
    
    
    if (fromView == nil) {
        [UIView animateWithDuration:animated ? 0.25 : 0 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
            self.view.alpha = 0.0;
            
            [self.scrollView.layer setValue:@(0.95) forKey:@"transform.scale"];
            
            self.scrollView.alpha = 0;
            self.pager.alpha = 0;
        }completion:^(BOOL finished) {
            [self.scrollView.layer setValue:@(1) forKey:@"transform.scale"];

            [self.view removeFromSuperview];
            [self removeFromParentViewController];
            [self cancelAllImageLoad];
            if (completion) completion();
        }];
        return;
    }
    
    if (isFromImageClipped) {
        [cell scrollToTopAnimated:NO];
    }
    
    cell.fromView = fromView;
    [cell narrowSelfWithItem:item animated:animated];
    
    
    [UIView animateWithDuration:animated ? 0.15 : 0 delay:animated ? 0.2 : 0 options:UIViewAnimationOptionCurveLinear animations:^{
        _contentView.alpha = 0;
    } completion:^(BOOL finished) {
        
        if (finished) {
            [self narrowEnd];
        }
        
        if (completion) {
            completion();
        }
    }];
}

- (void)cancelAllImageLoad {
    [_cells enumerateObjectsUsingBlock:^(BKPhotoItemView *cell, NSUInteger idx, BOOL *stop) {
        [cell.imageView sd_cancelCurrentImageLoad];
    }];
}

@end
