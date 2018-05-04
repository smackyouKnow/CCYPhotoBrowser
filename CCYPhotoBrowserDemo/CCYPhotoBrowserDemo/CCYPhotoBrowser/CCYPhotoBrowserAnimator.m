//
//  CCYPhotoBrowserAnimator.m
//  CCYPhotoBrowserDemo
//
//  Created by godyu on 2018/5/4.
//  Copyright © 2018年 godyu. All rights reserved.
//

#import "CCYPhotoBrowserAnimator.h"
#import "CCYPhotoBrowserPhotos.h"
#import "YYWebImage.h"

@interface CCYPhotoBrowserAnimator() <UIViewControllerAnimatedTransitioning>

@end

@implementation CCYPhotoBrowserAnimator{
    BOOL _isPresting;
    CCYPhotoBrowserPhotos *_photos;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    _isPresting = YES;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    _isPresting = NO;
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    _isPresting ? [self presentTransition:transitionContext] : [self dismissTransition:transitionContext];
}

- (void)presentTransition:(nonnull id<UIViewControllerContextTransitioning>)presentTransition {
    
    UIView *containerView = [presentTransition containerView];
    
    UIImageView *animationImageView = [self animationImageView];
    UIImageView *parentImageView = [self parentImageView];
    //设置初始的frame
    animationImageView.frame = [containerView convertRect:parentImageView.frame fromView:parentImageView.superview];
    [containerView addSubview:animationImageView];
    
    //获取要modal的view，并设置为透明
    UIView *toView = [presentTransition viewForKey:UITransitionContextToViewKey];
    [containerView addSubview:toView];
    toView.alpha = 0.0;
    
    [UIView animateWithDuration:[self transitionDuration:presentTransition] animations:^{
        animationImageView.frame = [self presentedRectForImageView:animationImageView];
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:[self transitionDuration:presentTransition] animations:^{
            toView.alpha = 1.0;
        } completion:^(BOOL finished) {
            [animationImageView removeFromSuperview];
            [presentTransition completeTransition:YES];
        }];
    }];
    
}

- (void)dismissTransition:(nonnull id<UIViewControllerContextTransitioning>)dismissTransition {
    
}

- (UIImageView *)animationImageView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self animationImage]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    
    return imageView;
}

- (UIImage *)animationImage {
    //先到本地缓存池找
    NSString *key = _photos.urls[_photos.selectedIndex];
    UIImage *image = [[YYWebImageManager sharedManager].cache getImageForKey:key];
    
    //没有的话就用外部列表的图
    if (image == nil) {
        image = _photos.parentImageViews[_photos.selectedIndex].image;
    }
    return image;
}

- (UIImageView *)parentImageView {
    return _photos.parentImageViews[_photos.selectedIndex];
}

- (CGRect)presentedRectForImageView:(UIImageView *)imageView {
    UIImage *image = imageView.image;
    
    if (image == nil) {
        return imageView.frame;
    }
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGSize imageSize = screenSize;

    imageSize.height = imageSize.width * image.size.height / image.size.width;
    
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    
    //如果图片大小小于屏幕大小
    if (imageSize.height < screenSize.height) {
        rect.origin.y = (screenSize.height - imageSize.height) / 2.0;
    }
    return rect;
}


@end
