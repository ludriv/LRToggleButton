//
//  LRToogleButton.m
//  LRToggleButton
//
//  Created by Ludovic Riviere on 20/03/2015.
//  Copyright (c) 2015 ludovicriviere.com. All rights reserved.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 Ludovic Riviere (http://ludovicriviere.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "LRToogleButton.h"

@interface LRToogleButton () <UIScrollViewDelegate>

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;

@end

@implementation LRToogleButton {
    UIScrollView    * _scrollView;
    UIImageView     * _offImageView;
    UIImageView     * _onImageView;
    
    CGSize            _thumbSize;
    BOOL              _on;
}

- (instancetype)init {
    if (self = [super init]) {
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
        [self addSubview:_scrollView];
        
        _offImageView = [[UIImageView alloc] init];
        _offImageView.userInteractionEnabled = YES;
        [_scrollView addSubview:_offImageView];
        
        _onImageView = [[UIImageView alloc] init];
        _onImageView.userInteractionEnabled = YES;
        [_scrollView addSubview:_onImageView];
        
        _thumbSize = CGSizeZero;
        _on = NO;
        
        _autoAnimationDuration = 0.3;
        
        return self;
    }
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [super initWithFrame:frame];
}

- (instancetype)initWithOnImage:(UIImage *)onImage offImage:(UIImage *)offImage {
    if (self = [self init]) {
        
        if (onImage.size.width != offImage.size.width) {
            NSLog(@"** Warning ** Off image width and on image width must be equal!");
        }
        
        _offImageView.image = offImage;
        [_offImageView sizeToFit];
        
        _onImageView.image = onImage;
        [_onImageView sizeToFit];
        
        CGFloat thumbWidth = MAX(onImage.size.height, offImage.size.height);
        _thumbSize = CGSizeMake(thumbWidth, thumbWidth);
        
        CGRect onFrame = _onImageView.frame;
        onFrame.origin.x = CGRectGetWidth(_offImageView.frame) - thumbWidth;
        _onImageView.frame = onFrame;
        
        self.clipsToBounds = YES;
        self.layer.cornerRadius = _thumbSize.height / 2;
        
        CGFloat contentWidth = CGRectGetMaxX(_onImageView.frame);
        _scrollView.contentSize = CGSizeMake(contentWidth, thumbWidth);
        
        _scrollView.contentOffset = CGPointZero;
        
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 1;
        
        self.frame = CGRectMake(0, 0, CGRectGetWidth(_offImageView.frame), thumbWidth);
        _scrollView.frame = self.bounds;
        
        return self;
    }
    return nil;
}

- (BOOL)isOn {
    return _on;
}

- (void)setOn:(BOOL)on animated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:_autoAnimationDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            CGFloat toX = !on ? 0 : _scrollView.contentSize.width - CGRectGetWidth(_scrollView.bounds);
            _scrollView.contentOffset = CGPointMake(toX, 0);
            
        } completion:^(BOOL finished) {
            _on = on;
        }];
    } else {
        
        CGFloat toX = !on ? 0 : _scrollView.contentSize.width - CGRectGetWidth(_scrollView.bounds);
        _scrollView.contentOffset = CGPointMake(toX, 0);
        _on = on;
    }
}

#pragma mark - Setters

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    _scrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, CGRectGetHeight(self.bounds));
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([scrollView isEqual:_scrollView] && !decelerate) {
        CGFloat midX = (CGRectGetWidth(_scrollView.bounds) - _thumbSize.width) / 2;
        CGFloat offsetX = _scrollView.contentOffset.x;
        
        [UIView animateWithDuration:_autoAnimationDuration animations:^{
            
            if (offsetX < midX) {
                _scrollView.contentOffset = CGPointZero;
            } else {
                _scrollView.contentOffset = CGPointMake(CGRectGetMinX(_onImageView.frame), 0);
            }
            
        } completion:nil];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_scrollView]) {
        CGFloat endX = CGRectGetWidth(_scrollView.bounds) - _thumbSize.width;
        CGFloat offsetX = _scrollView.contentOffset.x;
        
        float ratio = offsetX / endX;
        float offOpacity = 1 - ratio;
        float onOpacity = ratio;
        
        _offImageView.layer.opacity = offOpacity;
        _onImageView.layer.opacity = onOpacity;
    }
}

@end
