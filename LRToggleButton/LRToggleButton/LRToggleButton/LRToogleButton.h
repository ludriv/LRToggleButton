//
//  LRToogleButton.h
//  LRToggleButton
//
//  Created by Ludovic Riviere on 20/03/2015.
//  Copyright (c) 2015 ludovicriviere.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface LRToogleButton : UIView

@property (nonatomic) UIColor   * borderColor;
@property (nonatomic) CGFloat     borderWidth;

@property (nonatomic) NSTimeInterval autoAnimationDuration;

- (instancetype)initWithOnImage:(UIImage *)onImage offImage:(UIImage *)offImage;

- (BOOL)isOn;
- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end
