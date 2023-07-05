//
//  TM_DataCardInfoModel.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TM_DataCardInfoModel : NSObject<NSCoding>

/* iccid号 */
@property (strong, nonatomic) NSString *iccid;
/* 自定义号 */
@property (strong, nonatomic) NSString *card_define_no;
/* 真实号码 */
@property (strong, nonatomic) NSString *card_no;
@end

NS_ASSUME_NONNULL_END
