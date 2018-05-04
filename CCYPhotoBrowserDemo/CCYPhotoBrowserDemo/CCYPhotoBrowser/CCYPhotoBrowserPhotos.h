//
//  CCYPhotoBrowserPhotos.h
//  CCYPhotoBrowserDemo
//
//  Created by godyu on 2018/5/4.
//  Copyright © 2018年 godyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CCYPhotoBrowserPhotos : NSObject

@property (nonatomic, strong)NSArray<NSString *> *urls;

/** 用于放变做动画的图片数组 */
@property (nonatomic, strong)NSArray<UIImageView *> *parentImageViews;

/** 当前图片的选择 */
@property (nonatomic, assign)NSInteger selectedIndex;

@end
