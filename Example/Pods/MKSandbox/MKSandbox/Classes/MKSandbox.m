//
//  PAirSandbox.m
//  AirSandboxDemo
//
//  Created by zhangyu on 2017/1/30.
//  Copyright © 2017年 zhangyu. All rights reserved.
//

#import "MKSandbox.h"
#import <UIKit/UIKit.h>

#define MKThemeColor [UIColor blackColor]
#define MKWindowPadding 10



@implementation MKFileItem

@end



@interface MKSandboxItemCell : UITableViewCell

@property (nonatomic, strong) UILabel *lbName;

@end

@implementation MKSandboxItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        int cellWidth = [UIScreen mainScreen].bounds.size.width - 2*MKWindowPadding;
        
        self.lbName = [UILabel new];
        self.lbName.backgroundColor = [UIColor clearColor];
        self.lbName.font = [UIFont systemFontOfSize:13];
        self.lbName.textAlignment = NSTextAlignmentLeft;
        self.lbName.frame = CGRectMake(10, 30, cellWidth - 20, 15);
        self.lbName.textColor = [UIColor blackColor];
        [self addSubview:self.lbName];
        
        UIView *line = [UIView new];
        line.backgroundColor = MKThemeColor;
        line.frame = CGRectMake(10, 47, cellWidth - 20, 1);
        [self addSubview:line];
    }
    return self;
}

- (void)renderWithItem:(MKFileItem *)item {
//    MKFileItemUp = 0,
//    MKFileItemDirectory,
//    MKFileItemFile,
    
    NSString *text;
    switch (item.type) {
        case MKFileItemUp: {
            text = @"🔙..";
        }
            break;
        case MKFileItemDirectory: {
            text = [NSString stringWithFormat:@"%@ %@", @"📁", item.name];
        }
            break;
        case MKFileItemFile: {
            text = [NSString stringWithFormat:@"%@ %@", @"📄", item.name];
        }
            break;

        default:
            text = @"nothing!!!!!!";
            break;
    }
    self.lbName.text = text;
}

@end



@interface MKSandboxViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *btnClose;

@property (nonatomic, strong) NSArray *items;

@property (nonatomic, copy) NSString *rootPath;

@property (nonatomic, copy) BOOL (^itemClickBlock)(MKFileItem *item);

@end

@implementation MKSandboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareCtrl];
    [self loadPath:nil];
}

- (void)prepareCtrl {
    self.view.backgroundColor = [UIColor whiteColor];

    self.btnClose = [UIButton new];
    [self.view addSubview:self.btnClose];
    self.btnClose.backgroundColor = MKThemeColor;
    [self.btnClose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnClose setTitle:@"关闭" forState:UIControlStateNormal];
    [self.btnClose addTarget:self action:@selector(btnCloseClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView = [UITableView new];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.items = @[];
    self.rootPath = NSHomeDirectory();
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    NSInteger viewWidth = [UIScreen mainScreen].bounds.size.width - 2 * MKWindowPadding;
    NSInteger closeWidth = 60;
    NSInteger closeHeight = 28;
    
    self.btnClose.frame = CGRectMake(viewWidth - closeWidth - 4, 4, closeWidth, closeHeight);
    
    CGRect tableFrame = self.view.frame;
    tableFrame.origin.y += (closeHeight + 4);
    tableFrame.size.height -= (closeHeight + 4);
    self.tableView.frame = tableFrame;
}

- (void)btnCloseClick {
    self.view.window.hidden = YES;
}

- (void)loadPath:(NSString*)filePath {
    NSMutableArray *files = @[].mutableCopy;
    
    NSFileManager *fm = [[NSFileManager alloc] init];
    
    NSString *targetPath = filePath;
    if (targetPath.length == 0 || [targetPath isEqualToString:self.rootPath]) {
        targetPath = self.rootPath;
    } else {
        MKFileItem* file = [MKFileItem new];
//        file.name = @"🔙..";
        file.name = @"..";
        file.type = MKFileItemUp;
        file.path = filePath;
        [files addObject:file];
    }
    
    NSError *err = nil;
    NSArray *paths = [fm contentsOfDirectoryAtPath:targetPath error:&err];
    for (NSString *path in paths) {
        
        if ([[path lastPathComponent] hasPrefix:@"."]) {
            continue;
        }

        BOOL isDir = false;
        NSString *fullPath = [targetPath stringByAppendingPathComponent:path];
        [fm fileExistsAtPath:fullPath isDirectory:&isDir];
        
        MKFileItem *file = [MKFileItem new];
        file.path = fullPath;
        file.name = path;
        if (isDir) {
            file.type = MKFileItemDirectory;
//            file.name = [NSString stringWithFormat:@"%@ %@", @"📁", path];
        } else {
            file.type = MKFileItemFile;
//            file.name = [NSString stringWithFormat:@"%@ %@", @"📄", path];
        }
        [files addObject:file];
    }
    self.items = files.copy;
    [self.tableView reloadData];
}

#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > self.items.count-1) {
        return [UITableViewCell new];
    }
    
    MKFileItem *item = [self.items objectAtIndex:indexPath.row];
    static NSString *cellIdentifier = @"MKSandboxItemCell";
    MKSandboxItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[MKSandboxItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell renderWithItem:item];
    return cell;
}

#pragma mark -- UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > self.items.count-1) {return;}
    
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    
    MKFileItem *item = [self.items objectAtIndex:indexPath.row];
    
    BOOL handle = YES;
    if (self.itemClickBlock) {handle = self.itemClickBlock(item);}
    if (handle == NO) {return;}
    if (item.type == MKFileItemUp) {
        [self loadPath:[item.path stringByDeletingLastPathComponent]];
    } else if(item.type == MKFileItemFile) {
        [self sharePath:item.path];
    } else if(item.type == MKFileItemDirectory) {
        [self loadPath:item.path];
    }
}

- (void)sharePath:(NSString*)path
{
    NSArray *objectsToShare = @[[NSURL fileURLWithPath:path]];
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    NSArray *activities = @[UIActivityTypePostToTwitter,
                            UIActivityTypePostToFacebook,
                            UIActivityTypePostToWeibo,
                            UIActivityTypeMessage,
                            UIActivityTypeMail,
                            UIActivityTypePrint,
                            UIActivityTypeCopyToPasteboard,
                            UIActivityTypeAssignToContact,
                            UIActivityTypeSaveToCameraRoll,
                            UIActivityTypeAddToReadingList,
                            UIActivityTypePostToFlickr,
                            UIActivityTypePostToVimeo,
                            UIActivityTypePostToTencentWeibo];
    controller.excludedActivityTypes = activities;
    
    if ([(NSString *)[UIDevice currentDevice].model hasPrefix:@"iPad"]) {
        controller.popoverPresentationController.sourceView = self.view;
        controller.popoverPresentationController.sourceRect = CGRectMake([UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.height, 10, 10);
    }
    [self presentViewController:controller animated:YES completion:nil];
}

@end



@interface MKSandbox ()

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) MKSandboxViewController *ctrl;

@property (nonatomic, strong) NSPointerArray *delegates;

@end

@implementation MKSandbox

#pragma mark -- life
+ (instancetype)sharedInstance {
    static MKSandbox *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [MKSandbox new];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.delegates = [NSPointerArray weakObjectsPointerArray];
    }
    return self;
}

#pragma mark -- private
- (void)clearDelegatesNull {
    [self.delegates addPointer:NULL];
    [self.delegates compact];
}

#pragma mark -- public
- (void)showSandboxBrowser {
    if (self.window == nil) {
        self.window = [UIWindow new];
        CGRect keyFrame = [UIScreen mainScreen].bounds;
        keyFrame.origin.y += 64;
        keyFrame.size.height -= 64;
        self.window.frame = CGRectInset(keyFrame, MKWindowPadding, MKWindowPadding);
        self.window.backgroundColor = [UIColor whiteColor];
        self.window.layer.borderColor = MKThemeColor.CGColor;
        self.window.layer.borderWidth = 1.0;
        self.window.windowLevel = UIWindowLevelAlert;
        
        self.ctrl = [MKSandboxViewController new];
        __weak MKSandbox *weak_self = self;
        self.ctrl.itemClickBlock = ^BOOL(MKFileItem *item) {
            __block BOOL returnV = YES;
            [weak_self.delegates.allObjects enumerateObjectsUsingBlock:^(id <MKSandboxDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                __strong MKSandbox *strong_self = weak_self;
                if ([obj respondsToSelector:@selector(sandbox:didClickItem:)]) {
                    BOOL needHandle = [obj sandbox:strong_self didClickItem:item];
                    if (returnV != NO) {
                        returnV = needHandle;
                    }
                }
            }];
            return returnV;
        };
        self.window.rootViewController = self.ctrl;
    }
    self.window.hidden = NO;
}

- (void)addMKSandboxDelegate:(id <MKSandboxDelegate>)delegate {
    [self clearDelegatesNull];
    [self.delegates addPointer:(__bridge void *)delegate];
}

- (void)removeMKSandboxDelegate:(id <MKSandboxDelegate>)delegate {
    [self.delegates.allObjects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (delegate == obj) {
            [self.delegates removePointerAtIndex:idx];
            *stop = YES;
        }
    }];
    [self clearDelegatesNull];
}

@end
