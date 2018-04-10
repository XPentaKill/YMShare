//
//  YFShareView.h
//  百思不得姐
//
//  Created by 创客金融 on 2017/7/18.
//  Copyright © 2017年 创客金融. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UMS_SHARE_TYPE)
{
    UMS_SHARE_TYPE_TEXT, // 纯文本
    UMS_SHARE_TYPE_IMAGE, // 本地图片
    UMS_SHARE_TYPE_IMAGE_URL, // HTTPS网络图片
    UMS_SHARE_TYPE_TEXT_IMAGE, // 文本 + 图片
    UMS_SHARE_TYPE_WEB_LINK, // 网页链接
    UMS_SHARE_TYPE_MUSIC_LINK,// 音乐链接
    UMS_SHARE_TYPE_MUSIC, // 本地音乐
    UMS_SHARE_TYPE_VIDEO_LINK,// 视频链接
    UMS_SHARE_TYPE_VIDEO, // 本地视频
    UMS_SHARE_TYPE_EMOTION,// 表情（如GIF表情）
    UMS_SHARE_TYPE_FILE,// 文件
    UMS_SHARE_TYPE_MINI_PROGRAM// 微信小程序
};

@interface YFShareView : UIView

- (instancetype)initWithVC:(UIViewController *)vc type:(UMS_SHARE_TYPE)type shareContent:(NSDictionary *)shareDict;

- (void)show;
@end
