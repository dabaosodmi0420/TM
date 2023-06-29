//
//  NSString+TM_Encrypt.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/29.
//

#import "NSString+TM_Encrypt.h"
#import "TM_SM4.h"
@implementation NSString (TM_Encrypt)
//表示 SM4_ECB 加密
- (NSString *)tm_sm4_ecb_encryptWithKey:(NSString *)key{
    unsigned char *ckey = [key UTF8String];
    NSData *plainInData =[self dataUsingEncoding:NSUTF8StringEncoding];
    int plainInDataLength = plainInData.length;
    //  p是需要填充的数据也是填充的位数
    int p =  plainInDataLength % 16 == 0 ? 0 : 16 - plainInDataLength % 16;
    unsigned char plainInChar[plainInDataLength + p];
    memcpy(plainInChar, plainInData.bytes, plainInDataLength);
    //  进行数据填充
    for (int i = 0; i < p; i++)
    {
        plainInChar[plainInDataLength + i] =  0;
    }
    unsigned char cipherOutChar[plainInDataLength + p];
    C_jtsm4ECBEncode(plainInDataLength + p, plainInChar, cipherOutChar,ckey);
    NSData *cipherTextData =  [[NSData alloc]initWithBytes:cipherOutChar length:sizeof(cipherOutChar)];
    NSString *fstr = [cipherTextData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return fstr;
}
- (NSString *)tm_sm4_ecb_decryptWithKey:(NSString *)key{
    NSData *cipherTextData = [[NSData alloc] initWithBase64EncodedString:self options:NSDataBase64EncodingEndLineWithLineFeed];
    unsigned char cipherTextChar[cipherTextData.length];
    memcpy(cipherTextChar, cipherTextData.bytes, cipherTextData.length);
    //调用解密方法，输出是明文plainOutChar
    unsigned char plainOutChar[cipherTextData.length];
    C_jtsm4ECBDecode(cipherTextData.length, cipherTextChar, plainOutChar,[key UTF8String]);
    
    //明文转成NSData 再转成NSString打印
    NSData *outData = [[NSData alloc]initWithBytes:plainOutChar length:sizeof(plainOutChar)];
    NSString *fstr = [[NSString alloc]initWithData:outData encoding:NSUTF8StringEncoding];
    return [self filte:fstr];
}

//表示 SM4_CBC 加密
- (NSString *)tm_sm4_cbc_encryptWithKey:(NSString *)key iv:(NSString *)iv{
    NSData *plainInData =[self dataUsingEncoding:NSUTF8StringEncoding];
    int plainInDataLength = plainInData.length;
    //  p是需要填充的数据也是填充的位数
    int p =  plainInDataLength % 16 == 0 ? 0 : 16 - plainInDataLength % 16;
    unsigned char plainInChar[plainInDataLength + p];
    memcpy(plainInChar, plainInData.bytes, plainInDataLength);
    //  进行数据填充
    for (int i = 0; i < p; i++)
    {
        plainInChar[plainInDataLength + i] =  0;
    }
    unsigned char cipherOutChar[plainInDataLength + p];
    C_jtsm4CBCEncode(plainInDataLength + p, plainInChar, cipherOutChar,[key UTF8String], [iv UTF8String]);
    NSData *cipherTextData =  [[NSData alloc]initWithBytes:cipherOutChar length:sizeof(cipherOutChar)];
    NSString *fstr = [cipherTextData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return fstr;
    
}
- (NSString *)tm_sm4_cbc_decryptWithKey:(NSString *)key iv:(NSString *)iv{
    NSData *cipherTextData = [[NSData alloc] initWithBase64EncodedString:self options:NSDataBase64EncodingEndLineWithLineFeed];
    unsigned char cipherTextChar[cipherTextData.length];
    memcpy(cipherTextChar, cipherTextData.bytes, cipherTextData.length);
    //调用解密方法，输出是明文plainOutChar
    unsigned char plainOutChar[cipherTextData.length];
    C_jtsm4CBCDecode(cipherTextData.length, cipherTextChar, plainOutChar,[key UTF8String], [iv UTF8String]);
    
    //明文转成NSData 再转成NSString打印
    NSData *outData = [[NSData alloc]initWithBytes:plainOutChar length:sizeof(plainOutChar)];
    NSString *fstr = [[NSString alloc]initWithData:outData encoding:NSUTF8StringEncoding];
    return [self filte:fstr];
}
- (NSString *)filte:(NSString *)str {
    if (str.length > 0) {
        str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"\0" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        return str;
    } else {
        return @"";
    }
}

#pragma mark - C_CBC
void C_jtsm4CBCEncode(unsigned long lenght,unsigned char in[], unsigned char output[], unsigned char key[] ,unsigned char iv[]){
    sm4_context ctx;
    //设置上下文和密钥
    sm4_setkey_enc(&ctx,key);
    //加密
    sm4_crypt_cbc(&ctx,1,lenght,iv,in,output);
}
void C_jtsm4CBCDecode(unsigned long lenght, unsigned char in[], unsigned char output[], unsigned char key[],unsigned char iv[]){
    sm4_context ctx;
    //设置上下文和密钥
    sm4_setkey_dec(&ctx,key);
    //解密
    sm4_crypt_cbc(&ctx,0,lenght,iv,in,output);
}

#pragma mark - C_ECB
void C_jtsm4ECBEncode(unsigned long lenght,unsigned char in[], unsigned char output[], unsigned char key[]){
    sm4_context ctx;
    //设置上下文和密钥
    sm4_setkey_enc(&ctx,key);
    //加密
    sm4_crypt_ecb(&ctx,1,lenght,in,output);
}
void C_jtsm4ECBDecode(unsigned long lenght, unsigned char in[], unsigned char output[], unsigned char key[]){
    sm4_context ctx;
    //设置上下文和密钥
    sm4_setkey_dec(&ctx,key);
    //解密
    sm4_crypt_ecb(&ctx,0,lenght,in,output);
}
@end
