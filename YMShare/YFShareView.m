//
//  YFShareView.m
//  百思不得姐
//
//  Created by 创客金融 on 2017/7/18.
//  Copyright © 2017年 创客金融. All rights reserved.
//

#import "YFShareView.h"
#import <UMSocialCore/UMSocialCore.h>

#define YFisEqual(string_h,Dic_m) ((![Dic_m objectForKey:string_h])?0:(([[Dic_m objectForKey:string_h] isEqual:@""])?0:1))

// 分享的标题（文本分享的文本内容）
#define UMS_Title @"UMS_Title"
// 分享的描述
#define UMS_Description @"UMS_Description"
// 分享的缩略图
#define UMS_ThumImage @"UMS_ThumImage"

// 图片
// 分享的图片
#define UMS_ShareImage @"UMS_ShareImage"

// 分享的网页地址(// 低版本微信网页链接"微信小程序")
#define UMS_WebpageUrl @"UMS_WebpageUrl"

// 音乐
// 音乐网页的url地址
#define UMS_MusicUrl @"UMS_musicUrl"
// 音乐lowband网页的url地址
#define UMS_MusicLowBandUrl @"UMS_MusicLowBandUrl"
// 音乐数据url地址
#define UMS_MusicDataUrl @"UMS_MusicDataUrl"
// 音乐lowband数据url地址
#define UMS_MusicLowBandDataUrl @"UMS_MusicLowBandDataUrl"

// 视频
// 视频网页的url
#define UMS_VideoUrl @"UMS_VideoUrl"
// 视频lowband网页的url
#define UMS_VideoLowBandUrl @"UMS_VideoLowBandUrl"
// 视频数据流url
#define UMS_VideoStreamUrl @"UMS_VideoStreamUrl"
// 视频lowband数据流url
#define UMS_VideoLowBandStreamUrl @"UMS_VideoLowBandStreamUrl"

// 表情数据(NSData类型)
#define UMS_EmotionData @"UMS_EmotionData"

// 文件
// 文件后缀名
#define UMS_FileExtension @"UMS_FileExtension"
// 文件真实数据内容
#define UMS_FileData @"UMS_FileData"

// 微信小程序
// 低版本微信网页链接
// 小程序username
#define UMS_UserName @"UMS_UserName"
// 小程序页面的路径
#define UMS_Path @"UMS_Path"


@interface YFShareView ()
@property (nonatomic, strong) UIViewController *currentVC;
@property (nonatomic, assign) UMS_SHARE_TYPE type;
@property (nonatomic, strong) NSDictionary *shareDict;
@end

@implementation YFShareView

- (instancetype)initWithVC:(UIViewController *)vc type:(UMS_SHARE_TYPE)type shareContent:(NSDictionary *)shareDict{
    self = [super init];
    if (self) {
        self.currentVC = vc;
        self.type = type;
        self.shareDict = [shareDict mutableCopy];
        
        NSArray *titleArr = @[@"新浪微博",@"QQ好友", @"QQ空间",@"微信朋友圈",@"微信好友"];
        NSArray *imgArr = @[@"umsocial_sina.png",@"umsocial_qq.png", @"umsocial_qzone.png",@"umsocial_wechat_timeline.png",@"umsocial_wechat.png"];
        // 从mainBundle中找到UMSocialSDKResources.bundle
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"UMSocialSDKResources" ofType:@"bundle"];
        NSBundle *sourceBundle = [NSBundle bundleWithPath:bundlePath];
        NSMutableArray *imageArrM = [NSMutableArray array];
        for (NSString *imageName in imgArr) {
            // 从UMSocialSDKResources.bundle中的default文件夹中取出图片
            NSString *path = [sourceBundle pathForResource:imageName ofType:nil inDirectory:@"UMSocialPlatformTheme/default"];
            UIImage *img = [UIImage imageWithContentsOfFile:path];
            [imageArrM addObject:img];
        }
        
        CGSize screenSize = [UIApplication sharedApplication].keyWindow.bounds.size;
        self.frame = [UIApplication sharedApplication].keyWindow.bounds;
        self.tag = 9987654;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];

        // 触屏销毁
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeShare)];
        [self addGestureRecognizer:tap];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(15, screenSize.height, screenSize.width - 30, 300)];
        bottomView.backgroundColor = [UIColor clearColor];
        [self addSubview:bottomView];
        
        UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bottomView.frame.size.width, 245)];
        shareView.backgroundColor = [UIColor whiteColor];
        [bottomView addSubview:shareView];
        shareView.layer.cornerRadius = 6;
        shareView.layer.masksToBounds = YES;
        
        UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        cancleBtn.frame = CGRectMake(0, bottomView.frame.size.height - 40, bottomView.frame.size.width, 40);
        cancleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancleBtn addTarget:self action:@selector(closeShare) forControlEvents:UIControlEventTouchUpInside];
        cancleBtn.backgroundColor = [UIColor whiteColor];
        [bottomView addSubview:cancleBtn];
        cancleBtn.layer.cornerRadius = 4;
        cancleBtn.layer.masksToBounds = YES;
        
        [UIView animateWithDuration:0.25 animations:^{
            bottomView.frame = CGRectMake(15, screenSize.height - 300 - 15, screenSize.width - 30, 300);
            
        }];
        
        CGFloat viewWidth = 80;
        CGFloat viewHeight = 80;
        CGFloat horizontalMargin = (shareView.frame.size.width - viewWidth * 3) / 4;
        CGFloat verticalMargin = (shareView.frame.size.height - viewHeight * 2) / 3;
        for (int i = 0; i < imgArr.count; i++){
            UIView *caseView = [[UIView alloc] initWithFrame:CGRectMake(horizontalMargin + ((i%3) * (viewWidth + horizontalMargin)), verticalMargin + (verticalMargin + viewHeight) * (i/3), viewWidth, viewHeight)];
            [shareView addSubview:caseView];
            
            CGAffineTransform trans = CGAffineTransformTranslate(caseView.transform, 0, 400);
            caseView.transform = trans;
            [UIView animateWithDuration:0.25 delay:i/10.0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                caseView.transform = CGAffineTransformIdentity;
                
            } completion:^(BOOL finished) {
                CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
                animation.keyPath = @"transform.translation.y";
                animation.values = @[@0,@10,@-10,@0];
                animation.repeatCount = 1;
                animation.duration = 0.15;
                [caseView.layer addAnimation:animation forKey:nil];
                
            }];
            
            UIImageView *imagV = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth - 65) * 0.5, 0, 65, 65)];
            imagV.image = imageArrM[i];
            [caseView addSubview:imagV];
            
            UILabel *nameLB = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imagV.frame), viewWidth, 15)];
            nameLB.font = [UIFont systemFontOfSize:15];
            nameLB.textAlignment = NSTextAlignmentCenter;
            nameLB.text = titleArr[i];
            [caseView addSubview:nameLB];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.frame = caseView.bounds;
            btn.tag = 300 + i;
            [btn addTarget:self action:@selector(allSharBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.backgroundColor = [UIColor clearColor];
            [caseView addSubview:btn];
            
        }
        
    }
    return self;
}

- (void)allSharBtnClick:(UIButton *)sender{
    UMSocialPlatformType plateformType;
    switch (sender.tag) {
        case 300:
            
            // 新浪微博
            plateformType = UMSocialPlatformType_Sina;
            break;
        case 301:
            // qq好友
            plateformType = UMSocialPlatformType_QQ;
            break;
            
        case 302:
            // qq空间
            plateformType = UMSocialPlatformType_Qzone;
            break;
            
        case 303:
            // 微信朋友圈
            plateformType = UMSocialPlatformType_WechatTimeLine;
            break;
            
        case 304:
            // 微信好友
            plateformType = UMSocialPlatformType_WechatSession;
            break;
            
        default:
#warning plateformType不能为空
            return;
            break;
    }
    
    if (self.shareDict && ![self.shareDict isEqual:@""]) {
        if (!YFisEqual(UMS_Title, self.shareDict)) {
#warning 标题不能为空
            return;
        }
        if (!YFisEqual(UMS_Description, self.shareDict)) {
#warning 描述不能为空
            return;
        }
        [self shareWithPlePlatformType:plateformType Title:[NSString stringWithFormat:@"%@", self.shareDict[UMS_Title]] description:[NSString stringWithFormat:@"%@", self.shareDict[UMS_Description]] thumImage:[NSString stringWithFormat:@"%@", self.shareDict[UMS_ThumImage]]];
    }
    
}


- (void)shareWithPlePlatformType:(UMSocialPlatformType)platformType Title:(NSString *)title description:(NSString *)description thumImage:(id)thumImage{
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    switch (self.type) {
        case UMS_SHARE_TYPE_TEXT:
        {
            if (YFisEqual(UMS_Title, self.shareDict)) {
                //设置文本
                messageObject.text = [NSString stringWithFormat:@"%@", self.shareDict[UMS_Title]];
            }else{
#warning <#message#>
                return;
            }
            
        }
            break;
        case UMS_SHARE_TYPE_IMAGE: case UMS_SHARE_TYPE_IMAGE_URL:
        {
            //创建图片内容对象
            UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];

            /** 图片内容 （可以是UIImage类对象，也可以是NSdata类对象，也可以是图片链接imageUrl NSString类对象）
             *  图片大小根据各个平台限制而定
             */
            if (YFisEqual(UMS_ShareImage, self.shareDict)) {
                [shareObject setShareImage:[NSString stringWithFormat:@"%@", self.shareDict[UMS_ShareImage]]];
            }else{
                
                return;
            }
            
            
            // 设置Pinterest参数
            //    if (platformType == UMSocialPlatformType_Pinterest) {
            //        [self setPinterstInfo:messageObject];
            //    }
            
            // 设置Kakao参数
            //    if (platformType == UMSocialPlatformType_KakaoTalk) {
            //        messageObject.moreInfo = @{@"permission" : @1}; // @1 = KOStoryPermissionPublic
            //    }
            
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareObject;
            
        }
            break;
        case UMS_SHARE_TYPE_TEXT_IMAGE:
        {
            //设置文本
            messageObject.text = title;
            
            //创建图片内容对象
            UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
            if (YFisEqual(UMS_ShareImage, self.shareDict)) {
                [shareObject setShareImage:[NSString stringWithFormat:@"%@", self.shareDict[UMS_ShareImage]]];
            }else{
                
                return;
            }
            
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareObject;
            
        }
            break;
        case UMS_SHARE_TYPE_WEB_LINK:
        {
            //创建网页内容对象
            UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:description thumImage:thumImage];
            if (YFisEqual(UMS_WebpageUrl, self.shareDict)) {
                //设置网页地址
                shareObject.webpageUrl = [NSString stringWithFormat:@"%@", self.shareDict[UMS_WebpageUrl]];
            }else{
                
                return;
            }
            
            
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareObject;
            
        }
            break;
        case UMS_SHARE_TYPE_MUSIC_LINK: case UMS_SHARE_TYPE_MUSIC:
        {
            //创建音乐内容对象
            UMShareMusicObject *shareObject = [UMShareMusicObject shareObjectWithTitle:title descr:description thumImage:thumImage];
            if (YFisEqual(UMS_MusicUrl, self.shareDict) && YFisEqual(UMS_MusicDataUrl, self.shareDict)) {
                //设置音乐网页播放地址
                shareObject.musicUrl = [NSString stringWithFormat:@"%@", self.shareDict[UMS_MusicUrl]];
                shareObject.musicDataUrl = [NSString stringWithFormat:@"%@", self.shareDict[UMS_MusicDataUrl]];
            }else{
                
                return;
            }
            
            
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareObject;
            

        }
            break;
        case UMS_SHARE_TYPE_VIDEO_LINK: case UMS_SHARE_TYPE_VIDEO:
        {
            
            UMShareVideoObject *shareObject = [UMShareVideoObject shareObjectWithTitle:title descr:description thumImage:thumImage];
            if (YFisEqual(UMS_VideoUrl, self.shareDict)) {
                //设置视频网页播放地址
                shareObject.videoUrl = [NSString stringWithFormat:@"%@", self.shareDict[UMS_VideoUrl]];
            }else{
                
                return;
            }
            
            
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareObject;
            
        }
            break;

        case UMS_SHARE_TYPE_EMOTION:
        {
            // 分享GIF图片
            UMShareEmotionObject *shareObject = [UMShareEmotionObject shareObjectWithTitle:title descr:description thumImage:thumImage];
            
            if (YFisEqual(UMS_EmotionData, self.shareDict)) {
                shareObject.emotionData = self.shareDict[UMS_EmotionData];
            }else{
                
                return;
            }
            
            messageObject.shareObject = shareObject;
            
        }
            break;
        case UMS_SHARE_TYPE_FILE:
        {
            UMShareFileObject *shareObject = [UMShareFileObject shareObjectWithTitle:title descr:description thumImage:thumImage];
            
            if (YFisEqual(UMS_FileExtension, self.shareDict) && YFisEqual(UMS_FileData, self.shareDict)) {
                shareObject.fileData = self.shareDict[UMS_FileData];
                shareObject.fileExtension = [NSString stringWithFormat:@"%@", self.shareDict[UMS_FileExtension]];
            }else{
                
                return;
            }
            
            messageObject.shareObject = shareObject;
            
        }
            break;
        case UMS_SHARE_TYPE_MINI_PROGRAM:
        {
            UMShareMiniProgramObject *shareObject = [UMShareMiniProgramObject shareObjectWithTitle:title descr:description thumImage:thumImage];
            if (YFisEqual(UMS_WebpageUrl, self.shareDict) && YFisEqual(UMS_UserName, self.shareDict) && YFisEqual(UMS_Path, self.shareDict)) {
                shareObject.webpageUrl = [NSString stringWithFormat:@"%@", self.shareDict[UMS_WebpageUrl]];
                shareObject.userName = [NSString stringWithFormat:@"%@", self.shareDict[UMS_UserName]];
                shareObject.path = [NSString stringWithFormat:@"%@", self.shareDict[UMS_Path]];
            }else{
                
                return;
            }
            
            messageObject.shareObject = shareObject;
            
        }
            break;
        default:
            break;
    }
    
    [self shareWithPlePlatformType:platformType messageObject:messageObject currentViewController:self.currentVC];
}

// 分享接口
- (void)shareWithPlePlatformType:(UMSocialPlatformType)platformType messageObject:(UMSocialMessageObject *)messageObject currentViewController:(id)currentViewController{
         
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:currentViewController completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************分享错误： %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];


}

- (void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"分享成功"];
        
    }else{
        NSMutableString *str = [NSMutableString string];
        if (error.userInfo) {
            for (NSString *key in error.userInfo) {
                [str appendFormat:@"%@ = %@\n", key, error.userInfo[key]];
            }
        }
        if (error) {
            result = [NSString stringWithFormat:@"分享错误，错误码: %d\n%@",(int)error.code, str];
            
        }else{
            result = [NSString stringWithFormat:@"分享失败"];
        }
    }

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"分享" message:result preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.currentVC dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:okAction];
    [self.currentVC presentViewController:alert animated:YES completion:nil];
}

- (NSString *)errorCodeWithKey:(UMSocialPlatformErrorType )key{
    switch (key) {
        case UMSocialPlatformErrorType_Unknow:
            return @"未知错误";
            break;
        case UMSocialPlatformErrorType_NotSupport:
            return @"不支持（url scheme 没配置，或者没有配置-ObjC， 或则SDK版本不支持或则客户端版本不支持";
            break;
        case UMSocialPlatformErrorType_AuthorizeFailed:
            return @"授权失败";
            break;
        case UMSocialPlatformErrorType_ShareFailed:
            return @"分享失败";
            break;
        case UMSocialPlatformErrorType_RequestForUserProfileFailed:
            return @"请求用户信息失败";
            break;
        case UMSocialPlatformErrorType_ShareDataNil:
            return @"分享内容为空";
            break;
        case UMSocialPlatformErrorType_ShareDataTypeIllegal:
            return @"分享内容不支持";
            break;
        case UMSocialPlatformErrorType_CheckUrlSchemaFail:
            return @"schemaurl fail";
            break;
        case UMSocialPlatformErrorType_NotInstall:
            return @"应用未安装";
            break;
        case UMSocialPlatformErrorType_Cancel:
            return @"您已取消分享";
            break;
        case UMSocialPlatformErrorType_NotNetWork:
            return @"网络异常";
            break;
        case UMSocialPlatformErrorType_SourceError:
            return @"第三方错误";
            break;
        case UMSocialPlatformErrorType_ProtocolNotOverride:
            return @"对应的  UMSocialPlatformProvider的方法没有实现";
            break;
        default:
            return nil;
            break;
    }
    
}

- (void)show{
    [self closeShare];
    [self.currentVC.view addSubview:self];
}

- (void)closeShare{
    
    UIView *view = [self.currentVC.view viewWithTag:9987654];
    [view removeFromSuperview];
    
}

@end
