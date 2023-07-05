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
    if(!self.remoteUrl) return;
    NSString * urlPath = self.remoteUrl;
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlPath]];
    [self.weakWeb loadRequest:request];
}
@end
