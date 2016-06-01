//
//  BKPhotoItemView.m
//  BKPhotoBrowser
//
//  Created by BestKai on 16/5/30.
//  Copyright © 2016年 BestKai. All rights reserved.
//

#import "BKPhotoItemView.h"

@implementation BKPhotoItemView

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.delegate = self;
        self.bouncesZoom = YES;
        self.maximumZoomScale = 2;
        self.multipleTouchEnabled = YES;
        self.alwaysBounceVertical = NO;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        
        _imageContainerView = [UIView new];
        _imageContainerView.clipsToBounds = YES;
        [self addSubview:_imageContainerView];
        
        _imageView = [UIImageView new];
        _imageView.clipsToBounds = YES;
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        [_imageContainerView addSubview:_imageView];
        
        [self.layer addSublayer:self.progressLayer];
    }
    return self;
}

- (CAShapeLayer *)progressLayer
{
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.frame = CGRectMake(0, 0, 40, 40);
        _progressLayer.cornerRadius = 20;
        _progressLayer.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500].CGColor;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(_progressLayer.bounds, 7, 7) cornerRadius:(40 / 2 - 7)];
        _progressLayer.path = path.CGPath;
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        _progressLayer.strokeColor = [UIColor whiteColor].CGColor;
        _progressLayer.lineWidth = 4;
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.strokeStart = 0;
        _progressLayer.strokeEnd = 0;
        _progressLayer.hidden = YES;

    }
    return _progressLayer;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.progressLayer.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 40)/2.0, ([UIScreen mainScreen].bounds.size.height -40)/2.0, 40, 40);
}

- (void)setItem:(BKPhotoItem *)item {
    if (_item == item) return;
    _item = item;
    _itemDidLoad = NO;
    
    
    [self setZoomScale:1.0 animated:NO];
    self.maximumZoomScale = 1;
    
    [_imageView sd_cancelCurrentImageLoad];
    
    _progressLayer.hidden = NO;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _progressLayer.strokeEnd = 0;
    _progressLayer.hidden = YES;
    [CATransaction commit];
    
    if (!_item) {
        _imageView.image = nil;
        return;
    }
    
    [_imageView sd_setImageWithURL:item.originImageUrl placeholderImage:item.thumbImage options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        CGFloat progress = receivedSize / (float)expectedSize;
        progress = progress < 0.01 ? 0.01 : progress > 1 ? 1 : progress;
        if (isnan(progress)) progress = 0;
        self.progressLayer.hidden = NO;
        self.progressLayer.strokeEnd = progress;

    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        self.progressLayer.hidden = YES;
        if (image) {
            self.maximumZoomScale = 2;
            if (image) {
                self->_itemDidLoad = YES;
                
                [self resizeSubviewSize];
                
//                [self.imageView.layer addFadeAnimationWithDuration:0.1 curve:UIViewAnimationCurveLinear];
            }
        }

    }];
    
    [self resizeSubviewSize];
}

- (void)resizeSubviewSize {
    
    CGRect containerFrame = _imageContainerView.frame;
    containerFrame.origin = CGPointZero;
    containerFrame.size.width = self.frame.size.width;
    _imageContainerView.frame = containerFrame;
    
    
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.frame.size.height / self.frame.size.width) {
        
        containerFrame.size.height = floor(image.size.height / (image.size.width / self.frame.size.width));
        _imageContainerView.frame = containerFrame;
    } else {
        CGFloat height = image.size.height / image.size.width * self.frame.size.width;
        if (height < 1 || isnan(height)) height = self.frame.size.height;
        height = floor(height);
        
        containerFrame.size.height = height;
        _imageContainerView.frame = containerFrame;
        
        _imageContainerView.center = CGPointMake(_imageContainerView.center.x, self.frame.size.height / 2);
        
    }
    if (_imageContainerView.frame.size.height > self.frame.size.height && _imageContainerView.frame.size.height - self.frame.size.height <= 1) {
        
        containerFrame.size.height = self.frame.size.height;
        _imageContainerView.frame = containerFrame;
    }
    
    self.contentSize = CGSizeMake(self.frame.size.width, MAX(_imageContainerView.frame.size.height, self.frame.size.height));
    [self scrollRectToVisible:self.bounds animated:NO];
    
    if (_imageContainerView.frame.size.height <= self.frame.size.height) {
        self.alwaysBounceVertical = NO;
    } else {
        self.alwaysBounceVertical = YES;
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _imageView.frame = _imageContainerView.bounds;
    [CATransaction commit];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageContainerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIView *subView = _imageContainerView;
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)scrollToTopAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = 0 - self.contentInset.top;
    [self setContentOffset:off animated:animated];
}

- (void)zoomSelfWithItem:(BKPhotoItem *)photoItem {
    
    if (!photoItem.thumbClippedToTop) {
        NSString *imageKey = [[SDWebImageManager sharedManager] cacheKeyForURL:photoItem.originImageUrl];
        if ([[SDWebImageManager sharedManager].imageCache imageFromMemoryCacheForKey:imageKey]) {
            self.item = photoItem;
        }
    }
    if (!self.item) {
        self.imageView.image = photoItem.thumbImage;
        [self resizeSubviewSize];
    }
    
    if (photoItem.thumbClippedToTop) {
        CGRect fromFrame = [_fromView convertRect:_fromView.bounds toView:self];
        CGRect originFrame = self.imageContainerView.frame;
        CGFloat scale = fromFrame.size.width / self.imageContainerView.frame.size.width;
        
        self.imageContainerView.layer.transformScale = scale;
        
        CGRect containerFrame = self.imageContainerView.frame;
        containerFrame.origin = CGPointMake(CGRectGetMidX(fromFrame), CGRectGetMidY(fromFrame));
        containerFrame.size.height = fromFrame.size.height / scale;
        
        self.imageContainerView.frame = containerFrame;
        
        [UIView animateWithDuration:SlowAnimateTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.imageContainerView.layer.transformScale = 1;
            self.imageContainerView.frame = originFrame;
        }completion:^(BOOL finished) {
        
            if (self.zoomDelegate && [self.zoomDelegate respondsToSelector:@selector(zoomEnd)]) {
                [self.zoomDelegate zoomEnd];
            }
        }];
        
    } else {
        CGRect fromFrame = [_fromView convertRect:_fromView.bounds toView:self.imageContainerView];
        
        self.imageContainerView.clipsToBounds = NO;
        self.imageView.frame = fromFrame;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [UIView animateWithDuration:FastAnimateTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            self.imageView.frame = self.imageContainerView.bounds;
            self.imageView.layer.transformScale = 1.01;
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:FastAnimateTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
                self.imageView.layer.transformScale = 1.0;
            }completion:^(BOOL finished) {
                self.imageContainerView.clipsToBounds = YES;
                
                if (self.zoomDelegate && [self.zoomDelegate respondsToSelector:@selector(zoomEnd)]) {
                    [self.zoomDelegate zoomEnd];
                }
            }];
        }];
    }
}


- (void)narrowSelfWithItem:(BKPhotoItem *)photoItem animated:(BOOL)animated {
    
    BOOL isFromImageClipped = _fromView.layer.contentsRect.size.height < 1;

    [UIView animateWithDuration:animated ? 0.2 : 0 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
        if (isFromImageClipped) {
            
            CGRect fromFrame = [_fromView convertRect:_fromView.bounds toView:self];
            CGFloat scale = fromFrame.size.width / self.imageContainerView.frame.size.width * self.zoomScale;
            CGFloat height = fromFrame.size.height / fromFrame.size.width * self.imageContainerView.frame.size.width;
            if (isnan(height)) height = self.imageContainerView.frame.size.height;
            
            CGRect cellFrame = self.imageContainerView.frame;
            cellFrame.size.height = height;
            self.imageContainerView.frame = cellFrame;
            
            self.imageContainerView.center = CGPointMake(CGRectGetMidX(fromFrame), CGRectGetMinY(fromFrame));
            
            self.imageContainerView.layer.transformScale = scale;
            
        } else {
            CGRect fromFrame = [_fromView convertRect:_fromView.bounds toView:self.imageContainerView];
            self.imageContainerView.clipsToBounds = NO;
            self.imageView.contentMode = _fromView.contentMode;
            self.imageView.frame = fromFrame;
        }
    }completion:^(BOOL finished) {
        
        [UIView animateWithDuration:animated ? 0.15 : 0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        } completion:^(BOOL finished) {
            self.imageContainerView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        }];
    }];
}





@end
