//
//  TM_DeviceDetailViewController.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/29.
//

#import "TM_BaseViewController.h"
#import "TM_DataCardInfoModel.h"
#import "TM_DataCardDetalInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TM_DeviceDetailViewController : TM_BaseViewController

/* 卡片 */
@property (strong, nonatomic) TM_DataCardInfoModel *cardInfoModel;
/* model 暂不用 用TM_DeviceIndexInfo 中的数据替换 */
@property (strong, nonatomic) TM_DataCardDetalInfoModel *model;

@end

NS_ASSUME_NONNULL_END
