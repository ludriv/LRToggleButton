//
//  ViewController.m
//  LRToggleButton
//
//  Created by Ludovic Riviere on 20/03/2015.
//  Copyright (c) 2015 ludovicriviere.com. All rights reserved.
//

#import "ViewController.h"
#import "LRToogleButton.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LRToogleButton * toggleButton = [[LRToogleButton alloc] initWithOnImage:[UIImage imageNamed:@"image_on"] offImage:[UIImage imageNamed:@"image_off"]];
    
    toggleButton.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    
    [self.view addSubview:toggleButton];
}

@end
