//
//  TM_StorageData.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/28.
//

#import "TM_StorageData.h"

@implementation TM_StorageData
static dispatch_queue_t queue;
//序列化写入缓存
+ (void)archiveData:(NSArray *)array IntoCache:(NSString *)path
{
    [self archiveRootData:array IntoCache:path];
}

+ (NSArray *)unarchiveDataFromCache:(NSString *)path {
    return [self unarchiveRootDataFromCache:path];
}

+ (void)archiveDictionaryData:(NSDictionary *)dictionary IntoCache:(NSString *)path {
    [self archiveRootData:dictionary IntoCache:path];
}

+ (NSDictionary *)unarchiveDictionaryDataFromCache:(NSString *)path {
    return [self unarchiveRootDataFromCache:path];
}

+ (void)archiveRootData:(id)rootObject IntoCache:(NSString *)path {
    NSArray *myPathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *myPath    = [myPathList  objectAtIndex:0];
    
    myPath = [myPath stringByAppendingPathComponent:path];
    if(![[NSFileManager defaultManager] fileExistsAtPath:myPath])
    {
        NSFileManager *fileManager = [NSFileManager defaultManager ];
        [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL];
        [[NSFileManager defaultManager] createFileAtPath:myPath contents:nil attributes:nil];
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:rootObject];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.tmlive.archive", NULL);
    });
    
    dispatch_sync(queue, ^{
        if(![data writeToFile:myPath atomically:YES])
        {
            
        }
    });
    //dispatch_release(queue);
}

+ (nullable id)unarchiveRootDataFromCache:(NSString *)path {
    NSArray *myPathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *myPath    = [myPathList  objectAtIndex:0];
    NSData *fData       = nil;
    
    myPath = [myPath stringByAppendingPathComponent:path];
    if([[NSFileManager defaultManager] fileExistsAtPath:myPath])
    {
        fData = [NSData dataWithContentsOfFile:myPath];
    }
    else
    {
    }
    if (fData == nil ) {
        return nil;
    }
    return [NSKeyedUnarchiver unarchiveObjectWithData:fData];
}

+ (void)deleteArchiveDataWithPath:(NSString *)path
{
    NSArray *myPathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *myPath    = [myPathList  objectAtIndex:0];
    NSError *err        = nil;
    
    myPath = [myPath stringByAppendingPathComponent:path];
    
    [[NSFileManager defaultManager] removeItemAtPath:myPath error:&err];
}

+(NSString *)convertToJsonData:(NSDictionary *)dict options:(NSJSONWritingOptions)options;
{
    
    NSError *error;
    /*
     * NSJSONWritingPrettyPrinted
     */
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:options error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}

@end
