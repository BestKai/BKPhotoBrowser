//
//  ViewController.m
//  BKPhotoBrowser
//
//  Created by BestKai on 16/5/25.
//  Copyright © 2016年 BestKai. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"
#import "BKPhotoBrowser/BKPhotoBrowser.h"

#define  SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define  SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()
{
    NSArray *urlArray;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    urlArray = @[@"http://buyapp.gcimg.net/test/20160524c643aa5464.jpeg",@"http://buyapp.gcimg.net/test/201605243b2b90d02e.jpeg",@"http://buyapp.gcimg.net/test/201605240f5efd34ab.jpeg",@"http://buyapp.gcimg.net/test/20160524137ba32b9a.jpeg",@"http://buyapp.gcimg.net/test/20160524584119cbfe.jpeg",@"http://buyapp.gcimg.net/test/20160524beefcd55d9.jpeg",@"http://buyapp.gcimg.net/test/20160524c556937260.jpeg",@"http://buyapp.gcimg.net/test/201605245aefda0fda.jpeg",@"http://buyapp.gcimg.net/test/2016052498d22d50b5.jpeg"];
    
    for (int i = 0; i<9; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i%3 * 100 + (i%3 + 1)*(SCREENWIDTH-300)/4.0,100 + i/3 * 100 + (i/3 + 1)*(SCREENWIDTH-300)/4.0, 100, 100)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[urlArray[i] stringByAppendingString:@"!400.400"]] placeholderImage:nil];
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)]];
        imageView.tag = 100+i;
        imageView.userInteractionEnabled = YES;
        [self.view addSubview:imageView];
    }
}

- (void)imageViewTapped:(UITapGestureRecognizer *)gesture
{
    UIImageView *imageView = (UIImageView *)gesture.view;
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (int i = 0; i<9; i++) {
        BKPhotoItem *photoItem = [[BKPhotoItem alloc] init];
        
        if (i<9) {
            photoItem.thumbView = [self.view viewWithTag:i+100];
        }
        
        photoItem.originImageUrl = [NSURL URLWithString:urlArray[i]];
        
        [items addObject:photoItem];
    }
    
    BKPhotoBrowser *photoBrowser = [[BKPhotoBrowser alloc] initWithPhotoItems:items];
    
    [photoBrowser showFromImageView:imageView andCurrentIndex:imageView.tag-100 completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
