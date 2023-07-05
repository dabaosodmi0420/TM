//
//  TM_WKRequestHandle.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/7/5.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TM_WKRequestHandle : NSObject
//本地html
@property(nonatomic,strong)NSString * localFile;
//远程url
@property(nonatomic,strong)NSString * remoteUrl;
//加载web
- (void)loadRequestWithWeb:(WKWebView *)wkweb;
@end

NS_ASSUME_NONNULL_END
