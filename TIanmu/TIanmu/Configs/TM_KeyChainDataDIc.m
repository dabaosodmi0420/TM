//
//  TM_KeyChainDataDIc.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/29.
//

#import "TM_KeyChainDataDIc.h"
#import "TM_KeyChain.h"
static NSString *keyChainDicName_ = @"com.tm.live.keyChain"; // 钥匙串字典名称
@implementation TM_KeyChainDataDIc
/*  获取钥匙串字典 */
+ (NSMutableDictionary *)tm_keyChainDic {
    //保存在钥匙串内的字典名称
    NSMutableDictionary *KeyChainDic = (NSMutableDictionary *)[TM_KeyChain load:keyChainDicName_];
    return KeyChainDic;
}
+ (void)tm_addValueToKeyChainDic:(id)value key:(NSString *)key {
    NSMutableDictionary *usernamepasswordKVPairs = [self tm_keyChainDic];
    if (usernamepasswordKVPairs) {
        if (value) {
            [usernamepasswordKVPairs setObject:value forKey:key];
        }
    } else {
        usernamepasswordKVPairs = [NSMutableDictionary dictionary];
        if (value) {
            [usernamepasswordKVPairs setObject:value forKey:key];
        }
    }
    [TM_KeyChain save:keyChainDicName_ data:usernamepasswordKVPairs];
}

+ (void)tm_deleteValueFromKeyChainDicWithKey:(NSString *)key {
    NSMutableDictionary *usernamepasswordKVPairs = [self tm_keyChainDic];
    if (usernamepasswordKVPairs) {
        [usernamepasswordKVPairs removeObjectForKey:key];
    }
    
    [TM_KeyChain save:keyChainDicName_ data:usernamepasswordKVPairs];
}
+ (id)tm_getValueFromKeyChainDicWithKey:(NSString *)key {
    NSMutableDictionary *usernamepasswordKVPairs = [self tm_keyChainDic];
    if (usernamepasswordKVPairs) {
        return [usernamepasswordKVPairs objectForKey:key];
    } else {
        return nil;
    }
}
@end
