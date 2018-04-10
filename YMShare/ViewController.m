//
//  ViewController.m
//  YMShare
//
//  Created by 创客金融 on 2018/4/9.
//  Copyright © 2018年 创客金融. All rights reserved.
//

#import "ViewController.h"
#import "YFShareView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)shareBtnClick:(id)sender {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"分享的标题" forKey:@"UMS_Title"];
    [dict setObject:@"分享的描述" forKey:@"UMS_Description"];
    [dict setObject:@"分享的缩略图" forKey:@"UMS_ThumImage"];
    [dict setObject:@"http://www.baidu.com" forKey:@"UMS_WebpageUrl"];
    YFShareView *shareView = [[YFShareView alloc] initWithVC:self type:UMS_SHARE_TYPE_WEB_LINK shareContent:dict];
    [shareView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
