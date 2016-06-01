//
//  BKPhotoBrowser.h
//  BKPhotoBrowser
//
//  Created by BestKai on 16/5/30.
//  Copyright © 2016年 BestKai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKPhotoItem.h"


@interface BKPhotoBrowser : UIViewController


@property (nonatomic, readonly) NSArray *groupItems; ///< Array<YYPhotoGroupItem>
@property (nonatomic, readonly) NSInteger currentPage;
@property (nonatomic, assign) BOOL blurEffectBackground; ///< Default is YES



- (instancetype)initWithPhotoItems:(NSArray *)PhotoItems;


- (void)showFromImageView:(UIView *)fromView andCurrentIndex:(NSInteger)currentIndex completion:(void (^)(void))completion;

@end
