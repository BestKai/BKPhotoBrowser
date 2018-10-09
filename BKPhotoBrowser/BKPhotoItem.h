//
//  BKPhotoItem.h
//  BKPhotoBrowser
//
//  Created by BestKai on 16/5/30.
//  Copyright © 2016年 BestKai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface BKPhotoItem : NSObject

/**
 点击某个放大的View 可以不传
 */
@property (strong,nonatomic) UIView *thumbView;

/**
 图片原始链接
 */
@property (strong,nonatomic) NSURL *originImageUrl;

/**
 缩略图  （可以传placeHolder）
 */
@property (nonatomic, strong) UIImage *thumbImage;

@property (nonatomic, readonly) BOOL thumbClippedToTop;

@end
