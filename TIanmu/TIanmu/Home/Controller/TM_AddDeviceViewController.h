//
//  TM_AddDeviceViewController.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/7/12.
//

#import "TM_BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TM_AddDeviceViewController : TM_BaseViewController

/* 刷新 */
@property (copy, nonatomic) void(^refreshDataBlock)(void);

@end

NS_ASSUME_NONNULL_END
