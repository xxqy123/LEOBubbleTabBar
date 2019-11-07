//
//  ViewController.m
//  LEOBubbleTabBar
//
//  Created by cc on 2019/11/5.
//  Copyright © 2019 cc. All rights reserved.
//

#import "ViewController.h"
#import "LEOSampleViewController.h"
#import <LEOBubbleTabBar/LEOBubbleTabBar.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)fromCodeBtnClicked:(id)sender {
    LEOSampleViewController *eventVC = [[LEOSampleViewController alloc] init];
    eventVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Events" image:[UIImage imageNamed:@"dashboard"] tag:0];

    LEOSampleViewController *searchVC = [[LEOSampleViewController alloc] init];
    searchVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Search" image:[UIImage imageNamed:@"clock"] tag:0];
    [searchVC inverseColor];
    
    LEOSampleViewController *activityVC = [[LEOSampleViewController alloc] init];
    activityVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Activity" image:[UIImage imageNamed:@"folder"] tag:0];
    
    LEOSampleViewController *settingVC = [[LEOSampleViewController alloc] init];
    settingVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:[UIImage imageNamed:@"menu"] tag:0];
    settingVC.tabBarItem.selectedImage = [UIImage imageNamed:@"clock"];
    [settingVC inverseColor];
    LEOBubbleTabBarController *tabBarController = [[LEOBubbleTabBarController alloc] init];
    tabBarController.viewControllers = @[eventVC, searchVC, activityVC, settingVC];
    tabBarController.tabBar.tintColor = [UIColor colorWithRed:0.1579992771 green:0.1818160117 blue:0.5072338581 alpha:1];
    [self.navigationController pushViewController:tabBarController animated:YES];
}

@end
