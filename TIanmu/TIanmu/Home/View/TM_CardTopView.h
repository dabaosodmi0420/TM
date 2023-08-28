//
//  TM_CardTopView.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/8/26.
//

#import <UIKit/UIKit.h>
#import "TM_DataCardDetalInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TM_CardTopView : UIView

- (instancetype)initWithFrame:(CGRect)frame model:(TM_DataCardDetalInfoModel *)model;
@end

NS_ASSUME_NONNULL_END
