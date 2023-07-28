//
//  TM_DataCardTaoCanModel.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/7/27.
//

#import "TM_DataCardTaoCanModel.h"
@implementation TM_DataCardTaoCanInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID": @"id"};
}

MJExtensionCodingImplementation

@end

@implementation TM_DataCardTaoCanModel
//+ (NSDictionary *)mj_replacedKeyFromPropertyName {
//    return @{
//        @"TM_Device_info" : @"device_info" ,
//        @"TM_Mainmenu" : @"mainmenu"
//    };
//}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"singleList" : [TM_DataCardTaoCanInfoModel class],
        @"doubleList" : [TM_DataCardTaoCanInfoModel class],
        @"tripleList" : [TM_DataCardTaoCanInfoModel class]
    };
}

MJExtensionCodingImplementation
@end
