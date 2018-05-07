//
//  CCYPhotoBrowserController.h
//  CCYPhotoBrowserDemo
//
//  Created by godyu on 2018/5/4.
//  Copyright © 2018年 godyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCYPhotoBrowserController : UIViewController

/**
 构造函数

 @param urls url数组
 @param selectedIndex 点击索引
 @param parentImageViews 图片列表
 @return 实例化
 */
+ (instancetype)photoBrowserForUrls:(NSArray *)urls selectedIndex:(NSInteger)selectedIndex parentImageViews:(NSArray *)parentImageViews;

@end
