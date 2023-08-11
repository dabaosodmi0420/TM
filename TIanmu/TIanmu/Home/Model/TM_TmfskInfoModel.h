//
//  TM_TmfskInfoModel.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/8/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface TM_TmfskInfoCatcard_type_listModel : NSObject<NSCoding>

/* 套餐组合
   1 : "telecom"
   2 : "telecom,cmcc"
   3 : "telecom,cmcc,unicom"
*/
@property (copy, nonatomic) NSString *enable_isp;
/* 套餐类型 0 非大小猫卡 1 畅享, 2优享, 3尊享  */
@property (copy, nonatomic) NSString *type;

@end
@interface TM_TmfskInfoListModel : NSObject<NSCoding>

/* ICCID */
@property (copy, nonatomic) NSString *iccid;
/* 是否可切网：0否，1是 */
@property (copy, nonatomic) NSString *is_can_change;
/* 是否实名：0未实名，1已实名 */
@property (copy, nonatomic) NSString *is_identity;
/* 所属运营商：unicom 联通，cmcc 移动，telecom 电信 */
@property (copy, nonatomic) NSString *isp;
/* MSISDN */
@property (copy, nonatomic) NSString *msisdn;

@end
@interface TM_TmfskInfoModel : NSObject<NSCoding>
/* 0 非大小猫卡 1 畅享, 2优享, 3尊享 */
@property (assign, nonatomic) int catcard_type;
/* 运营商列表数据 */
@property (strong, nonatomic) NSArray<TM_TmfskInfoListModel *> *list;
/* 支持的类型,同上 */
@property (strong, nonatomic) NSArray<TM_TmfskInfoCatcard_type_listModel *> *catcard_type_list;
@end

NS_ASSUME_NONNULL_END
