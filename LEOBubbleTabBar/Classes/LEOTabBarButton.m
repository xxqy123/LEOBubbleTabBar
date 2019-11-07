//
//  LEOTabBarButton.m
//  LEOBubbleTabBar
//
//  Created by cc on 2019/11/5.
//  Copyright © 2019 cc. All rights reserved.
//

#import "LEOTabBarButton.h"

static CGFloat const kBgHeight = 42.0;

@implementation LEOTabBarItem
@end

@interface LEOTabBarButton ()
@property (nonatomic, strong) UIImageView *tabImageView;
@property (nonatomic, strong) UILabel *tabLabel;
@property (nonatomic, strong) UIView *tabBg;

@property (nonatomic, strong) NSLayoutConstraint *csFoldedBgTrailing;
@property (nonatomic, strong) NSLayoutConstraint *csUnfoldedBgTrailing;
@property (nonatomic, strong) NSLayoutConstraint *csFoldedLblLeading;
@property (nonatomic, strong) NSLayoutConstraint *csUnfoldedLblLeading;
@end

@implementation LEOTabBarButton
{
    BOOL _rightToLeft;
    BOOL _isSelected;
}

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self p_configSubviews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self p_configSubviews];
    }
    return self;
}

- (instancetype)initWithTabBarItem:(UITabBarItem *)item {
    if (self = [super initWithFrame:CGRectZero]) {
        self.item = item;
        self.tabImageView = [[UIImageView alloc] initWithImage:item.image];
        [self p_configSubviews];
    }
    return self;
}

#pragma mark - Override
- (void)layoutSubviews {
    [super layoutSubviews];
    self.tabBg.layer.cornerRadius = self.tabBg.bounds.size.height * 0.5;
}

#pragma mark - Public
- (void)setSelected:(BOOL)selected animationDuration:(NSTimeInterval)duration {
    _isSelected = selected;
    [UIView transitionWithView:self.tabImageView duration:0.05 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.tabImageView.image = [self p_currentImage];
    } completion:nil];
    if (selected) {
        [self p_unfoldWithDuration:duration];
    } else {
        [self p_foldWithDuration:duration];
    }
}

#pragma mark - Private
- (void)p_configSubviews {
    self.tabImageView.contentMode = UIViewContentModeCenter;
    self.tabImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tabLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.tabLabel.font = [UIFont systemFontOfSize:14.0];
    self.tabLabel.adjustsFontSizeToFitWidth = YES;
    self.tabBg.translatesAutoresizingMaskIntoConstraints = NO;
    self.tabBg.userInteractionEnabled = NO;
    [self.tabImageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.tabImageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [self addSubview:self.tabBg];
    [self addSubview:self.tabLabel];
    [self addSubview:self.tabImageView];
    
    [[self.tabBg.leadingAnchor constraintEqualToAnchor:self.leadingAnchor] setActive:YES];
    [[self.tabBg.centerYAnchor constraintEqualToAnchor:self.centerYAnchor] setActive:YES];
    [[self.tabBg.trailingAnchor constraintEqualToAnchor:self.trailingAnchor] setActive:YES];
    [[self.tabBg.heightAnchor constraintEqualToConstant:kBgHeight] setActive:YES];
    
    if (_rightToLeft) {
        [[self.tabImageView.trailingAnchor constraintEqualToAnchor:self.tabBg.trailingAnchor constant:-kBgHeight * 0.5] setActive:YES];
        [[self.tabImageView.centerYAnchor constraintEqualToAnchor:self.tabBg.centerYAnchor] setActive:YES];
        [[self.tabLabel.centerYAnchor constraintEqualToAnchor:self.tabBg.centerYAnchor] setActive:YES];
        self.csFoldedLblLeading = [self.tabLabel.leadingAnchor constraintEqualToAnchor:self.tabBg.trailingAnchor];
        self.csUnfoldedLblLeading = [self.tabLabel.leadingAnchor constraintEqualToAnchor:self.tabBg.leadingAnchor constant:kBgHeight * 0.25];
        self.csFoldedBgTrailing = [self.tabImageView.trailingAnchor constraintEqualToAnchor:self.tabBg.leadingAnchor constant:kBgHeight * 0.5];
        self.csUnfoldedBgTrailing = [self.tabLabel.trailingAnchor constraintEqualToAnchor:self.tabImageView.leadingAnchor constant:-kBgHeight * 0.5];
    } else {
        [[self.tabImageView.leadingAnchor constraintEqualToAnchor:self.tabBg.leadingAnchor constant:kBgHeight * 0.5] setActive:YES];
        [[self.tabImageView.centerYAnchor constraintEqualToAnchor:self.tabBg.centerYAnchor] setActive:YES];
        [[self.tabLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor] setActive:YES];
        self.csFoldedLblLeading = [self.tabLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor];
        self.csUnfoldedLblLeading = [self.tabLabel.leadingAnchor constraintEqualToAnchor:self.tabImageView.trailingAnchor constant:kBgHeight * 0.25];
        self.csFoldedBgTrailing = [self.tabImageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-kBgHeight * 0.5];
        self.csUnfoldedBgTrailing = [self.tabLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-kBgHeight * 0.5];
    }
    
    [self p_foldWithDuration:0];
    [self setNeedsLayout];
}

- (void)p_foldWithDuration:(CGFloat)duration {
    for (NSLayoutConstraint *constraint in [self p_unfoldedConstraints]) {
        [constraint setActive:NO];
    }
    for (NSLayoutConstraint *constraint in [self p_foldedConstraints]) {
        [constraint setActive:YES];
    }
    [UIView animateWithDuration:duration animations:^{
        self.tabBg.alpha = 0.0;
    }];
    
    [UIView animateWithDuration:duration * 0.4 animations:^{
        self.tabLabel.alpha = 0.0;
    }];
    
    [UIView transitionWithView:self.tabImageView duration:duration options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.tabImageView.tintColor = [UIColor blackColor];
    } completion:nil];
}

- (void)p_unfoldWithDuration:(CGFloat)duration {
    for (NSLayoutConstraint *constraint in [self p_foldedConstraints]) {
        [constraint setActive:NO];
    }
    for (NSLayoutConstraint *constraint in [self p_unfoldedConstraints]) {
        [constraint setActive:YES];
    }
    [UIView animateWithDuration:duration animations:^{
        self.tabBg.alpha = 1.0;
    }];
    
    [UIView animateWithDuration:duration * 0.5 delay:duration * 0.5 options:UIViewAnimationOptionTransitionNone animations:^{
        self.tabLabel.alpha = 1.0;
    } completion:nil];
    
    [UIView transitionWithView:self.tabImageView duration:duration options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.tabImageView.tintColor = self.tintColor;
    } completion:nil];
}

- (NSArray <NSLayoutConstraint *> *)p_foldedConstraints {
    return @[self.csFoldedLblLeading, self.csFoldedBgTrailing];
}

- (NSArray <NSLayoutConstraint *> *)p_unfoldedConstraints {
    return @[self.csUnfoldedLblLeading, self.csUnfoldedBgTrailing];
}

- (UIImage *)p_currentImage {
    UIImage *image;
    if (_isSelected) {
        image = self.item.selectedImage ? : self.item.image;
    } else {
        image = self.item.image;
    }
    return image.renderingMode == UIImageRenderingModeAutomatic ? [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] : image;
}
#pragma mark - Setter & Getter
- (BOOL)isSelected {
    return _isSelected;
}

- (void)setSelected:(BOOL)selected {
    if (selected != _isSelected) return;
    [super setSelected:selected];
}

- (void)setItem:(UITabBarItem *)item {
    _item = item;
    self.tabImageView.image = [self p_currentImage];
    self.tabLabel.text = item.title;
    if ([item isKindOfClass:[LEOTabBarItem class]]) {
        LEOTabBarItem *customItem = (LEOTabBarItem *)item;
        if (customItem.tintColor) {
            self.tintColor = customItem.tintColor;
        }
        _rightToLeft = customItem.rightToLeft;
    }
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    if (_isSelected) {
        self.tabImageView.tintColor = tintColor;
    }
    self.tabLabel.textColor = tintColor;
    self.tabBg.backgroundColor = [tintColor colorWithAlphaComponent:0.2];
}

- (UILabel *)tabLabel {
    if (!_tabLabel) {
        _tabLabel = [[UILabel alloc] init];
    }
    return _tabLabel;
}

- (UIView *)tabBg {
    if (!_tabBg) {
        _tabBg = [[UIView alloc] init];
    }
    return _tabBg;
}

- (UIImageView *)tabImageView {
    if (!_tabImageView) {
        _tabImageView = [[UIImageView alloc] init];
    }
    return _tabImageView;
}
@end
