//
//  TM_NetworkTool.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/13.
//

#import "TM_NetworkTool.h"
#import <AFNetworking.h>

@interface TM_NetworkTool()
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@end

@implementation TM_NetworkTool

+ (instancetype)sharedNetworkTool{
    
    static TM_NetworkTool *shareNetworkTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareNetworkTool = [[TM_NetworkTool alloc] init];
    });
    return shareNetworkTool;
}
- (AFHTTPSessionManager *)sessionManager{
    @synchronized(self) {
        if (!_sessionManager) {
            _sessionManager = [AFHTTPSessionManager manager];
            _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
            _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
            // 设置请求接口回来时支持什么类型的数组
//            _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
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
        [self sendGETRequestWithPath:path parameters:params headers: headers success:successBlock failure:failureBlock];
    }else if ([method isEqualToString:TM_AFPOST]){
        [self sendPOSTRequestWithPath:path parameters:params headers: headers success:successBlock failure:failureBlock];
    }
    
}
- (void)sendGETRequestWithPath:(NSString *)path
                    parameters:(NSDictionary *)params
                       headers:(NSDictionary *)headers
                       success:(TMAPISuccessBlock)successBlock
                       failure:(TMAPIFailureBlock)failureBlock{
    [self.sessionManager GET:path parameters:params headers:headers progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
                        headers:(NSDictionary *)headers
                        success:(TMAPISuccessBlock)successBlock
                        failure:(TMAPIFailureBlock)failureBlock{
    [self.sessionManager POST:path parameters:params headers:headers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

@end
