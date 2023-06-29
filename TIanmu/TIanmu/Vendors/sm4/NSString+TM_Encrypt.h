//
//  NSString+TM_Encrypt.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/29.
//

#import <Foundation/Foundation.h>

static NSString *const sm4_ecb_key = @"0123456789abcdef";

NS_ASSUME_NONNULL_BEGIN

@interface NSString (TM_Encrypt)
//表示 SM4_ECB 加密
- (NSString *)tm_sm4_ecb_encryptWithKey:(NSString *)key;
// SM4_ECB 解密
- (NSString *)tm_sm4_ecb_decryptWithKey:(NSString *)key;

//表示 SM4_CBC 加密
- (NSString *)tm_sm4_cbc_encryptWithKey:(NSString *)key iv:(NSString *)iv;
// SM4_CBC 解密
- (NSString *)tm_sm4_cbc_decryptWithKey:(NSString *)key iv:(NSString *)iv;
@end

NS_ASSUME_NONNULL_END
