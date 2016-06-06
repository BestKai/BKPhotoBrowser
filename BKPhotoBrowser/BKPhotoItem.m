//
//  BKPhotoItem.m
//  BKPhotoBrowser
//
//  Created by BestKai on 16/5/30.
//  Copyright © 2016年 BestKai. All rights reserved.
//

#import "BKPhotoItem.h"

@interface BKPhotoItem()

- (BOOL)shouldClipToTop:(CGSize)imageSize forView:(UIView *)view;

@end

@implementation BKPhotoItem


- (UIImage *)thumbImage
{
    if ([_thumbView respondsToSelector:@selector(image)]) {
        return ((UIImageView *)_thumbView).image;
    }
    return nil;
}

- (BOOL)thumbClippedToTop
{
    if (_thumbView) {
        if (_thumbView.layer.contentsRect.size.height < 1) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)shouldClipToTop:(CGSize)imageSize forView:(UIView *)view {
    if (imageSize.width < 1 || imageSize.height < 1) return NO;
    if (view.frame.size.width < 1 || view.frame.size.height < 1) return NO;
    return imageSize.height / imageSize.width > view.frame.size.width / view.frame.size.height;
}

@end
