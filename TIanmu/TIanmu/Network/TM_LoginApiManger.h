//
//  TM_LoginApiManger.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/21.
//

#import "TM_NetworkTool.h"
#import "TM_NetworkTool+TM_Extension.h"
NS_ASSUME_NONNULL_BEGIN

@interface TM_LoginApiManger : TM_NetworkTool
// 发送验证码
+ (void)sendCodeWithPhoneNum:(NSString *)phoneNum
                     success:(TMAPISuccessBlock)successBlock
                     failure:(TMAPIFailureBlock)failureBlock;

/// 登录请求
/// - Parameters:
///   - phoneNum: 手机号
///   - pw: 密码：传参为账号密码登录，code不传
///   - code: 验证码：传参即为快捷登录，pw不传
///   - isPwLogin: 是否是密码登录
///   - successBlock: 回调
///   - failureBlock: 回调
+ (void)sendLoginWithPhoneNum:(NSString *)phoneNum
                     password:(NSString *)pw
                         code:(NSString *)code
                    isPwLogin:(BOOL)isPwLogin
                     success:(TMAPISuccessBlock)successBlock
                      failure:(TMAPIFailureBlock)failureBlock;
@end

NS_ASSUME_NONNULL_END
