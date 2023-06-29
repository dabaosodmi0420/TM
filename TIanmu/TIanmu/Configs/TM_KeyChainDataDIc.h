//
//  TM_KeyChainDataDIc.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TM_KeyChainDataDIc : NSObject
/**
 *  向钥匙串内本应用永存的一个字典内插入值
 *
 *  @param value
 *  @param key
 */
+ (void)tm_addValueToKeyChainDic:(id)value key:(NSString *)key;

/**
 *  从钥匙串内本应用永存的一个字典内删除一个值
 *
 *  @param key
 */
+ (void)tm_deleteValueFromKeyChainDicWithKey:(NSString *)key;

//从钥匙串内本应用永存的一个字典内取值 参数：键
/**
 *  从钥匙串内本应用永存的一个字典内取值
 *
 *  @param key
 *
 *  @return value
 */
+ (id)tm_getValueFromKeyChainDicWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
