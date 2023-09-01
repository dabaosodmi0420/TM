//
//  TM_RechargeViewController.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/7/5.
//

#import "TM_BaseViewController.h"
#import "TM_ShortMenuModel.h"
#import "TM_DataCardDetalInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TM_RechargeViewController : TM_BaseViewController

/* 功能model */
@property (strong, nonatomic) TM_ShortMenuModel *menuModel;
/* 卡详细数据 */
@property (strong, nonatomic) TM_DataCardDetalInfoModel *cardDetailInfoModel;



@end

NS_ASSUME_NONNULL_END
