//
//  CCYPhotoProgressView.m
//  CCYPhotoBrowserDemo
//
//  Created by godyu on 2018/5/4.
//  Copyright © 2018年 godyu. All rights reserved.
//

#import "CCYPhotoProgressView.h"

@implementation CCYPhotoProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - get & set
- (UIColor *)baseTintColor {
    if (_baseTintColor == nil) {
        _baseTintColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    }
    return _borderColor;
}

- (UIColor *)borderColor {
    if (_borderColor == nil) {
        _borderColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    }
    return _borderColor;
}

- (UIColor *)progressTintColor {
    if (_progressTintColor == nil) {
        _progressTintColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    }
    return _progressTintColor;
}

- (void)setProgress:(float)progress {
    _progress = progress;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    if (rect.size.width == 0 || rect.size.height == 0) return;
    
    if (_progress >= 1.0) {
        return;
    }
    
    CGFloat radius = MIN(rect.size.width, rect.size.height) / 2.0;
    CGPoint center = CGPointMake(rect.size.width / 2.0, rect.size.height / 2.0);
    
    //1.画外圈
    [self.borderColor setStroke];
    
    CGFloat lineWidth = 2.0;
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius - lineWidth / 2.0 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    borderPath.lineWidth = lineWidth;
    [borderPath stroke];
    
    //2.绘制内圆
    [self.baseTintColor setFill];
    radius -= lineWidth;
    UIBezierPath *basePath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    [basePath fill];
    
    //3.绘制进度
    [self.progressTintColor set];
    
    CGFloat start = -M_PI_2;
    CGFloat end = start + self.progress * M_PI * 2;
    
    UIBezierPath *progressPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:start endAngle:end clockwise:YES];
    
    [progressPath addLineToPoint:center];
    [progressPath closePath];
    [progressPath fill];
    
}


@end
