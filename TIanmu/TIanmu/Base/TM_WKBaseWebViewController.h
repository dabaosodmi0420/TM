//
//  TM_WKBaseWebViewController.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/7/5.
//

#import "TM_BaseViewController.h"
#import <WebKit/WebKit.h>
#import "TM_WKRequestHandle.h"
NS_ASSUME_NONNULL_BEGIN

@interface TM_WKBaseWebViewController : TM_BaseViewController <WKScriptMessageHandler,WKNavigationDelegate,WKUIDelegate>

/** WKWebView */
@property(nonatomic,strong,readonly )WKWebView * webView;
/* title */
@property (copy, nonatomic) NSString *titleString;


//处理请求
@property(nonatomic,strong)TM_WKRequestHandle * requestHandle;




@end

NS_ASSUME_NONNULL_END
