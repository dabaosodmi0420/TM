//
//  TM_NetworkTool.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/13.
//

#import <Foundation/Foundation.h>

#define TM_AFTIMEOUTINTERVAL 15
#define TM_AFGET @"GET"
#define TM_AFPOST @"POST"

typedef void (^TMAPISuccessBlock)(id _Nullable respondObject);
typedef void (^TMAPIFailureBlock)(NSError * _Nullable error);
NS_ASSUME_NONNULL_BEGIN

@interface TM_NetworkTool : NSObject
+ (instancetype)sharedNetworkTool;

- (void)sendRequestPath:(NSString *)path
                 params:(NSDictionary *)params
                headers:(NSDictionary *)headers
                 method:(NSString *)method
                   asyn:(BOOL)asyn
                success:(TMAPISuccessBlock)successBlock
                failure:(TMAPIFailureBlock)failureBlock;

- (void)sendGETRequestWithPath:(NSString *)path
                    parameters:(NSDictionary *)params
                       headers:(NSDictionary *)headers
                       success:(TMAPISuccessBlock)successBlock
                       failure:(TMAPIFailureBlock)failureBlock;

- (void)sendPOSTRequestWithPath:(NSString *)path
                     parameters:(NSDictionary *)params
                        headers:(NSDictionary *)headers
                        success:(TMAPISuccessBlock)successBlock
                        failure:(TMAPIFailureBlock)failureBlock;

- (void)sendRequestPath:(NSString *)path
                 params:(NSDictionary *)params
                headers:(NSDictionary *)headers
                 method:(NSString *)method
                success:(TMAPISuccessBlock)successBlock
                failure:(TMAPIFailureBlock)failureBlock;


@end

NS_ASSUME_NONNULL_END
