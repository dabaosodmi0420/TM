//
//  PrivacyAgreementView.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/8/3.
//

#import "PrivacyAgreementView.h"
#import "TM_AttributeTextView.h"
#import "JTDefinitionTextView.h"
#import "TM_ProtocolViewController.h"
#import "TM_NavigationController.h"

@interface PrivacyAgreementView ()
/*  */
@property (copy, nonatomic) dispatch_block_t completeBlock;
@end

@implementation PrivacyAgreementView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView:frame];
    }
    return self;
}
- (void)createView:(CGRect)frame {
    UIImageView *lanuchImageV = [[UIImageView alloc] initWithFrame:self.bounds];
    lanuchImageV.contentMode = UIViewContentModeScaleAspectFit;
    lanuchImageV.image = [UIImage imageNamed:@"operateGuide0"];
    [self addSubview:lanuchImageV];
    
}
- (void)hideView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        !self->_completeBlock ? : self->_completeBlock();
        [self removeFromSuperview];
    });
}
+ (void)showPrivacyAgreementComplete:(dispatch_block_t)completeBlock {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    NSString *appV = [[NSUserDefaults standardUserDefaults] valueForKeyPath:@"TM_AppVersion"];
    PrivacyAgreementView *private = [[PrivacyAgreementView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    private.completeBlock = completeBlock;
    [keyWindow addSubview:private];
    
    if (![kCurrAppVersion isEqualToString:appV]) {
        [JTDefinitionTextView jt_showWithTitle:@"天目e生活隐私政策"
                                          text:@"欢迎使用天目e生活APP，在您使用前请仔细阅读《天目e生活用户协议》和《隐私协议》,天目e生活将严格遵守您同意的各项条款使用您的信息,以便为您提供更好的服务。点击“同意”意味着您自愿遵守《天目e生活用户协议》和《隐私协议》"
                                   linkTextArr:@[@"《天目e生活用户协议》", @"《隐私协议》"]
                             linkTextSchemeArr:@[@"userProtocal", @"privateProtocal"]
                                 actionTextArr:@[@"同意", @"退出"]
                                       handler:^(NSInteger index) {
            if(index == 0) {
                [[NSUserDefaults standardUserDefaults] setValue:kCurrAppVersion forKeyPath:@"TM_AppVersion"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [private hideView];
            }else {
                exit(0);
            }
        } linkTextClickHandler:^(NSString *scheme) {
            NSString *urlString = @"";
            NSString *title = @"";
            if ([scheme isEqualToString:@"userProtocal"]) {
                // 注册协议
                urlString = @"http://jdwlwm2m.com/custjdwl/trigger/queryUserXY";
                title = @"用户协议";
            }else if ([scheme isEqualToString:@"privateProtocal"]) {
                // 隐私协议
                urlString = @"http://jdwlwm2m.com/custjdwl/trigger/queryAppZC";
                title = @"隐私协议";
            }
            TM_ProtocolViewController *vc = [TM_ProtocolViewController new];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            vc.requestHandle.requestType = WKRequestType_Remote;
            vc.requestHandle.remoteUrl = urlString;
            vc.title = title;
            TM_NavigationController *nav = [[TM_NavigationController alloc] initWithRootViewController:vc];
            [keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
        }];
    }else {
        [private hideView];
    }
}

@end
