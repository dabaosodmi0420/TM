//
//  TM_NetworkTool+TM_Extension.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/21.
//

#import "TM_NetworkTool+TM_Extension.h"
#import <CommonCrypto/CommonCrypto.h>

#define TM_Token_SECRET_KEY  @"3cdee8a17c4dee399abcac31015676bc"

@implementation TM_NetworkTool (TM_Extension)
//sha256加密方式
- (NSString *)getSha256String:(NSString *)input {
    const char* str = [input UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, (CC_LONG)strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++) {
        //输出格式：占位为2的十六进制
        [ret appendFormat:@"%02x",result[i]];
    }
    //大写
    ret = (NSMutableString *)[ret uppercaseString];
    
    return ret;
}
- (NSString *)getTimeStamp {
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970] * 1000;
    NSString *timeString = [NSString stringWithFormat:@"%.0lf", a];
    return timeString;
}
- (NSString *)getToken:(NSDictionary *)param {
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *content = [json stringByAppendingString:TM_Token_SECRET_KEY];
    NSString *encrypt = [self getSha256String:content];
    return encrypt;
}

@end
