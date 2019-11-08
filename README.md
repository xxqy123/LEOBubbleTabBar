# LEOBubbleTabBar
[bubble-icon-tabbar](https://github.com/Cuberto/bubble-icon-tabbar#requirements) using Objective-C

a custom TabBar inherit from UITabBar with bubble animation when selecting

![](https://github.com/xxqy123/LEOBubbleTabBar/blob/master/Screenshots/BubbleTabBar.gif?raw=true)

## Requirements
* iOS 9.0+
* Xcode 10+

## Example
To run the example project, clone the repo, and run ``ExampleApp`` scheme from LEOBubbleTabBar.xcodeproj

## Installation
TO DO

## Usage
### With StoryBoard
1. Create a new UITabBarController in your storyboard or nib.
2. Set the class of the UITabBarController to ``LEOBubbleTabBarController`` in your Storyboard or nib.
3. Add a custom image icon and title for UITabBarItem of each child ViewContrroller
4. If you need cutom color for each tab set ``LEOTabBarItem`` class to tab bar items and use tintColor property
### Without StoryBoard
1. Import ``LEOBubbleTabBar``
2. Instantiate ``LEOBubbleTabBarController``
3. Add some child conrollers and don't forget to set their tabBar items with title and image
4. If you need cutom color for each tab use ``LEOTabBarItem`` instead of UITabBarItem set tintColor property
## License
LEOBubbleTabBar is available under MIT license. See the LICENSE file for more info.
