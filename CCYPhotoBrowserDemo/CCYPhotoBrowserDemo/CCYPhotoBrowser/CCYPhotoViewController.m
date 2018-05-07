//
//  CCYPhotoViewController.m
//  CCYPhotoBrowserDemo
//
//  Created by godyu on 2018/5/4.
//  Copyright © 2018年 godyu. All rights reserved.
//

#import "CCYPhotoViewController.h"
#import "CCYPhotoProgressView.h"
#import "YYWebImage.h"

@interface CCYPhotoViewController ()<UIScrollViewDelegate>

/** 进度条 */
@property (nonatomic, strong)CCYPhotoProgressView *progressView;

@property (nonatomic, strong)UIScrollView *scrollView;

/** 占位图片 */
@property (nonatomic, strong)UIImage *placeholder;
@property (nonatomic, strong)YYAnimatedImageView *imageView;
/** 图片url */
@property (nonatomic, strong)NSURL *url;



@end

@implementation CCYPhotoViewController

+ (instancetype)viewerWithUrlString:(NSString *)urlString photoIndex:(NSInteger)photoIndex placeholder:(UIImage *)placeholder {
    return [[self alloc] initWithUrlString:urlString photoIndex:photoIndex placeholder:placeholder];
}

- (instancetype)initWithUrlString:(NSString *)urlString photoIndex:(NSInteger)photoIndex placeholder:(UIImage *)placeholder {
    if (self = [super init]) {
        urlString = [urlString stringByReplacingOccurrencesOfString:@"/middle/" withString:@"/large/"];
        _url = [NSURL URLWithString:urlString];
        _placeholder = [UIImage imageWithCGImage:placeholder.CGImage scale:1.0 orientation:placeholder.imageOrientation];
        _photoIndex = photoIndex;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    [self loadImage];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.scrollView.zoomScale = 1;
}

- (void)setupUI {
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _imageView = [[YYAnimatedImageView alloc]initWithImage:_placeholder];
    _imageView.center = self.view.center;
    [self.scrollView addSubview:_imageView];
    
    _progressView = [[CCYPhotoProgressView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    _progressView.center = self.view.center;
    _progressView.progress = 1.0;
    [self.view addSubview:_progressView];
    
    self.scrollView.maximumZoomScale = 2.0;
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.delegate = self;
}

- (void)loadImage {
    [_imageView yy_setImageWithURL:_url placeholder:_placeholder options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.progress = (float)receivedSize / expectedSize;
    } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
        if (image == nil) {
            return ;
        }
        [self presentRectForImage:image];
    }];
}
//加载完成，计算图片尺寸
- (void)presentRectForImage:(UIImage *)image {
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGSize imageSize = screenSize;
    
    imageSize.height = imageSize.width * image.size.height / image.size.width;
    _imageView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
    _scrollView.contentSize = imageSize;
    
    //图高度比屏幕小，放在中间
    if (imageSize.height < screenSize.height) {
        CGFloat offSetY = (screenSize.height - imageSize.height) / 2.0;
        _scrollView.contentInset = UIEdgeInsetsMake(offSetY, 0, offSetY, 0);
//        _imageView.frame = CGRectMake(0, offSetY, imageSize.width, imageSize.height);
    }
}

#pragma mark - UIScrollViewDelegate
//缩放必须实现的代理
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

@end
