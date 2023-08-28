//
//  TM_WKRequestHandle.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/7/5.
//

#import "TM_WKRequestHandle.h"


@interface TM_WKRequestHandle()

@property(nonatomic,weak)WKWebView * weakWeb;

@end

@implementation TM_WKRequestHandle
//加载web
- (void)loadRequestWithWeb:(WKWebView *)wkweb{
    self.weakWeb = wkweb;
    
    switch (self.requestType) {
        case WKRequestType_Remote:
            [self loadRemoteUrl];
            break;
        case WKRequestType_LOCAL:
            [self loadDocumentHtmlFile];
            break;
        default:
            break;
    }
    
    
}

- (void)loadRemoteUrl {
    if(!self.remoteUrl) return;
    NSString * urlPath = self.remoteUrl;
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlPath]];
    [self.weakWeb loadRequest:request];
}

//加载本地文件
- (void)loadDocumentHtmlFile{
    if(!self.localFile) return;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:self.localFile]];
    [self.weakWeb loadRequest:request];
}

@end
