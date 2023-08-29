//
//  JTBaseTool.h
//  ZXJTBaseFramework
//
//  Created by 你猜我是谁啊 on 2018/11/29.
//  Copyright © 2018 你猜我是谁啊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JTBaseTool : NSObject

/*
 * 给H5传参格式
 */
+ (NSString *)jt_rspWebAction:(NSString *)action param:(id)param;
/**
 * 对象转换成json字符串
 **/
+ (NSString *)jt_transformToJsonWithParam:(id)param;
/**
 * json字符串转化成对象
 **/
+ (id)jt_transformToParamWithJson:(NSString *)json;
/**
 * 判断空串
 **/
+ (BOOL)judgeNull:(NSString *)string;
/**
 * 当字符串为空时返回空字符串 @”“
 **/
+ (NSString *)jt_returnNullStringWhenStringIsNull:(NSString *)string;
/**
* 打开url
**/
+ (void)jt_openUrl:(NSString *)urlStr;
/*
 * 判断当前网络状态
 */
+ (BOOL)jt_getNetWorkStates;
/**
 * 获取：mac地址、uuid、ip地址、手机型号
 **/
+ (NSDictionary *)getIphoneInfo;
/**
 * 亮度调节: value (0~1)
 */
+ (void)jt_deviceBrightness:(CGFloat)value;
/**
 * 调节到最高亮度
 */
+ (void)jt_deviceHighestBrightness;
/**
 * 调节亮度后恢复之前的亮度
 */
+ (void)jt_recoverDeviceBrightness;
/**
 * 音量调节: value (0~1)
 */
+ (void)jt_deviceVolume:(CGFloat)value;
/**
 * 调节到最高音量
 */
+ (void)jt_deviceHighestVolume;
/**
 * 调节音量后恢复之前的音量
 */
+ (void)jt_recoverDeviceVolume;

/**
 * 加密
 */
+ (NSString *)jt_encryptionData:(NSString *)key :(NSString *)data;
/**
 * 解密
 */
+ (NSString *)jt_decryptionData:(NSString *)key :(NSString *)data;

/**
 * 当前网络状态
 */
+ (NSString *)networkStatus;
/**
 * 获取当前音量
 */
+ (NSString *)getCurrentVoiceLevel;
/**
 * 当前电池状态
 */
+ (NSString *)getCurrentBatteryLevel;
/**
 * 是否佩戴耳机
 */
+ (BOOL)isWearHeadset;
/** 当前连接耳机状态
    "N"                未连接耳机
    "B"                连接蓝牙耳机
    "W"               连接有线耳机
    "unknown"    未知
 */
+ (NSString *)getHeadsetStatus;
@end
