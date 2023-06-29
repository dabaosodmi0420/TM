//
//  TM_KeyChain.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/29.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>
NS_ASSUME_NONNULL_BEGIN

@interface TM_KeyChain : NSObject
+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;
@end

NS_ASSUME_NONNULL_END
