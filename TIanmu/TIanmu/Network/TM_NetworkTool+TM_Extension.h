//
//  TM_NetworkTool+TM_Extension.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/21.
//

#import "TM_NetworkTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface TM_NetworkTool (TM_Extension)
// sha256加密方式
- (NSString *)getSha256String:(NSString *)srcString;
// 获取时间戳
- (NSString *)getTimeStamp;
// 获取token
- (NSString *)getToken:(NSDictionary *)param;
// 获取token 传入json
- (NSString *)getTokenWithString:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
