//
//  TM_ProductInfoViewController.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/8/15.
//

#import "TM_WKBaseWebViewController.h"
#import "TM_ProductListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TM_ProductInfoViewController : TM_WKBaseWebViewController

/* 数据源 */
@property (strong, nonatomic) TM_ProductListModel *productModel;


@end

NS_ASSUME_NONNULL_END
