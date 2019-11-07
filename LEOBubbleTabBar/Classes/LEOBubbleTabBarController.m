//
//  LEOBubbleTabBarController.m
//  LEOBubbleTabBar
//
//  Created by cc on 2019/11/6.
//  Copyright © 2019 cc. All rights reserved.
//

#import "LEOBubbleTabBarController.h"
#import "LEOTabBar.h"

@interface LEOBubbleTabBarController ()
@property (nonatomic, assign) CGFloat barHeight;
@property (nonatomic, assign) BOOL shouldSelectOnTabBar;
@end

@implementation LEOBubbleTabBarController

@synthesize barHeight = _barHeight;

#pragma mark - Life Cycle
- (instancetype)init {
    if (self = [super init]) {
        self.shouldSelectOnTabBar = YES;
        self.barHeight = 49.0;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        self.barHeight = 49.0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    LEOTabBar *tabBar = [[LEOTabBar alloc] init];
    [self setValue:tabBar forKey:@"tabBar"];
}

#pragma mark - Override
- (void)setSelectedViewController:(__kindof UIViewController *)selectedViewController {
    if (!self.shouldSelectOnTabBar || !selectedViewController) {
        self.shouldSelectOnTabBar = YES;
        [super setSelectedViewController:selectedViewController];
        return;
    }
    LEOTabBar *tabBar = (LEOTabBar *)self.tabBar;
    NSUInteger index = [self.viewControllers indexOfObject:selectedViewController];
    if (![tabBar isKindOfClass:[LEOTabBar class]] || index == NSNotFound) return;
    [tabBar selectItemAtIndex:index animated:NO];
    [super setSelectedViewController:selectedViewController];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (!self.shouldSelectOnTabBar) {
        self.shouldSelectOnTabBar = YES;
        [super setSelectedIndex:selectedIndex];
        return;
    }
    LEOTabBar *tabBar = (LEOTabBar *)self.tabBar;
    if (![tabBar isKindOfClass:[LEOTabBar class]]) return;
    [tabBar selectItemAtIndex:selectedIndex animated:NO];
    [super setSelectedIndex:selectedIndex];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self p_updateTabBarFrame];
}

- (void)viewSafeAreaInsetsDidChange {
    if (@available(iOS 11, *)) {
        [super viewSafeAreaInsetsDidChange];
    }
    [self p_updateTabBarFrame];
}

#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSUInteger index = [self.tabBar.items indexOfObject:item];
    if (index == NSNotFound || index >= self.viewControllers.count) return;
    UIViewController *controller = self.viewControllers[index];
    self.shouldSelectOnTabBar = NO;
    self.selectedIndex = index;
    if ([self.delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)]) {
        [self.delegate tabBarController:self didSelectViewController:controller];
    }
}

#pragma mark - Private
- (void)p_updateTabBarFrame {
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = self.barHeight;
    tabFrame.origin.y = self.view.frame.size.height - self.barHeight;
    self.tabBar.frame = tabFrame;
    [self.tabBar setNeedsLayout];
}

#pragma mark - Setter & Getter
- (void)setBarHeight:(CGFloat)barHeight {
    _barHeight = barHeight;
    [self p_updateTabBarFrame];
}

- (CGFloat)barHeight {
    if (@available(iOS 11, *)) {
        return _barHeight + self.view.safeAreaInsets.bottom;
    } else {
        return _barHeight;
    }
}

@end
