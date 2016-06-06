//
//  BKPhotoItemView.h
//  BKPhotoBrowser
//
//  Created by BestKai on 16/5/30.
//  Copyright © 2016年 BestKai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKPhotoItem.h"
#import <YYWebImage/YYWebImage.h>

#define SlowAnimateTime  0.3
#define FastAnimateTime  0.3

@protocol BKPhotoItemViewDelegate <NSObject>

/**
 *  放大结束
 */
- (void)zoomEnd;

/**
 *  缩小结束
 */
- (void)narrowEnd;

@end


@interface BKPhotoItemView : UIScrollView<UIScrollViewDelegate>
@property (nonatomic, strong) UIView *imageContainerView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) BOOL showProgress;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) CAShapeLayer *progressLayer;

@property (nonatomic, strong) BKPhotoItem *item;
@property (nonatomic, readonly) BOOL itemDidLoad;

@property (strong,nonatomic) UIView *fromView;


@property (assign,nonatomic) id <BKPhotoItemViewDelegate> zoomDelegate;


- (void)resizeSubviewSize;
- (void)scrollToTopAnimated:(BOOL)animated;


/**
 *  放大
 *
 *  @param photoItem <#photoItem description#>
 */
- (void)zoomSelfWithItem:(BKPhotoItem *)photoItem;

/**
 *  缩小
 *
 *  @param photoItem <#photoItem description#>
 */
- (void)narrowSelfWithItem:(BKPhotoItem *)photoItem animated:(BOOL)animated;
@end
