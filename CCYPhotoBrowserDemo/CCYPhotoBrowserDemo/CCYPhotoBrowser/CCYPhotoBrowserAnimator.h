//
//  CCYPhotoBrowserAnimator.h
//  CCYPhotoBrowserDemo
//
//  Created by godyu on 2018/5/4.
//  Copyright © 2018年 godyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class CCYPhotoBrowserPhotos;

@interface CCYPhotoBrowserAnimator : NSObject<UIViewControllerTransitioningDelegate>

+ (instancetype)animatorWithPhotos:(CCYPhotoBrowserPhotos *)photos;

@property (nonatomic, strong)UIImageView *fromView;


@end
