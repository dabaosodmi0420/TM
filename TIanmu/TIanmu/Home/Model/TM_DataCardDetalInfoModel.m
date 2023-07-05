//
//  TM_DataCardDetalInfoModel.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/30.
//

#import "TM_DataCardDetalInfoModel.h"

@implementation TM_Device_info

MJExtensionCodingImplementation

@end

@implementation TM_Mainmenu

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID": @"id"}; 
}

MJExtensionCodingImplementation

@end

@implementation TM_DataCardDetalInfoModel
//+ (NSDictionary *)mj_replacedKeyFromPropertyName {
//    return @{
//        @"TM_Device_info" : @"device_info" ,
//        @"TM_Mainmenu" : @"mainmenu"
//    };
//}

MJExtensionCodingImplementation
@end
