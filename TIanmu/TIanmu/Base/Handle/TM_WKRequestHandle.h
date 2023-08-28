//
//  TM_WKRequestHandle.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/7/5.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

typedef enum {
    WKRequestType_Remote=0,     // 远程地址
    WKRequestType_LOCAL,        // 加载本地html
}WKRequestType;

NS_ASSUME_NONNULL_BEGIN

@interface TM_WKRequestHandle : NSObject

//请求类型
@property(nonatomic,assign)WKRequestType requestType;
//本地html
@property(nonatomic,strong)NSString * localFile;
//远程url
@property(nonatomic,strong)NSString * remoteUrl;
//加载web
- (void)loadRequestWithWeb:(WKWebView *)wkweb;
@end

NS_ASSUME_NONNULL_END
