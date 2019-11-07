//
//  LEOSampleViewController.m
//  LEOBubbleTabBar
//
//  Created by cc on 2019/11/6.
//  Copyright © 2019 cc. All rights reserved.
//

#import "LEOSampleViewController.h"

@interface LEOSampleViewController ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation LEOSampleViewController

#pragma mark - Override
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleLabel.text = self.tabBarItem.title;
    [self.view addSubview: self.titleLabel];
    
    [[self.titleLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor] setActive:YES];
    [[self.titleLabel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor] setActive:YES];
    [self.view setNeedsLayout];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.view.backgroundColor == [UIColor whiteColor] ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
}

#pragma mark - Public
- (void)inverseColor {
    self.view.backgroundColor = self.titleLabel.textColor;
    self.titleLabel.textColor = [UIColor whiteColor];
}

#pragma mark - Setter & Getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithRed:0.1579992771 green:0.1818160117 blue:0.5072338581 alpha:1];
        _titleLabel.font = [UIFont boldSystemFontOfSize:55.0];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _titleLabel;
}

@end
