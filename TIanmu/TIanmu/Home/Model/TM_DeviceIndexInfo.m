//
//  TM_DeviceIndexInfo.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/8/27.
//

#import "TM_DeviceIndexInfo.h"

@implementation TM_DeviceIndexInfo_wifi

MJExtensionCodingImplementation

@end
@implementation TM_DeviceIndexInfo_flow

MJExtensionCodingImplementation

@end
@implementation TM_DeviceIndexInfo_packageDays

MJExtensionCodingImplementation

@end
@implementation TM_DeviceIndexInfo_cardTypeInfo

MJExtensionCodingImplementation

@end

@implementation TM_DeviceIndexInfo

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return  @{
        @"wifiInfo" : @"wifi",
        @"flowInfo" : @"flow",
        @"packageDaysInfo" : @"packageDays",
        @"cardTypeInfo" : @"cardTypeInfo"
    };
}

MJExtensionCodingImplementation
@end
