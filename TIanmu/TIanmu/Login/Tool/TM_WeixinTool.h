//
//  TM_WeixinTool.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/7/10.
//

#import <Foundation/Foundation.h>
#import <WXApi.h>

#define kWeixin_AccessTokenPath @"kWeixin_AccessTokenPath"
/** 微信AppID **/
#define kWeixin_AppID           @"wxdf3f5bb8f29eb08f"
/** 微信AppSecret **/
#define kWeixin_AppSecret       @"a62eaf35ef9f80d61a44a82b9dafca7a"
/** UniversalLink */
#define kWeixin_UniversalLink   @"https://tianmulife.com/"

#define KWeixin_AccessToken_Key     @"access_token"
#define KWeixin_RefreshToken_Key    @"refresh_token"
#define KWeixin_Expiresin_Key       @"expires_in"

typedef enum : NSInteger {
    TM_WeixinToolTypeDefault = -1,
    TM_WeixinToolTypeLogin,         // 微信登录
    TM_WeixinToolTypePay,           // 微信支付
} TM_WeixinToolType;

NS_ASSUME_NONNULL_BEGIN
typedef void(^TMWeixinToolCompleteBlock)(NSDictionary *param);

@interface TM_WeixinTool : NSObject<WXApiDelegate>
@property (nonatomic, copy) NSString *wxAccessToken;                    // 微信获取token
/* 回调 */
@property (copy, nonatomic) TMWeixinToolCompleteBlock completeBlock;

+ (instancetype)shareWeixinToolManager;
// 使用微信登录或支付功能
- (void)tm_weixinToolWithType:(TM_WeixinToolType)type data:(NSDictionary *)data completeBlock:(TMWeixinToolCompleteBlock)completeBlock;
// 检查 accessToken 是否过期
- (BOOL)tm_checkIsExpiresin;
// 判断是否 accessToken 登录过 登过过就刷新  accessToken
- (void)tm_checkAccessToken:(void(^)(BOOL isLogin, NSString *accessToken))block;
// 清除缓存
- (void)clearData;
#pragma mark - 回调函数
- (void)tm_weixinOnReq:(BaseReq *)req;
- (void)tm_weixinOnResp:(id)resp;
@end

NS_ASSUME_NONNULL_END
