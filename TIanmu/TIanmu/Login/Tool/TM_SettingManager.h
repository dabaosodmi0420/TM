//
//  TM_SettingManager.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/29.
//

#import <Foundation/Foundation.h>
#import "TM_DataCardInfoModel.h"

#define kIdentifierId   @"TM_IdentifierId"

NS_ASSUME_NONNULL_BEGIN

@interface TM_SettingManager : NSObject

+ (instancetype)shareInstance;

+ (void)clear;
@property (nonatomic, copy) NSString *sIdentifierId;                    // 用户注册的号
@property (nonatomic, assign, readonly) BOOL  hasPhoneLogged;           // 手机号是否登录成功

/* 当前选中的卡片 */
@property (strong, nonatomic, readonly) TM_DataCardInfoModel *dataCardInfoModel;
- (void)updateCurrentDataCardInfoModel:(TM_DataCardInfoModel *)dataCardInfoModel;    // 更新当前选中的卡片


@end

NS_ASSUME_NONNULL_END
