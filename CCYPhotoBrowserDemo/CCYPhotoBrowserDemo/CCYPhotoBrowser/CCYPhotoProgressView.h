//
//  CCYPhotoProgressView.h
//  CCYPhotoBrowserDemo
//
//  Created by godyu on 2018/5/4.
//  Copyright © 2018年 godyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCYPhotoProgressView : UIView

@property (nonatomic, assign)float progress;

/** 外圈的颜色 */
@property (nonatomic, strong)UIColor *borderColor;

/** 底部的颜色 */
@property (nonatomic, strong)UIColor *baseTintColor;

/** 进度的颜色 */
@property (nonatomic, strong)UIColor *progressTintColor;


@end
