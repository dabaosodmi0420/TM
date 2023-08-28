//
//  TM_CardDetailViewController.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/7/11.
//

#import "TM_BaseViewController.h"
#import "TM_DataCardInfoModel.h"
#import "TM_DataCardDetalInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TM_CardDetailViewController : TM_BaseViewController

/* 卡片 */
@property (strong, nonatomic) TM_DataCardInfoModel *cardInfoModel;
/* model */
@property (strong, nonatomic) TM_DataCardDetalInfoModel *model;
@end

NS_ASSUME_NONNULL_END
