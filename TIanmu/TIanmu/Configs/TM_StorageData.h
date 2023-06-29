//
//  TM_StorageData.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TM_StorageData : NSObject
//序列化写入缓存
+ (void)archiveData:(NSArray *)array IntoCache:(NSString *)path;
+ (void)archiveDictionaryData:(NSDictionary *)dictionary IntoCache:(NSString *)path;
+ (NSArray *)unarchiveDataFromCache:(NSString *)path;
+ (NSDictionary *)unarchiveDictionaryDataFromCache:(NSString *)path;
+ (void)archiveRootData:(id)rootObject IntoCache:(NSString *)path;
+ (nullable id)unarchiveRootDataFromCache:(NSString *)path;
+ (void)deleteArchiveDataWithPath:(NSString *)path;

/*
 *@brief Dictionary to JsonString
 */
+(NSString *)convertToJsonData:(NSDictionary *)dict options:(NSJSONWritingOptions)options;

@end

NS_ASSUME_NONNULL_END
