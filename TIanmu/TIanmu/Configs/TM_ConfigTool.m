//
//  TM_ConfigTool.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/16.
//

#import "TM_ConfigTool.h"

@implementation TM_ConfigTool

+ (NSArray *)getShortMenuListDatas {
    
    return [TM_ConfigTool loadLocalPlistDataWithName:@"shortMenuDatas"][@"datas"] ;
}
+ (NSArray *)getProductListDatas {
    
    return [TM_ConfigTool loadLocalPlistDataWithName:@"productListDatas"][@"datas"];
}
+ (NSArray *)getSettingDatas {
    
    return [TM_ConfigTool loadLocalPlistDataWithName:@"settingDatas"][@"datas"];
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

@end
