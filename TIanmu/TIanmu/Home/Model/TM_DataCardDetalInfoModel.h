//
//  TM_DataCardDetalInfoModel.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TM_Device_info : NSObject<NSCoding>
/* u200 套餐有效期 */
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

@interface TM_Mainmenu : NSObject<NSCoding>  //app主菜单（1是开启，0是关闭）
/* 销卡 */
@property (copy, nonatomic) NSString *xk;
/* 交易记录 */
@property (copy, nonatomic) NSString *trade;
/* 流量充值 */
@property (copy, nonatomic) NSString *add_flow;
/* 故障修复 */
@property (copy, nonatomic) NSString *breakdown;
/* 在线客服 */
@property (copy, nonatomic) NSString *customer;
/* id */
@property (copy, nonatomic) NSString *ID;
/* 卡类型 */
@property (copy, nonatomic) NSString *card_type;
/* 网络切换dian */
@property (copy, nonatomic) NSString *change_net;
/* 账户充值 */
@property (copy, nonatomic) NSString *account_recharge;
/* 套餐编号 */
@property (copy, nonatomic) NSString *package_type_id;
/* 套餐用量 */
@property (copy, nonatomic) NSString *query_flow;
/* 远程控制 */
@property (copy, nonatomic) NSString *remote_control;
/* 常见问题 */
@property (copy, nonatomic) NSString *question;
/* APN设置 */
@property (copy, nonatomic) NSString *apn_set;
/* 实名 */
@property (copy, nonatomic) NSString *auth;
@end

@interface TM_DataCardDetalInfoModel : NSObject<NSCoding>
/* 0是卡，1是设备 */
@property (copy, nonatomic) NSString *card_or_device;
/* 子表表名 */
@property (copy, nonatomic) NSString *card_type;
/* iccid号 */
@property (copy, nonatomic) NSString *iccid;
/* 给U200用，已用流量 */
@property (copy, nonatomic) NSString *usedFlow;
/* 给U200用，总流量 */
@property (copy, nonatomic) NSString *totalFlow;
/* 给U200用，剩余流量 */
@property (copy, nonatomic) NSString *leftFlow;
/* 账户余额 */
@property (copy, nonatomic) NSString *balance;
/* 套餐包id */
@property (copy, nonatomic) NSString *package_type_id;
/* 0，未待激活；1，正常；2，停机；3，拆机；4，违章停机 */
@property (copy, nonatomic) NSString *status;
/* 实名状态：0未实名、1审核中、2、实名通过、3.审核未通过 4.恶意实名 */
@property (copy, nonatomic) NSString *is_realname;
/* 套餐名称 */
@property (copy, nonatomic) NSString *package_name;
/* 自定义号 */
@property (copy, nonatomic) NSString *card_define_no;
/* 上网状态：1开网状态 2 停网状态 */
@property (copy, nonatomic) NSString *net_status;
/* 真实号码 */
@property (copy, nonatomic) NSString *card_no;
/* 套餐结束时间 */
@property (copy, nonatomic) NSString *packge_end_time;
/* 实名信息id */
@property (copy, nonatomic) NSString *realname_id;
/* 代理商id */
@property (copy, nonatomic) NSString *agent_id;
/* 设备信息 */
@property (strong, nonatomic) TM_Device_info *device_info;
/* app主菜单（1是开启，0是关闭） */
@property (strong, nonatomic) TM_Mainmenu *mainmenu;
@end



NS_ASSUME_NONNULL_END
