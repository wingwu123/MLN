//
//  MLNBindModelViewController.m
//  LuaNative
//
//  Created by Dai Dongpeng on 2020/3/17.
//  Copyright © 2020 MoMo. All rights reserved.
//

#import "MLNBindModelViewController.h"
#import "MLNUIKit.h"
#import "MLNDataBindModel.h"

@interface MLNBindModelViewController ()
@property (nonatomic, strong) MLNDataBindModel *model;
@end

@implementation MLNBindModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createController];
    [self testChangeModel:1];
}

- (void)createController {
    NSString *demoName = @"layout_DataBindView.lua";
    NSString *path = [[NSBundle mainBundle] pathForResource:@"inner_demo" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    MLNUIViewController *viewController = [[MLNUIViewController alloc] initWithEntryFileName:demoName bundle:bundle];
    
    self.model = [MLNDataBindModel testModel];
    
    self.model.mlnui_watch(@"name", ^(id  _Nonnull oldValue, id  _Nonnull newValue, id observedObject) {
        NSLog(@"name has changed from  %@ to %@",oldValue, newValue);
    });
    
    [viewController bindData:self.model forKey:@"userData"];
    [viewController mlnui_addToSuperViewController:self frame:self.view.bounds];
}

- (void)testChangeModel:(int)cnt {
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) self = weakSelf;
        if (!self) {
            return ;
        }
        self.model.hideIcon = !self.model.hideIcon;
        self.model.title = [NSString stringWithFormat:@"title %d",cnt];
        self.model.name = [NSString stringWithFormat:@"name %d",cnt];
        [self testChangeModel:cnt + 1];
    });
}



@end
