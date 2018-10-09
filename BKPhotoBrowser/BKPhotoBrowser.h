//
//  BKPhotoBrowser.h
//  BKPhotoBrowser
//
//  Created by BestKai on 16/5/30.
//  Copyright © 2016年 BestKai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKPhotoItem.h"
#import <SDWebImage/UIImageView+WebCache.h>


typedef enum : NSUInteger {
    bottomPageCtrType,
    topLabelType,
} pageControlType;

@interface BKPhotoBrowser : UIViewController

/**
 图片浏览需要model
 */
@property (nonatomic, readonly) NSArray<BKPhotoItem *> *groupItems;
@property (nonatomic, readonly) NSInteger currentPage;
/**
 *  是否显示 页数提示
 */
@property (assign,nonatomic) BOOL  shouldShowPageControl;

/**
 翻页指示器类型
 */
@property (assign,nonatomic) pageControlType pageType;


/**
 初始化图片浏览器

 @param PhotoItems <#PhotoItems description#>
 @return <#return value description#>
 */
- (instancetype)initWithPhotoItems:(NSArray<BKPhotoItem *> *)PhotoItems;


/**
 显示
 @param fromView 点击的哪个subView  可以为nil
 @param currentIndex <#currentIndex description#>
 @param completion <#completion description#>
 */
- (void)showFromImageView:(UIView *)fromView andCurrentIndex:(NSInteger)currentIndex completion:(void (^)(void))completion;

@end
