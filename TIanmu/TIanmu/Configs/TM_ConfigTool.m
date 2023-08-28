//
//  TM_ConfigTool.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/16.
//

#import "TM_ConfigTool.h"
#import "TM_StorageData.h"

@implementation TM_ConfigTool

#pragma mark - 获取plist数据

+ (NSArray *)getProductListDatas {
    
    return [TM_ConfigTool loadLocalPlistDataWithName:@"productListDatas"][@"datas"];
}

+ (id)loadLocalPlistDataWithName:(NSString *)pathName {
    //获取bundle
    NSBundle *bundle = [NSBundle mainBundle];
    //获取plist地址
    NSString *path = [bundle pathForResource:pathName ofType:@"plist"];
    //加载plist文件
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    return  dic;
}

#pragma mark - 获取json数据
+ (NSArray *)getSettingDatas {
    
    return [TM_ConfigTool getPrepareData:@"personalDatas"][@"PersonalDatas"];
}
+ (NSArray *)getSettingDatasCenter {
    
    return [TM_ConfigTool getPrepareData:@"personalDatas"][@"settingDatas"];
}
+ (NSArray *)getTabbarDatas {
    return [TM_ConfigTool getPrepareData:@"generalDatas"][@"tabbar"];
}
+ (NSArray *)getDeviceShortMenuListDatas {
    
    return [TM_ConfigTool getPrepareData:@"generalDatas"][@"shortMenus"] ;
}
+ (NSArray *)getCardShortMenuListDatas {
    return [TM_ConfigTool getPrepareData:@"generalDatas"][@"shortMenusCard"] ;
}
+ (NSDictionary *)getPrepareData:(NSString *)fileName {
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:jsonPath];
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    return jsonDict;
}


@end
