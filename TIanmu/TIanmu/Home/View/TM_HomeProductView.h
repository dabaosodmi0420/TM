//
//  TM_HomeProductView.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/14.
//

#import <UIKit/UIKit.h>
#import "TM_ProductListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TM_HomeProductView : UIView
/* datas */
@property (strong, nonatomic) NSArray<TM_ProductListModel *> *datas;

@end

NS_ASSUME_NONNULL_END
