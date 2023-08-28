//
//  TM_ShortMenuModel.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/16.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TM_ShortMenuType){
    TM_ShortMenuTypeDefault = -1,
    TM_ShortMenuTypeBalanceRecharge,        // 余额充值
    TM_ShortMenuTypeFlowRecharge,           // 流量充值
    TM_ShortMenuTypeRemoteControl,          // 远程控制
    TM_ShortMenuTypeNetChange,              // 网络切换
    TM_ShortMenuTypeRealNameAuth,           // 实名认证
    TM_ShortMenuTypeTransactionRecord,      // 交易记录
    TM_ShortMenuTypeElectronicWaste,        // 电子垃圾
    TM_ShortMenuTypeNewGuide,               // 新手指导
    TM_ShortMenuTypeService,                // 在线客服
    TM_ShortMenuTypeUpdate,                 // 软件更新
    TM_ShortMenuTypeTaocanUsed,             // 套餐用量
    TM_ShortMenuTypeGuzhang,                // 故障修改
    TM_ShortMenuTypeQuestion,               // 常见问题
    TM_ShortMenuTypeCancelCard,             // 销卡
};

NS_ASSUME_NONNULL_BEGIN

@interface TM_ShortMenuModel : NSObject
/* 图片地址 */
@property (strong, nonatomic) NSString *picpath;
/* 名称 */
@property (strong, nonatomic) NSString *menuname;
/* 功能号 */
@property (strong, nonatomic) NSString *funcCode;
/* 功能好编码 */
@property (assign, nonatomic) NSInteger funcNo;
/* icon图片 */
@property (strong, nonatomic) NSString *iconImgName;
/* 功能枚举 */
@property (assign, nonatomic) TM_ShortMenuType funcType;
@end

NS_ASSUME_NONNULL_END
