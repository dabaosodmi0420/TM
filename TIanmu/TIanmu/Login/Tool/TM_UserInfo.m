//
//  TM_UserInfo.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/29.
//

#import "TM_UserInfo.h"
#import "TM_StorageData.h"

#define TM_Userinfo_KEY  @"TM_Userinfo_KEY"

@implementation TM_UserInfo
+ (TM_UserInfo *)userInfo {
    TM_UserInfo *userInfo = [[TM_StorageData unarchiveDataFromCache:TM_Userinfo_KEY] firstObject];
    
    return userInfo;
}
@end
