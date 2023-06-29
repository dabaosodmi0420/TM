//
//  TM_SettingManager.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/29.
//

#import <Foundation/Foundation.h>

#define kIdentifierId   @"TM_IdentifierId"

NS_ASSUME_NONNULL_BEGIN

@interface TM_SettingManager : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, copy) NSString *sIdentifierId;          // 用户注册的号
@property (nonatomic, assign, readonly) BOOL  hasPhoneLogged;         // 手机号是否登录成功
@end

NS_ASSUME_NONNULL_END
