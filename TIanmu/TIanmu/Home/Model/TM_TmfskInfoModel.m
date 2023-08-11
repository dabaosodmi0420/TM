//
//  TM_TmfskInfoModel.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/8/11.
//

#import "TM_TmfskInfoModel.h"
@implementation TM_TmfskInfoListModel

MJExtensionCodingImplementation

@end

@implementation TM_TmfskInfoCatcard_type_listModel
MJExtensionCodingImplementation
@end

@implementation TM_TmfskInfoModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"catcard_type_list" : [TM_TmfskInfoCatcard_type_listModel class],
        @"list" : [TM_TmfskInfoListModel class]
    };
}
MJExtensionCodingImplementation
@end
