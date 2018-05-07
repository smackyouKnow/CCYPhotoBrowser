//
//  CCYPhotoBrowserController.m
//  CCYPhotoBrowserDemo
//
//  Created by godyu on 2018/5/4.
//  Copyright © 2018年 godyu. All rights reserved.
//

#import "CCYPhotoBrowserController.h"
#import "CCYPhotoViewController.h"
#import "CCYPhotoBrowserPhotos.h"
#import "CCYPhotoBrowserAnimator.h"

@interface CCYPhotoBrowserController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIGestureRecognizerDelegate>
/** 模型 */
@property (nonatomic, strong)CCYPhotoBrowserPhotos *photos;
/** 动画播放器对象 */
@property (nonatomic, strong)CCYPhotoBrowserAnimator *animator;

/** 状态栏是否隐藏 */
@property (nonatomic, assign)BOOL statusBarHidden;
/** 分页显示按钮 */
@property (nonatomic, strong)UIButton *pageButton;
/** 提示飘窗 */
@property (nonatomic, strong)UILabel *messageLabel;
/** 记录一个当前显示的vc */
@property (nonatomic, strong)CCYPhotoViewController *currentViewController;



@end

@implementation CCYPhotoBrowserController

+ (instancetype)photoBrowserForUrls:(NSArray *)urls selectedIndex:(NSInteger)selectedIndex parentImageViews:(NSArray *)parentImageViews {
    return [[self alloc] initWithUrls:urls selectedIndex:selectedIndex parentImageViews:parentImageViews];
}
- (instancetype)initWithUrls:(NSArray *)urls selectedIndex:(NSInteger)selectedIndex parentImageViews:(NSArray *)parentImageViews {
    if (self = [super init]) {
        _photos = [CCYPhotoBrowserPhotos new];
        _photos.urls = urls;
        _photos.selectedIndex = selectedIndex;
        _photos.parentImageViews = parentImageViews;
        
        _statusBarHidden = NO;
        
        self.modalPresentationStyle = UIModalPresentationCustom;
        _animator = [CCYPhotoBrowserAnimator animatorWithPhotos:_photos];
        self.transitioningDelegate = _animator;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

#pragma mark - 设置状态栏
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _statusBarHidden = YES;
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    
    _statusBarHidden = NO;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)prefersStatusBarHidden {
    return _statusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

#pragma mark - 界面相关
- (void)setupUI {
    self.view.backgroundColor = [UIColor blackColor];
    
    //分页控制器
    UIPageViewController *pageVC = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey : @20}];
    pageVC.dataSource = self;
    pageVC.delegate = self;
    
    //创建当前显示的控制器
    CCYPhotoViewController *viewer = [self photoController:_photos.selectedIndex];
    
    [pageVC setViewControllers:@[viewer] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self.view addSubview:pageVC.view];
    [self addChildViewController:pageVC];
    [pageVC didMoveToParentViewController:self];
    
    _currentViewController = viewer;
    
    //创建手势
    self.view.gestureRecognizers = pageVC.gestureRecognizers;
    self.view.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture)];
    [self.view addGestureRecognizer:tap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapGesture:)];
    doubleTap.numberOfTapsRequired = 2;
    [tap requireGestureRecognizerToFail:doubleTap];
    [self.view addGestureRecognizer:doubleTap];
    
    UIRotationGestureRecognizer *rotate = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(interactiveGesture:)];
    [self.view addGestureRecognizer:rotate];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesture:)];
    [self.view addGestureRecognizer:longPress];
    rotate.delegate = self;
    
    
    
    //添加顶部显示按钮
    _pageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    _pageButton.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.6];
    _pageButton.center = CGPointMake(self.view.center.x, _pageButton.frame.size.height);
    _pageButton.layer.cornerRadius = 6;
    _pageButton.layer.masksToBounds = YES;
    [self setPageBtnTextForIndex:_photos.selectedIndex];
    
    [self.view addSubview:_pageButton];
    
    //添加提示标签
    _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    _messageLabel.textColor = [UIColor whiteColor];
    _messageLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    _messageLabel.center = self.view.center;
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.layer.cornerRadius = 5;
    _messageLabel.layer.masksToBounds = YES;
    _messageLabel.text = @"呵呵哒了";
    _messageLabel.font = [UIFont systemFontOfSize:17];
    _messageLabel.transform = CGAffineTransformMakeScale(0, 0);
    [self.view addSubview:_messageLabel];
}

#pragma mark - 手势相关
//点击
- (void)tapGesture{
    
    _animator.fromView = _currentViewController.imageView;
    [self dismissViewControllerAnimated:YES completion:nil];
}

//双击
- (void)doubleTapGesture:(UIGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self.view];
    if (point.y < _currentViewController.scrollView.contentInset.top || point.y > _currentViewController.scrollView.contentInset.top + _currentViewController.imageView.frame.size.height) {
        return;
    }
    
    _statusBarHidden = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    
    [UIView animateWithDuration:0.3 animations:^{
         self.currentViewController.scrollView.zoomScale = 2;
    }];
    
}

//旋转&捏合
- (void)interactiveGesture:(UIGestureRecognizer *)gesture {
    _statusBarHidden = (_currentViewController.scrollView.maximumZoomScale > 1.0);
    [self setNeedsStatusBarAppearanceUpdate];
    
    if (_statusBarHidden) {
        
    }
    
    
    CGAffineTransform transfrom = CGAffineTransformIdentity;
    if ([gesture isKindOfClass:[UIRotationGestureRecognizer class]]) {
        UIRotationGestureRecognizer *rotate = (UIRotationGestureRecognizer *)gesture;
        CGFloat rotation = rotate.rotation;
        
        transfrom = CGAffineTransformRotate(transfrom, rotation);
    }
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
            _pageButton.hidden = YES;
            self.view.backgroundColor = [UIColor clearColor];
            
            self.view.transform = transfrom;
            self.view.alpha = transfrom.a;
            
            break;
            
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded:
            [self tapGesture];
            break;
        default:
            break;
    }
}

- (void)longPressGesture:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        return;
    }
    
    if (_currentViewController.imageView.image == nil) {
        return;
    }
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"保存至相册"   style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImageWriteToSavedPhotosAlbum(self.currentViewController.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)info {
    NSString *message = error == nil ? @"保存成功" : @"保存失败";
    
    _messageLabel.text = message;
    
    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:10 options:0 animations:^{
        self.messageLabel.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.messageLabel.transform = CGAffineTransformMakeScale(0, 0);
        }];
    }];
}


#pragma mark - UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(CCYPhotoViewController *)viewController {
    NSInteger index = viewController.photoIndex;
    
    if (index-- <= 0) {
        return nil;
    }
    return [self photoController:index];
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(CCYPhotoViewController *)viewController {
    
    NSInteger index = viewController.photoIndex;
    if (++index >= _photos.urls.count) {
        return nil;
    }
    
    return [self photoController:index];
}

#pragma mark - UIPageViewControllerDelegate
//动画结束
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    CCYPhotoViewController *viewer = pageViewController.viewControllers[0];
    _photos.selectedIndex = viewer.photoIndex;
    
    _currentViewController = viewer;
    
    [self setPageBtnTextForIndex:_photos.selectedIndex];
}

//设置page文字
- (void)setPageBtnTextForIndex:(NSInteger)index {
    _pageButton.hidden = (_photos.urls.count == 1);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld", index + 1] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" / %ld", _photos.urls.count] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : [UIColor whiteColor]}]];
    [_pageButton setAttributedTitle:attributedString forState:UIControlStateNormal];
}


//创建vc的方法
- (CCYPhotoViewController *)photoController:(NSInteger)index {
    return [CCYPhotoViewController viewerWithUrlString:_photos.urls[index] photoIndex:index placeholder:_photos.parentImageViews[index].image];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
