//
//  TM_Object.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TM_Object : NSObject <NSCoding,NSCopying>

+ (NSArray *)propertysFromClass;

+ (BOOL)containWithProperty:(NSString *)property;

+ (NSArray *)modelArrayFromJsonArray:(NSArray *)jsonArray;

+ (id)modelDictionaryFromJsonDictionary:(NSDictionary *)jsonDictionary;

@end

NS_ASSUME_NONNULL_END
