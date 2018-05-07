//
//  ViewController.m
//  CCYPhotoBrowserDemo
//
//  Created by godyu on 2018/5/4.
//  Copyright © 2018年 godyu. All rights reserved.
//

#import "ViewController.h"
#import "YYWebImage.h"
#import "CCYPhotoBrowserController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViews;

/** <#(id)#> */
@property (nonatomic, strong)NSArray *array;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _array = @[@"http://wx2.sinaimg.cn/large/806415c9ly1fqzgslyafej20hr0dajsi.jpg",
                        @"http://wx2.sinaimg.cn/large/806415c9ly1fqzgs9t833j20b808xdgs.jpg",
                        @"http://wx1.sinaimg.cn/large/806415c9ly1fqzgsmg12hj20dw09hgmj.jpg",
                        @"http://wx3.sinaimg.cn/large/806415c9ly1fqzgsmrynoj20d5099q3t.jpg"
                       ];
    
    for (UIImageView *imageView in _imageViews) {
        imageView.userInteractionEnabled = YES;
        [imageView yy_setImageWithURL:[NSURL URLWithString:_array[imageView.tag - 1]] placeholder:nil];
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    }
}

- (void)tap:(UITapGestureRecognizer *)sender {
    
    CCYPhotoBrowserController *vc = [CCYPhotoBrowserController photoBrowserForUrls: _array selectedIndex:sender.view.tag - 1 parentImageViews:_imageViews];
    [self presentViewController:vc animated:YES completion:nil];
    
}




@end
