//
//  TM_WeixinTool.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/7/10.
//

#import <Foundation/Foundation.h>
#import <WXApi.h>

/** 微信AppID **/
#define kWeixin_AppID           @"wxdf3f5bb8f29eb08f"
/** 微信AppSecret **/
#define kWeixin_AppSecret       @"D5V3UU3U0N79HF8UT4H3BB6F90JR5ET4"
/** UniversalLink */
#define kWeixin_UniversalLink   @"https://www.tianmulife.com/"

typedef enum : NSInteger {
    TM_WeixinToolTypeDefault = -1,
    TM_WeixinToolTypeLogin,         // 微信登录
    TM_WeixinToolTypePay,           // 微信支付
} TM_WeixinToolType;

NS_ASSUME_NONNULL_BEGIN
typedef void(^TMWeixinToolCompleteBlock)(NSString *json);

@interface TM_WeixinTool : NSObject<WXApiDelegate>

+ (instancetype)shareWeixinToolManager;

- (void)tm_weixinToolWithType:(TM_WeixinToolType)type;


#pragma mark - 回调函数
- (void)tm_weixinOnReq:(BaseReq *)req;
- (void)tm_weixinOnResp:(id)resp;
@end

NS_ASSUME_NONNULL_END
