//
//  TM_SettingManager.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/29.
//

#import "TM_SettingManager.h"
#import "TM_KeyChainDataDIc.h"
#import "NSString+TM_Encrypt.h"
#import "TM_KeyChainDataDIc.h"
#import "TM_SettingManager.h"
@implementation TM_SettingManager

+ (instancetype)shareInstance {
    static TM_SettingManager *settingMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        settingMgr = [[TM_SettingManager alloc] init];
    });
    return settingMgr;
}

- (instancetype)init {
    if (self = [super init]) {
        [self readLoadInformation];
    }
    return self;
}
/**
 *  读取本地信息（1、setting.plist内信息  2、钥匙串内信息）
 */
- (void)readLoadInformation {
    // 获取手机号
    NSString *identifierId = [TM_KeyChainDataDIc tm_getValueFromKeyChainDicWithKey:kIdentifierId];
    if (identifierId.length) {
        NSString *decryptStr = [identifierId tm_sm4_ecb_decryptWithKey:sm4_ecb_key];
        if(decryptStr.length) {
            self.sIdentifierId = decryptStr;
        }
    }
}

- (void)setSIdentifierId:(NSString *)sIdentifierId {
    _sIdentifierId = sIdentifierId;
    
}
- (BOOL)hasPhoneLogged {
    if (self.sIdentifierId.length > 0){
        return YES;
    } else {
        return NO;
    }
}
@end
