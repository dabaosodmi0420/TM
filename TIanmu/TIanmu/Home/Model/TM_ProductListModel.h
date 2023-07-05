//
//  TM_ProductListModel.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TM_ProductListModel : NSObject
/* 图片地址 */
@property (strong, nonatomic) NSString *picpath;
/* 名称 */
@property (strong, nonatomic) NSString *menuname;

@end

NS_ASSUME_NONNULL_END
