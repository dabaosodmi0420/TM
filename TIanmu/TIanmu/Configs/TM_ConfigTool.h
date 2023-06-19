//
//  TM_ConfigTool.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TM_ConfigTool : NSObject
+ (NSArray *)getShortMenuListDatas;
+ (NSArray *)getProductListDatas;
+ (NSArray *)getSettingDatas;
@end

NS_ASSUME_NONNULL_END
