//
//  TM_DataCardTaoCanModel.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/7/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TM_DataCardTaoCanInfoModel : NSObject<NSCoding>

/* 套餐名称 */
@property (copy, nonatomic) NSString *package_name;
/* 套餐id,例如：hbts-1054-150g */
@property (copy, nonatomic) NSString *package_id;
/* 套餐初始价，注：差价代理商需加分润差价 */
@property (copy, nonatomic) NSString *package_price;
/* 套餐前端显示名称 */
@property (copy, nonatomic) NSString *package_show_name;
/* 套餐内流量M */
@property (copy, nonatomic) NSString *package_flow;
/* 套餐介绍：默认为空：前端显示 -每月多少G */
@property (copy, nonatomic) NSString *package_details;
/* 套餐有效时间，如果是0月租卡 就表示1个月，如果是日卡 就表示1天 **如果是国外 */
@property (copy, nonatomic) NSString *package_time;
/* 套餐类型：0-0月租，1-月套餐，2-日卡，3-非池(不可修改！！！由card_package_type中package_type决定),4,月享 */
@property (copy, nonatomic) NSString *package_type;
/* 套餐加包类型id，关联子表、套餐类型表 */
@property (copy, nonatomic) NSString *package_type_id;
/* 套餐是否次月可查：1-可以显示出来；0-不可以显示出来 */
@property (copy, nonatomic) NSString *show_next_month;
/* 0-显示流量。1-显示无限量 */
@property (copy, nonatomic) NSString *show_status;
/* 是否是主体流量，0否，1是 */
@property (copy, nonatomic) NSString *main_body_status;
/* 套餐图片的标签图 */
@property (copy, nonatomic) NSString *label;
/*    */
@property (copy, nonatomic) NSString *package_status;
/*    */
@property (copy, nonatomic) NSString *package_voice;
/*    */
@property (copy, nonatomic) NSString *bill_day;
/*    */
@property (copy, nonatomic) NSString *country_code;
/*    */
@property (copy, nonatomic) NSString *cre_time;
/*    */
@property (copy, nonatomic) NSString *exceed_stop;
/*    */
@property (copy, nonatomic) NSString *flag;
/*    */
@property (copy, nonatomic) NSString *goodstype;
/*    */
@property (copy, nonatomic) NSString *ID;
/*    */
@property (copy, nonatomic) NSString *interface_id;
/*    */
@property (copy, nonatomic) NSString *is_delay;
/*    */
@property (copy, nonatomic) NSString *is_disposable;
/*    */
@property (copy, nonatomic) NSString *is_first;
/*    */
@property (copy, nonatomic) NSString *is_test;
/*    */
@property (copy, nonatomic) NSString *netType;
/*    */
@property (copy, nonatomic) NSString *not_split;
/*    */
@property (copy, nonatomic) NSString *old_price;
/*    */
@property (copy, nonatomic) NSString *remind;
/*    */
@property (copy, nonatomic) NSString *tmfsk_net;

@end

@interface TM_DataCardTaoCanModel : NSObject<NSCoding>

/* 是否已订购主体套餐：0，否；>0 ,已订购（已订购的话，主体套餐都是显示灰色）；只有卡的涉及，设备不涉及主体套餐 */
@property (assign, nonatomic) BOOL ifMainTc;
// 设备传的是 all
/* 一级套餐 */
@property (strong, nonatomic) NSArray<TM_DataCardTaoCanInfoModel *> *singleList;
/* 二级套餐 */
@property (strong, nonatomic) NSArray<TM_DataCardTaoCanInfoModel *> *doubleList;
/* 三级套餐 */
@property (strong, nonatomic) NSArray<TM_DataCardTaoCanInfoModel *> *tripleList;

// 流量卡传 单独传的 next  month add
/* 卡单独返回套餐  */
@property (strong, nonatomic) NSArray<TM_DataCardTaoCanInfoModel *> *tcList;

@end

NS_ASSUME_NONNULL_END
