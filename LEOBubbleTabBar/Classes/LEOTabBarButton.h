//
//  LEOTabBarButton.h
//  LEOBubbleTabBar
//
//  Created by cc on 2019/11/5.
//  Copyright © 2019 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LEOTabBarItem : UITabBarItem
@property (nonatomic, strong) IBInspectable UIColor *tintColor;
@property (nonatomic, assign) IBInspectable BOOL rightToLeft;
@end

@interface LEOTabBarButton : UIControl
@property (nonatomic, strong) UITabBarItem *item;
- (instancetype)initWithTabBarItem:(UITabBarItem *)item;
- (void)setSelected:(BOOL)selected animationDuration:(NSTimeInterval)duration;
@end

NS_ASSUME_NONNULL_END
