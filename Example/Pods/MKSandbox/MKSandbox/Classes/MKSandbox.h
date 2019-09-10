//
//  PAirSandbox.h
//  AirSandboxDemo
//
//  Created by zhangyu on 2017/1/30.
//  Copyright © 2017年 zhangyu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 item类型
 
 - MKFileItemUp: 上一层
 - MKFileItemDirectory: 文件夹
 - MKFileItemFile: 文件
 */
typedef NS_ENUM(NSUInteger, MKFileItemType) {
    MKFileItemUp = 0,
    MKFileItemDirectory,
    MKFileItemFile,
};

@class MKSandbox;
@class MKFileItem;

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



@interface MKFileItem : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, assign) MKFileItemType type;
@end



@interface MKSandbox : NSObject

+ (instancetype)sharedInstance;

/**
 显示沙盒
 */
- (void)showSandboxBrowser;

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
