//
//  TM_DeviceIndexInfo.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/8/27.
//

#import <Foundation/Foundation.h>

@interface TM_DeviceIndexInfo_wifi : NSObject
/* wifi连接数 */
@property (assign, nonatomic) int conn_cnt;
/* 状态 success 成功 */
@property (copy, nonatomic) NSString *state;
/* 0设备离线；其他值看rssi信号值字段 */
@property (nonatomic, assign) int deviceStatus;
/* 信号值 */
@property (nonatomic, assign) int rssi;
/* wifi名称 */
@property (copy, nonatomic) NSString *ssid;
/* key */
@property (copy, nonatomic) NSString *key;
/* 设备当前在用内贴卡网络类型：cmcc移动，cucc联通，ctcc电信 */
@property (copy, nonatomic) NSString *opname;
@end

@interface TM_DeviceIndexInfo_flow : NSObject
/* 总流量GB */
@property (copy, nonatomic) NSString *total;
/* 已用GB */
@property (copy, nonatomic) NSString *used;
/* 超流量GB */
@property (copy, nonatomic) NSString *ccll;
/* 剩余GB */
@property (copy, nonatomic) NSString *remain;
/* MB */
@property (copy, nonatomic) NSString *total_m;
/* MB */
@property (copy, nonatomic) NSString *used_m;
/* MB */
@property (copy, nonatomic) NSString *ccll_m;
/* MB */
@property (copy, nonatomic) NSString *remain_m;
/* true */
@property (assign, nonatomic) BOOL state;

@end

@interface TM_DeviceIndexInfo_packageDays : NSObject
/* 当前套餐总天数 */
@property (copy, nonatomic) NSString *totalDays;
/* 当前套餐已用天数 */
@property (copy, nonatomic) NSString *useDays;
/* 当前套餐剩余天数 */
@property (copy, nonatomic) NSString *leftDays;
/* 当前套餐截止日期 */
@property (copy, nonatomic) NSString *nowEndTime;
/* 待启用套餐包体名称 */
@property (copy, nonatomic) NSString *nextPackageName;
/* 当前套餐包体名称 */
@property (copy, nonatomic) NSString *nowPackageName;
@end

@interface TM_DeviceIndexInfo_cardTypeInfo : NSObject
/* <#descript#> */
@property (copy, nonatomic) NSString *agent_card_type_name;
/* 卡名 */
@property (copy, nonatomic) NSString *card_type_name;
/* 显示菜单按钮 */
@property (copy, nonatomic) NSString *webConn;
/* 卡类别 */
@property (copy, nonatomic) NSString *card_type;
/* 添加时间 */
@property (copy, nonatomic) NSString *add_time;
/* 使用状态 */
@property (copy, nonatomic) NSString *use_status;
@end

@interface TM_DeviceIndexInfo : NSObject
/* 只有两个值，1和2。返回1，查询 设备实名链接 接口，若是返回2，则显示已实名 */
@property (strong, nonatomic) NSString *auth;
/* 余额 */
@property (assign, nonatomic) CGFloat balance;

/* wifi */
@property (strong, nonatomic) TM_DeviceIndexInfo_wifi *wifiInfo;
/* flow */
@property (strong, nonatomic) TM_DeviceIndexInfo_flow *flowInfo;
/* packageDays */
@property (strong, nonatomic) TM_DeviceIndexInfo_packageDays *packageDaysInfo;
/* cardTypeInfo */
@property (strong, nonatomic) TM_DeviceIndexInfo_cardTypeInfo *cardTypeInfo;

@end


