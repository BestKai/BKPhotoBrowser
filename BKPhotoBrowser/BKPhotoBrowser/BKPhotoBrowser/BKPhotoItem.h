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

@property (strong,nonatomic) UIView *thumbView;

@property (strong,nonatomic) NSURL *originImageUrl;

@property (nonatomic, readonly) UIImage *thumbImage;
@property (nonatomic, readonly) BOOL thumbClippedToTop;

@end
