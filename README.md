# MKSandbox

[![CI Status](https://img.shields.io/travis/KrisMarko/MKSandbox.svg?style=flat)](https://travis-ci.org/KrisMarko/MKSandbox)
[![Version](https://img.shields.io/cocoapods/v/MKSandbox.svg?style=flat)](https://cocoapods.org/pods/MKSandbox)
[![License](https://img.shields.io/cocoapods/l/MKSandbox.svg?style=flat)](https://cocoapods.org/pods/MKSandbox)
[![Platform](https://img.shields.io/cocoapods/p/MKSandbox.svg?style=flat)](https://cocoapods.org/pods/MKSandbox)

## Example
See `Example/MKSandbox.xcworkspace`
To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

1.MKSandbox is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MKSandbox'
```
2.Run `pod install`or`pod update`
3.Import <MKSandbox/MKSandbox.h>

## Usage
1.引入头文件`Import <MKSandbox/MKSandbox.h>`
2.调用以下方法即可见App沙盒。
```objectivec
[[MKSandbox sharedInstance] showSandboxBrowser];
```
如果有需要在点击文件夹以及文件时拿到回调进行自己的处理则可实现以下代理。返回YES时走内部处理，进入文件夹或者分享文件。返回NO则内部不会处理本次点击。
```objectivec
@protocol MKSandboxDelegate <NSObject>

@optional
/**
 点击的Item

 @param sandbox MKSandbox对象
 @param clickItem 点击的item
 @return 是否走内部处理，比如自动跳转到文件夹，调起系统分享。
 */
- (BOOL)sandbox:(MKSandbox *)sandbox didClickItem:(MKFileItem *)clickItem;

@end
```
添加代理对象，可多代理，内部弱引用不会造成内存问题。
```objectivec
@interface MKSandbox : NSObject

/**
 添加代理

 @param delegate 代理对象
 */
- (void)addMKSandboxDelegate:(id <MKSandboxDelegate>)delegate;

/**
 移除代理
 
 @param delegate 代理对象
 */
- (void)removeMKSandboxDelegate:(id <MKSandboxDelegate>)delegate;

@end
```
演示Gif
![enter image description here](https://raw.githubusercontent.com/KrisMarko/MKSandbox/master/MDSource/demo.gif)
## Author

KrisMarko, winzhyu@yeah.net

## License

MKSandbox is available under the MIT license. See the LICENSE file for more info.
