//
//  TM_RealNameAuthViewController.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/7/12.
//

#import "TM_BaseViewController.h"
#import "TM_DataCardDetalInfoModel.h"
#import "TM_DeviceIndexInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface TM_RealNameAuthViewController : TM_BaseViewController
/* 卡详细数据 */
@property (strong, nonatomic) TM_DataCardDetalInfoModel *cardDetailInfoModel;
/* 设备索引信息 */
@property (strong, nonatomic) TM_DeviceIndexInfo *deviceIndexInfoModel;
@end

NS_ASSUME_NONNULL_END
