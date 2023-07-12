//
//  TM_BuyHistoryViewController.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/7/12.
//

#import "TM_BaseViewController.h"
#import "TM_DataCardDetalInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TM_BuyHistoryViewController : TM_BaseViewController
/* 卡详细数据 */
@property (strong, nonatomic) TM_DataCardDetalInfoModel *cardDetailInfoModel;

@end

NS_ASSUME_NONNULL_END
