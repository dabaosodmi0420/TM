//
//  TM_DataCardApiManager.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/28.
//

#import "TM_NetworkTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface TM_DataCardApiManager : TM_NetworkTool
// 获取用户所有卡片信息
+ (void)sendQueryUserAllCardWithPhoneNum:(NSString *)phoneNum
                                 success:(TMAPISuccessBlock)successBlock
                                 failure:(TMAPIFailureBlock)failureBlock;
// 查询单卡信息
+ (void)sendQueryUserAllCardWithCardNo:(NSString *)cardNo
                               success:(TMAPISuccessBlock)successBlock
                               failure:(TMAPIFailureBlock)failureBlock;
@end

NS_ASSUME_NONNULL_END
