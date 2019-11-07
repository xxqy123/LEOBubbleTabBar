//
//  LEOTabBar.m
//  LEOBubbleTabBar
//
//  Created by cc on 2019/11/6.
//  Copyright © 2019 cc. All rights reserved.
//

#import "LEOTabBar.h"
#import "LEOTabBarButton.h"

@interface LEOTabBar ()
@property (nonatomic, strong) NSMutableArray<LEOTabBarButton *> *buttons;
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) NSLayoutConstraint *csContainerBottom;
@property (nonatomic, strong) NSMutableArray<UILayoutGuide *> *spaceLayoutGuides;
@end

@implementation LEOTabBar

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self p_configure];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self p_configure];
    }
    return self;
}

#pragma mark - Override
- (void)safeAreaInsetsDidChange {
    if (@available(iOS 11, *)) {
        [super safeAreaInsetsDidChange];
        self.csContainerBottom.constant = -self.safeAreaInsets.bottom;
    }
}

#pragma mark - Public
- (void)selectItemAtIndex:(NSUInteger)index animated:(BOOL)animated {
    if (index >= self.buttons.count) return;
    [self.buttons enumerateObjectsUsingBlock:^(LEOTabBarButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != index) {
            [obj setSelected:NO animationDuration:animated ? self.animationDuration : 0];
        } else {
            [obj setSelected:YES animationDuration:animated ? self.animationDuration : 0];
        }
    }];
    if (animated) {
        [UIView animateWithDuration:self.animationDuration animations:^{
            [self.container layoutIfNeeded];
        }];
    } else {
        [self.container layoutIfNeeded];
    }
}

#pragma mark - Private
- (void)p_configure {
    self.backgroundColor = [UIColor whiteColor];
    self.translucent = NO;
    self.barTintColor = [UIColor whiteColor];
    self.tintColor = [UIColor colorWithRed:0.1176470588 green:0.1176470588 blue:0.431372549 alpha:1];
    [self addSubview:self.container];
    [[self.container.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:10] setActive:YES];
    [[self.container.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-10] setActive:YES];
    [[self.container.topAnchor constraintEqualToAnchor:self.topAnchor constant:1] setActive:YES];
    CGFloat bottomOffset = 0;
    if (@available(iOS 11, *)) {
        bottomOffset = self.safeAreaInsets.bottom;
    }
    self.csContainerBottom = [self.container.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-bottomOffset];
    [self.csContainerBottom setActive:YES];
}

- (void)p_reloadViews {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [obj removeFromSuperview];
        }
    }];
    [self.buttons enumerateObjectsUsingBlock:^(LEOTabBarButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];

    [self.spaceLayoutGuides enumerateObjectsUsingBlock:^(UILayoutGuide * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.container removeLayoutGuide:obj];
    }];
    
    [self.buttons removeAllObjects];
    [self.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LEOTabBarButton *button = [self p_buttonWithItem:obj];
        [self.buttons addObject:button];
    }];
    
    [self.buttons enumerateObjectsUsingBlock:^(LEOTabBarButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.container addSubview:obj];
        [[obj.topAnchor constraintEqualToAnchor:self.container.topAnchor] setActive:YES];
        [[obj.bottomAnchor constraintEqualToAnchor:self.container.bottomAnchor] setActive:YES];
    }];
    
    if (self.buttons.count > 0) {
        if (@available(iOS 11, *)) {
            [[[self.buttons firstObject].leadingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.leadingAnchor constant:10.0] setActive:YES];
            [[[self.buttons lastObject].trailingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.trailingAnchor constant:-10.0] setActive:YES];
        } else {
            [[[self.buttons firstObject].leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:10] setActive:YES];
            [[[self.buttons lastObject].trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-10.0] setActive:YES];
        }
    }
    
    [self.spaceLayoutGuides removeAllObjects];
    NSInteger viewCount = self.buttons.count - 1;
    for (NSInteger i=0; i<viewCount; i++) {
        UILayoutGuide *layoutGuide = [[UILayoutGuide alloc] init];
        [self.container addLayoutGuide:layoutGuide];
        [self.spaceLayoutGuides addObject:layoutGuide];
        LEOTabBarButton *prevBtn = self.buttons[i];
        LEOTabBarButton *nextBtn = self.buttons[i+1];
        [[layoutGuide.leadingAnchor constraintEqualToAnchor:prevBtn.trailingAnchor] setActive:YES];
        [[layoutGuide.trailingAnchor constraintEqualToAnchor:nextBtn.leadingAnchor] setActive:YES];
    }
    for (NSInteger i=1; i<self.spaceLayoutGuides.count; i++) {
        [[self.spaceLayoutGuides[i].widthAnchor constraintEqualToAnchor:self.spaceLayoutGuides[0].widthAnchor multiplier:1.0] setActive:YES];
    }
    [self layoutIfNeeded];
}

- (LEOTabBarButton *)p_buttonWithItem:(UITabBarItem *)item {
    LEOTabBarButton *button = [[LEOTabBarButton alloc] initWithTabBarItem:item];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    if (![button.item isKindOfClass:[LEOTabBarItem class]] || ((LEOTabBarItem *)button.item).tintColor == nil) {
        button.tintColor = self.tintColor;
    }
    [button addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    if (self.selectedItem && item == self.selectedItem) {
        [button setSelected:YES animationDuration:0];
    }
    return button;
}

#pragma mark - Actions
- (void)btnPressed:(LEOTabBarButton *)button {
    NSUInteger index = [self.buttons indexOfObject:button];
    if (index == NSNotFound || index > self.items.count - 1) return;
    UITabBarItem *item = self.items[index];
    [self.buttons enumerateObjectsUsingBlock:^(LEOTabBarButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj != button) {
            [obj setSelected:NO animationDuration:self.animationDuration];
        }
    }];
    [button setSelected:YES animationDuration:self.animationDuration];
    [UIView animateWithDuration:self.animationDuration animations:^{
        [self.container layoutIfNeeded];
    }];
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectItem:)]) {
        [self.delegate tabBar:self didSelectItem:item];
    }
}

#pragma mark - Setter & Getter
- (void)setSelectedItem:(UITabBarItem *)selectedItem {
    if (!selectedItem) {
        for (LEOTabBarButton *button in self.buttons) {
            [button setSelected:NO animationDuration:0];
        }
        return;
    }
    NSUInteger index = [self.items indexOfObject:selectedItem];
    if (index == NSNotFound) return;
    [self selectItemAtIndex:index animated:NO];
    
    [super setSelectedItem:selectedItem];
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    for (LEOTabBarButton *button in self.buttons) {
        if (![button.item isKindOfClass:[LEOTabBarItem class]] || ((LEOTabBarItem *)button.item).tintColor == nil) {
            button.tintColor = tintColor;
        }
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    self.barTintColor = backgroundColor;
}

- (void)setItems:(NSArray<UITabBarItem *> *)items {
    [super setItems:items];
    [self p_reloadViews];
}

- (void)setItems:(NSArray<UITabBarItem *> *)items animated:(BOOL)animated {
    [super setItems:items animated:animated];
    [self p_reloadViews];
}

- (NSTimeInterval)animationDuration {
    return 0.3;
}

- (UIView *)container {
    if (!_container) {
        _container = [[UIView alloc] init];
        _container.translatesAutoresizingMaskIntoConstraints = NO;
        _container.backgroundColor = [UIColor clearColor];
    }
    return _container;
}

- (NSMutableArray<LEOTabBarButton *> *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (NSMutableArray<UILayoutGuide *> *)spaceLayoutGuides {
    if (!_spaceLayoutGuides) {
        _spaceLayoutGuides = [[NSMutableArray alloc] init];
    }
    return _spaceLayoutGuides;
}
@end
