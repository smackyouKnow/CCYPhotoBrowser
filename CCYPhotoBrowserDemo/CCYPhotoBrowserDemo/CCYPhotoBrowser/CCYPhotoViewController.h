//
//  CCYPhotoViewController.h
//  CCYPhotoBrowserDemo
//
//  Created by godyu on 2018/5/4.
//  Copyright © 2018年 godyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCYPhotoViewController : UIViewController

+ (instancetype)viewerWithUrlString:(NSString *)urlString photoIndex:(NSInteger)photoIndex placeholder:(UIImage *)placeholder;

@end
