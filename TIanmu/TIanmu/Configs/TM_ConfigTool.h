//
//  TM_ConfigTool.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TM_ConfigTool : NSObject
// 获取首页按钮菜单栏数据
+ (NSArray *)getShortMenuListDatas;
// 获取首页产品列表数据
+ (NSArray *)getProductListDatas;
// 获取我的页面下的设置数据
+ (NSArray *)getSettingDatas;
// 获取tabbar显示数据
+ (NSArray *)getTabbarDatas;
// 获取设置中心数据
+ (NSArray *)getSettingDatasCenter;

@end

NS_ASSUME_NONNULL_END
