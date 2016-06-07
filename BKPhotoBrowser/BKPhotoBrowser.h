//
//  BKPhotoBrowser.h
//  BKPhotoBrowser
//
//  Created by BestKai on 16/5/30.
//  Copyright © 2016年 BestKai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKPhotoItem.h"
#import <YYWebImage/YYWebImage.h>


typedef enum : NSUInteger {
    bottomPageCtrType,
    topLabelType,
} pageControlType;

@interface BKPhotoBrowser : UIViewController


@property (nonatomic, readonly) NSArray *groupItems; ///< Array<YYPhotoGroupItem>
@property (nonatomic, readonly) NSInteger currentPage;
/**
 *  是否显示 页数提示
 */
@property (assign,nonatomic) BOOL  shouldShowPageControl;

@property (assign,nonatomic) pageControlType pageType;


- (instancetype)initWithPhotoItems:(NSArray *)PhotoItems;


- (void)showFromImageView:(UIView *)fromView andCurrentIndex:(NSInteger)currentIndex completion:(void (^)(void))completion;

@end
