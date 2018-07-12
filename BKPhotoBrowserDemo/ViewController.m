//
//  ViewController.m
//  BKPhotoBrowserDemo
//
//  Created by BestKai on 16/6/6.
//  Copyright © 2016年 BestKai. All rights reserved.
//

#import "ViewController.h"
#import "BKPhotoBrowser.h"

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
    urlArray = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1531399707483&di=59c0b1c1b1d95d6dfee2726b380c88f7&imgtype=0&src=http%3A%2F%2Fyouimg1.c-ctrip.com%2Ftarget%2Ffd%2Ftg%2Fg2%2FM00%2F1C%2F79%2FCghzf1Vr9wSAY9WdADLfAfZVKbo557.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1531399707483&di=59c0b1c1b1d95d6dfee2726b380c88f7&imgtype=0&src=http%3A%2F%2Fyouimg1.c-ctrip.com%2Ftarget%2Ffd%2Ftg%2Fg2%2FM00%2F1C%2F79%2FCghzf1Vr9wSAY9WdADLfAfZVKbo557.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1531399707483&di=59c0b1c1b1d95d6dfee2726b380c88f7&imgtype=0&src=http%3A%2F%2Fyouimg1.c-ctrip.com%2Ftarget%2Ffd%2Ftg%2Fg2%2FM00%2F1C%2F79%2FCghzf1Vr9wSAY9WdADLfAfZVKbo557.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1531399707483&di=59c0b1c1b1d95d6dfee2726b380c88f7&imgtype=0&src=http%3A%2F%2Fyouimg1.c-ctrip.com%2Ftarget%2Ffd%2Ftg%2Fg2%2FM00%2F1C%2F79%2FCghzf1Vr9wSAY9WdADLfAfZVKbo557.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1531399707483&di=59c0b1c1b1d95d6dfee2726b380c88f7&imgtype=0&src=http%3A%2F%2Fyouimg1.c-ctrip.com%2Ftarget%2Ffd%2Ftg%2Fg2%2FM00%2F1C%2F79%2FCghzf1Vr9wSAY9WdADLfAfZVKbo557.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1531399707483&di=59c0b1c1b1d95d6dfee2726b380c88f7&imgtype=0&src=http%3A%2F%2Fyouimg1.c-ctrip.com%2Ftarget%2Ffd%2Ftg%2Fg2%2FM00%2F1C%2F79%2FCghzf1Vr9wSAY9WdADLfAfZVKbo557.jpg",@"http://buyapp.gcimg.net/test/20160524c556937260.jpeg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1531399707483&di=59c0b1c1b1d95d6dfee2726b380c88f7&imgtype=0&src=http%3A%2F%2Fyouimg1.c-ctrip.com%2Ftarget%2Ffd%2Ftg%2Fg2%2FM00%2F1C%2F79%2FCghzf1Vr9wSAY9WdADLfAfZVKbo557.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1531399707483&di=59c0b1c1b1d95d6dfee2726b380c88f7&imgtype=0&src=http%3A%2F%2Fyouimg1.c-ctrip.com%2Ftarget%2Ffd%2Ftg%2Fg2%2FM00%2F1C%2F79%2FCghzf1Vr9wSAY9WdADLfAfZVKbo557.jpg"];
    
    for (int i = 0; i<9; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i%3 * 100 + (i%3 + 1)*(SCREENWIDTH-300)/4.0,100 + i/3 * 100 + (i/3 + 1)*(SCREENWIDTH-300)/4.0, 100, 100)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlArray[i]]];
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
        
        photoItem.thumbView = [self.view viewWithTag:i+100];
        
        photoItem.originImageUrl = [NSURL URLWithString:urlArray[i]];
        
        [items addObject:photoItem];
    }
    BKPhotoBrowser *photoBrowser = [[BKPhotoBrowser alloc] initWithPhotoItems:items];
    photoBrowser.shouldShowPageControl = YES;
    photoBrowser.pageType = 1;
    [photoBrowser showFromImageView:imageView andCurrentIndex:imageView.tag-100 completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
