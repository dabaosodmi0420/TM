//
//  TM_DataCardUsedFlowMode.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/7/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TM_Device_info_model : NSObject<NSCoding>
/* 套餐有效期 */
@property (copy, nonatomic) NSString *serveValidDate;
/* 总天数 */
@property (copy, nonatomic) NSString *totalDays;
/* 状态 */
@property (copy, nonatomic) NSString *state;
/* 已用天数 */
@property (copy, nonatomic) NSString *useDays;
/* info */
@property (copy, nonatomic) NSString *info;
/* 剩余天数 */
@property (copy, nonatomic) NSString *leftDays;
@end


@interface TM_DataCardUsedFlowModel : NSObject<NSCoding>
/* 已用流量，单位：M */
@property (copy, nonatomic) NSString *used_m;
/* 总流量，单位：M */
@property (copy, nonatomic) NSString *total_m;
/* 剩余流量，单位：M */
@property (copy, nonatomic) NSString *remain_m;
/* 超出流量，单位：M */
@property (copy, nonatomic) NSString *ccll_m;
/* 已用流量，单位：G */
@property (copy, nonatomic) NSString *used;
/* 总流量，单位：G */
@property (copy, nonatomic) NSString *total;
/* 剩余流量，单位：G */
@property (copy, nonatomic) NSString *remain;
/* 超出流量，单位：G */
@property (copy, nonatomic) NSString *ccll;
/* 账户余额 */
@property (copy, nonatomic) NSString *balance;
/* 是否显示无限量：false，否；true，是 */
@property (assign, nonatomic) BOOL showInfinte;
/* 是否显示总流量：false，否；true，是 */
@property (assign, nonatomic) BOOL showTotal;
/* 设备信息 */
@property (strong, nonatomic) TM_Device_info_model *device_info;
/* 套餐结束日期 */
@property (copy, nonatomic) NSString *tc_end_time;

@end

NS_ASSUME_NONNULL_END
