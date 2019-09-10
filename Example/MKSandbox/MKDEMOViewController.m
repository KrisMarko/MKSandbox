//
//  MKDEMOViewController.m
//  MKSandbox
//
//  Created by KrisMarko on 09/10/2019.
//  Copyright (c) 2019 KrisMarko. All rights reserved.
//

#import "MKDEMOViewController.h"
#import <MKSandbox/MKSandbox.h>

@interface MKDEMOViewController () <MKSandboxDelegate>

@end

@implementation MKDEMOViewController

#pragma mark -- life
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *testButton = [UIButton buttonWithType:UIButtonTypeCustom];
    testButton.frame = CGRectMake(20, 80, 50, 50);
    testButton.backgroundColor = [UIColor redColor];
    [testButton addTarget:self action:@selector(testButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton];
    
    [[MKSandbox sharedInstance] addMKSandboxDelegate:self];
}

#pragma mark -- private
- (void)testButtonClick {
    [[MKSandbox sharedInstance] showSandboxBrowser];
}

#pragma mark -- MKSandboxDelegate
- (BOOL)sandbox:(MKSandbox *)sandbox didClickItem:(MKFileItem *)clickItem {
    NSLog(@"%@",clickItem.path);
    if ([clickItem.name isEqualToString:@"tmp"]) {
        return NO;
    }
    return YES;
}

@end
