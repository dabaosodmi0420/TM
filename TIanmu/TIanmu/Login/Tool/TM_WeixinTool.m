//
//  TM_WeixinTool.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/7/10.
//

#import "TM_WeixinTool.h"
#import <AFNetworking/AFNetworking.h>

// 通过 code 获取 access_token
#define TM_weixinApi_login_url          @"https://api.weixin.qq.com/sns/oauth2/access_token"
// 刷新 access_token 有效期
#define TM_weixinApi_refreshToken_url   @"https://api.weixin.qq.com/sns/oauth2/refresh_token"
// 刷新 access_token 有效期
#define TM_weixinApi_getUserInfo_url @"https://api.weixin.qq.com/sns/userinfo"

#pragma mark - 微信网络请求类
#define TM_AFTIMEOUTINTERVAL 15
#define TM_AFGET @"GET"
#define TM_AFPOST @"POST"
typedef void (^TMAPISuccessBlock)(id _Nullable respondObject);
typedef void (^TMAPIFailureBlock)(NSError * _Nullable error);

@interface TM_WeixinApi : NSObject
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
/** 微信登录 **/
- (void)jt_getWeixinAccessTokenWithParams:(NSDictionary *)params
                                  success:(TMAPISuccessBlock)successBlock
                                  failure:(TMAPIFailureBlock)failureBlock;

@end
@implementation TM_WeixinApi

+ (instancetype)sharedNetworkingAPI{
    
    static TM_WeixinApi *shareNetworkingAPI = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareNetworkingAPI = [[TM_WeixinApi alloc] init];
    });
    return shareNetworkingAPI;
}
- (AFHTTPSessionManager *)sessionManager{
    @synchronized(self) {
        if (!_sessionManager) {
            _sessionManager = [AFHTTPSessionManager manager];
            _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
            _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
            // 设置请求接口回来时支持什么类型的数组
            _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html",@"text/plain", nil];
            _sessionManager.requestSerializer.timeoutInterval = TM_AFTIMEOUTINTERVAL;
        }
        return _sessionManager;
    }
}
- (void)sendRequestPath:(NSString *)path
                 params:(NSDictionary *)params
                headers:(NSDictionary *)headers
                 method:(NSString *)method
                   asyn:(BOOL)asyn
                success:(TMAPISuccessBlock)successBlock
                failure:(TMAPIFailureBlock)failureBlock{
    if ([method isEqualToString:TM_AFGET]){
        [self sendGETRequestWithPath:path parameters:params success:successBlock failure:failureBlock];
    }else if ([method isEqualToString:TM_AFPOST]){
        [self sendPOSTRequestWithPath:path parameters:params success:successBlock failure:failureBlock];
    }
    
}
- (void)sendGETRequestWithPath:(NSString *)path
                    parameters:(NSDictionary *)params
                       success:(TMAPISuccessBlock)successBlock
                       failure:(TMAPIFailureBlock)failureBlock{
    [self.sessionManager GET:path parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failureBlock && error){
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:@"当前网络不可用，请检查网络设置" forKey:@"NSLocalizedDescriptionKey"];
            error = [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
            failureBlock(error);
        }
    }];
}
- (void)sendPOSTRequestWithPath:(NSString *)path
                     parameters:(NSDictionary *)params
                        success:(TMAPISuccessBlock)successBlock
                        failure:(TMAPIFailureBlock)failureBlock{
    [self.sessionManager POST:path parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failureBlock && error){
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:@"当前网络不可用，请检查网络设置" forKey:@"NSLocalizedDescriptionKey"];
            error = [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
            failureBlock(error);
        }
    }];
}
- (void)sendRequestPath:(NSString *)path
                 params:(NSDictionary *)params
                headers:(NSDictionary *)headers
                 method:(NSString *)method
                success:(TMAPISuccessBlock)successBlock
                failure:(TMAPIFailureBlock)failureBlock{
    NSLog(@"\nrequestURL:%@",path);
    [self sendRequestPath:path params:params headers:headers method:method asyn:YES success:successBlock failure:failureBlock ];
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

#pragma mark - 微信API
/** 微信登录获取  AccessToken  **/
- (void)tm_getWeixinAccessTokenWithParams:(NSDictionary *)params
                                  success:(TMAPISuccessBlock)successBlock
                                  failure:(TMAPIFailureBlock)failureBlock{
    [self sendRequestPath:TM_weixinApi_login_url
                   params:params
                  headers:nil
                   method:TM_AFGET
                  success:successBlock
                  failure:failureBlock];
}
/** 微信登录获取  刷新 AccessToken  **/
- (void)tm_refreshWeixinAccessTokenWithParams:(NSDictionary *)params
                                      success:(TMAPISuccessBlock)successBlock
                                      failure:(TMAPIFailureBlock)failureBlock{
    [self sendRequestPath:TM_weixinApi_refreshToken_url
                   params:params
                  headers:nil
                   method:TM_AFGET
                  success:successBlock
                  failure:failureBlock];
}
/** 微信获取用户信息 **/
- (void)tm_getUserInfoWithParams:(NSDictionary *)params
                         success:(TMAPISuccessBlock)successBlock
                         failure:(TMAPIFailureBlock)failureBlock{
    [self sendRequestPath:TM_weixinApi_getUserInfo_url
                   params:params
                  headers:nil
                   method:TM_AFGET
                  success:successBlock
                  failure:failureBlock];
}

@end


#pragma mark - 微信工具类

@interface TM_WeixinTool()

/* type */
@property (assign, nonatomic) TM_WeixinToolType type;
/* 传入数据 */
@property (strong, nonatomic) NSDictionary      *data;


/* access_token */
@property (strong, nonatomic) NSString          *access_token;
/* expires_in */
@property (assign, nonatomic) int               expires_in;
/* refresh_token */
@property (strong, nonatomic) NSString          *refresh_token;

@end

@implementation TM_WeixinTool


#pragma mark - public
+ (instancetype)shareWeixinToolManager {
    static TM_WeixinTool *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        manager = [TM_WeixinTool new];
    });
    return manager;
}

- (void)tm_weixinToolWithType:(TM_WeixinToolType)type data:(NSDictionary *)data completeBlock:(nonnull TMWeixinToolCompleteBlock)completeBlock{
    
    if ([WXApi isWXAppInstalled]) {
        _type = type;
        _data = data;
        _completeBlock = completeBlock;
        switch (type) {
            case TM_WeixinToolTypeLogin: {
                [self tm_weixinLoginActivity];
            }
                break;
            case  TM_WeixinToolTypePay: {
                [self tm_weixinPayActvity];
            }
                break;
            default:{
                
            }
                break;
        }
    }else {
        TM_ShowToast([UIApplication sharedApplication].keyWindow, @"请先安装微信app");
    }
}

- (BOOL)tm_checkIsExpiresin {
    NSDictionary *weixinParam = [[NSUserDefaults standardUserDefaults] valueForKeyPath:kWeixin_AccessTokenPath];
    if (weixinParam) {
        NSInteger expires_in  = [[NSString stringWithFormat:@"%@", weixinParam[KWeixin_Expiresin_Key]] integerValue];
        NSInteger curTime     = [self getTimeStamp];
        if (expires_in > curTime) {
            return NO;
        }else {
            return YES;
        }
    }
    return YES;
}

- (void)tm_checkAccessToken:(void (^)(BOOL, NSString *))block {
    NSDictionary *weixinParam = [[NSUserDefaults standardUserDefaults] valueForKeyPath:kWeixin_AccessTokenPath];
    if (weixinParam) {
        if ([self tm_checkIsExpiresin]) {
            NSString *access_token = weixinParam[KWeixin_AccessToken_Key];
            self.wxAccessToken = access_token;
            if (self.wxAccessToken && self.wxAccessToken.length > 0) {
                if(block){
                    block(YES, self.wxAccessToken);
                }
            }else {
                if(block){
                    block(NO, nil);
                }
            }
        }else {
            NSString *refresh_token     = weixinParam[KWeixin_RefreshToken_Key];
            [self refreshAccessTokenWithRefreshToken:refresh_token cmpBlock:^void(void) {
                if (self.wxAccessToken && self.wxAccessToken.length > 0) {
                    if(block){
                        block(YES, self.wxAccessToken);
                    }
                }else {
                    if(block){
                        block(NO, nil);
                    }
                }
            }];
        }
    }else {
        if(block){
            block(NO, nil);
        }
    }
}

#pragma mark - Activity
// 微信登录
- (void)tm_weixinLoginActivity {
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo"; // 只能填 snsapi_userinfo
    req.state = @"112233";
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req completion:^(BOOL success) {
        NSLog(@"%@",success ? @"成功" : @"失败");
    }];
}
// 微信支付
- (void)tm_weixinPayActvity {
    PayReq *request = [[PayReq alloc] init];

    request.partnerId       = self.data[@"partnerid"];
    request.prepayId        = self.data[@"prepay_id"];
    request.package         = self.data[@"Package"];
    request.nonceStr        = self.data[@"noncestr"];
    request.timeStamp       = [self.data[@"timestamp"] intValue];
    request.sign            = @"md5";//self.data[@"sign"];
    request.openID          = kWeixin_AppID;
    [WXApi sendReq:request completion:^(BOOL success) {
        NSLog(@"%@",success ? @"成功" : @"失败");
    }];
}

// 由于 access_token 有效期（目前为 2 个小时）较短， 使用 refresh_token 刷新 access_token 有效期
- (void)refreshAccessTokenWithRefreshToken:(NSString *)refresh_token cmpBlock:(void (^)(void))cmp {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"appid"]            = kWeixin_AppID;
    params[@"grant_type"]       = @"refresh_token";
    params[@"refresh_token"]    = refresh_token;
    
    [[TM_WeixinApi sharedNetworkingAPI] tm_refreshWeixinAccessTokenWithParams:params success:^(id  _Nullable respondObject) {
        NSDictionary *dic = (NSDictionary *)respondObject;
        NSString *access_token      = dic[@"access_token"];
        if(access_token != nil && access_token.length != 0) {
            [self saveWXData:dic];
            self.wxAccessToken = access_token;
            if(cmp) {
                cmp();
            }
        }else {
            if(cmp) {
                cmp();
            }
        }
    } failure:^(NSError * _Nullable error) {
        if(cmp) {
            cmp();
        }
    }];
}
// 获取 access_token
- (void)getAccess_tokenWithCode:(NSString *)code {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"appid"]    = kWeixin_AppID;
    params[@"secret"]   = kWeixin_AppSecret;
    params[@"grant_type"]   = @"authorization_code";
    params[@"code"]     = code;
    
    [[TM_WeixinApi sharedNetworkingAPI] tm_getWeixinAccessTokenWithParams:params success:^(id  _Nullable respondObject) {
        NSDictionary *dic = (NSDictionary *)respondObject;
        NSString *access_token      = dic[@"access_token"];
        if(access_token != nil && access_token.length != 0) {
            [self saveWXData:dic];
            [self getUserInfoWithAccessToken:access_token code:code];
        }
    } failure:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
    }];
}
// 获取微信用户信息
- (void)getUserInfoWithAccessToken:(NSString *)accessToken code:(NSString *)code{
    [[TM_WeixinApi sharedNetworkingAPI] tm_getUserInfoWithParams:@{@"access_token" : accessToken, @"openid" : kWeixin_AppID} success:^(id  _Nullable respondObject) {
        if (respondObject && [respondObject isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *dic =  [NSMutableDictionary dictionaryWithDictionary:respondObject];
            dic[KWeixin_AccessToken_Key] = accessToken;
            dic[@"code"] = code;
            dic[@"appid"] = kWeixin_AppID;
            if (self.completeBlock) {
                self.completeBlock(dic);
            }
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
// 获取当前时间戳
- (NSInteger)getTimeStamp {
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%f", floor(a)];
    return [timeString integerValue];
}
// 保存数据
- (void)saveWXData:(NSDictionary *)data {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:data];
    NSInteger expires_in = [[NSString stringWithFormat:@"%@", dic[KWeixin_Expiresin_Key]] integerValue];
    dic[KWeixin_Expiresin_Key] = @(expires_in + [self getTimeStamp]);
    [[NSUserDefaults standardUserDefaults] setValue:dic forKeyPath:kWeixin_AccessTokenPath];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
// 清除缓存
- (void)clearData {
    [[NSUserDefaults standardUserDefaults] setValue:@{} forKeyPath:kWeixin_AccessTokenPath];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark - 回调函数
- (void)tm_weixinOnReq:(BaseReq *)req {}

- (void)tm_weixinOnResp:(id)resp {
    if ([resp isKindOfClass:[SendAuthResp class]]) { // 微信登录
        SendAuthResp *response = (SendAuthResp *)resp;
        if (response.errCode == 0) { // 用户同意
            NSString *code = response.code;
            [self getAccess_tokenWithCode:code];
        }else if (response.errCode == -4) { // 用户拒绝授权
            NSLog(@"%@",@"用户拒绝授权");
        }else if (response.errCode == -2) { // 用户取消
            NSLog(@"%@",@"用户取消");
        }else { // 其他错误
            NSLog(@"错误码：%d", response.errCode);
        }
        
    }else if ([resp isKindOfClass:[PayResp class]]){
        PayResp *response = (PayResp *)resp;

        switch(response.errCode){
            case WXSuccess:{                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
            }
                break;
            case WXErrCodeCommon:{          // 普通错误类型
                NSLog(@"普通错误类型");
            }
                break;
            case WXErrCodeUserCancel:{      // 用户点击取消并返回
                NSLog(@"用户点击取消并返回");
            }
                break;
            case WXErrCodeSentFail:{        // 发送失败
                NSLog(@"发送失败");
            }
                break;
            case WXErrCodeAuthDeny:{        // 授权失败
                NSLog(@"授权失败");
            }
                break;
            default:
                NSLog(@"支付失败，retcode=%d",response.errCode);
                break;

          }
    }
}

@end
