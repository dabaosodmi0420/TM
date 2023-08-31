//
//  TM_DeivceActivityViewController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/8/31.
//

#import "TM_DeivceActivityViewController.h"
#import "TM_DataCardManagerViewController.h"
#import "TM_DataCardApiManager.h"
#import "TM_LoginApiManger.h"
@interface TM_DeivceActivityViewController (){
    NSTimer         * _timer;
    NSUInteger        _secondNumber;
}
/* 手机号 */
@property (strong, nonatomic) UITextField       *phoneNumTF;
/* 验证码 */
@property (strong, nonatomic) UITextField       *codeTF;
/* 获取验证码 */
@property (strong, nonatomic) UIButton          *sendCodeBtn;
/* 确定按钮 */
@property (strong, nonatomic) UIButton          *OKBtn;
@end

@implementation TM_DeivceActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 创建UI
- (void)createView {
    /** 顶部View */
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 150)];
    [self.view addSubview:topView];
    [UIView setVerGradualChangingColor:topView colorArr:@[TM_SpecialGlobalColor, TM_ColorRGB(59, 85, 183)]];

    // 更换设备按钮
    UIButton *deviceChange = [UIView createButton:CGRectMake(kScreen_Width - 70, 10, 70, 32) title:@"设备切换" titleColoe:TM_ColorRGB(108, 115, 158) selectedColor:TM_ColorRGB(108, 115, 158) fontSize:14 sel:@selector(deviceChange) target:self];
    deviceChange.backgroundColor = [UIColor whiteColor];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:deviceChange.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(deviceChange.height * 0.5,deviceChange.height * 0.5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = deviceChange.bounds;
    maskLayer.path = maskPath.CGPath;
    deviceChange.layer.mask = maskLayer;
    [topView addSubview:deviceChange];
    
    // 设备号
    UILabel *userCode = [UIView createLabelWithFrame:CGRectMake(0, 55, kScreen_Width, 25) title:@"设备激活" fontSize:21 color:[UIColor whiteColor]];
    userCode.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:userCode];
    UILabel *code = [UIView createLabelWithFrame:CGRectMake(0, topView.height - 32, kScreen_Width, 25) title:@"欢迎您使用此WIFI设备" fontSize:15 color:[UIColor whiteColor]];
    code.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:code];
    
    // 设备编号
    UILabel *label5 = [UIView createLabelWithFrame:CGRectMake(30, topView.maxY + 20, kScreen_Width - 60, 25) title:[NSString stringWithFormat:@"设备编号:%@", self.cardInfoModel.card_define_no] fontSize:19 color:[UIColor darkGrayColor]];
    [label5 sizeToFit];
    [self.view addSubview:label5];
    
    // 手机号输入框
    self.phoneNumTF = [UIView createTextFieldWithFrame:CGRectMake(getAutoWidth(92), label5.maxY + 15, kScreen_Width - 2 * getAutoWidth(92) , getAutoHeight(150))
                                            fontSize:16
                                         placeholder:@"请输入手机号"
                                            isSecure:NO
                                              delegate:self
                                        leftImageName:@""
                                      isShowBottomLine:NO];
    self.phoneNumTF.backgroundColor = TM_ColorHex(@"dddddd");
    [self.phoneNumTF setCornerRadius:10];
    [self.phoneNumTF addTarget:self action:@selector(phoneTextFieldEdit:) forControlEvents:UIControlEventEditingChanged];
    self.phoneNumTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.phoneNumTF];
    
    
    // 验证码输入框
    self.codeTF = [UIView createTextFieldWithFrame:CGRectMake(getAutoWidth(92), self.phoneNumTF.maxY + 15, self.phoneNumTF.width , self.phoneNumTF.height)
                                        fontSize:16
                                     placeholder:@"请输入验证码"
                                        isSecure:NO
                                          delegate:self
                                     leftImageName:@""
                                   isShowBottomLine:NO];
    self.codeTF.backgroundColor = TM_ColorHex(@"dddddd");
    [self.codeTF setCornerRadius:10];
    self.codeTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.codeTF];
    
    // 获取验证码
    UIButton *sendCode = [UIView createButton:CGRectMake(kScreen_Width - getAutoWidth(92) - 80 - 10 , 0, 80, getAutoHeight(110))
                                            title:@"获取验证码"
                                       titleColoe:TM_ColorRGB(59, 85, 183)
                                    selectedColor:TM_ColorRGB(59, 85, 183)
                                         fontSize:15
                                        sel:@selector(sendCodeClick:)
                                       target:self];
    sendCode.centerY = self.codeTF.centerY;
//    sendCode.backgroundColor = TM_SpecialGlobalColor;
    sendCode.layer.cornerRadius = sendCode.height * 0.5;
    sendCode.clipsToBounds = YES;
    [self.view addSubview:sendCode];
    self.sendCodeBtn = sendCode;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(getAutoWidth(150), self.codeTF.maxY + 35, kScreen_Width - getAutoWidth(300), 50)];
    [view setCornerRadius:view.height * 0.5];
    [self.view addSubview:view];
    [UIView setHorGradualChangingColor:view colorArr:@[TM_SpecialGlobalColor, TM_ColorRGB(59, 85, 183)]];
    // 注册
    UIButton *OKBtn = [UIView createButton:view.frame
                                   title:@"激活"
                              titleColoe:TM_ColorRGB(255, 255, 255)
                           selectedColor:TM_ColorRGB(255, 255, 255)
                                fontSize:18
                                     sel:@selector(registerClick:)
                                          target:self];
    OKBtn.backgroundColor = [UIColor clearColor];
    [OKBtn setCornerRadius:OKBtn.height * 0.5];
    [self.view addSubview:OKBtn];
    self.OKBtn = OKBtn;
}
#pragma mark - Activity
// 限制手机号输入个数
- (void)phoneTextFieldEdit:(UITextField*)textfield {
    NSString * tempStr = textfield.text;
    if (textfield == self.phoneNumTF && tempStr.length >= 11){
        textfield.text = [tempStr substringToIndex:11];
    }
}
// 发送验证码
- (void)sendCodeClick:(UIButton *)btn {
    if (self.phoneNumTF.text.length != 11) {
        TM_ShowToast(self.view, @"请输入正确的手机号码");
        return;
    }
    [TM_LoginApiManger sendCodeWithPhoneNum:self.phoneNumTF.text success:^(id  _Nullable respondObject) {
        NSLog(@"%@",respondObject);
        if ([[NSString stringWithFormat:@"%@", respondObject[@"state"]] isEqualToString:@"success"]) {
            [self timerStart];
        }else {
            NSString *msg = [NSString stringWithFormat:@"%@", respondObject[@"info"]];
            TM_ShowToast(self.view, msg);
        }
    } failure:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
        TM_ShowToast(self.view, @"发送验证码失败");
        [self timerEnd];
    }];
}
- (void)registerClick:(UIButton *)btn {
    if (self.phoneNumTF.text.length != 11) {
        TM_ShowToast(self.view, @"请输入正确的手机号码");
        return;
    }
    if (self.codeTF.text.length == 0) {
        TM_ShowToast(self.view, @"请输入验证码");
        return;
    }
    [TM_DataCardApiManager sendDeviceActivityWithPhoneNum:self.phoneNumTF.text card_define_no:self.cardInfoModel.card_define_no code:self.codeTF.text success:^(id  _Nullable respondObject) {
        NSString *msg = [NSString stringWithFormat:@"%@", respondObject[@"info"]];
        if ([[NSString stringWithFormat:@"%@", respondObject[@"state"]] isEqualToString:@"success"]) {
            TM_ShowToast(self.view, msg);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self leftNavItemClick];
            });
        }else {
            TM_ShowToast(self.view, msg);
        }
    } failure:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
        TM_ShowToast(self.view, @"激活失败");
    }];
}
- (void)leftNavItemClick {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)deviceChange {
    NSLog(@"%@",@"设备切换");
    TM_DataCardManagerViewController *vc = [[TM_DataCardManagerViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - NSTimer

- (void)timerStart {
    _secondNumber = 60;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                              target:self
                                            selector:@selector(changeTimeLabelText:)
                                            userInfo:nil
                                             repeats:YES];
    [_timer fire];
}
- (void)timerEnd {
    [self.sendCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    if (_timer) {
        if ([_timer isValid]) {
            [_timer invalidate];
            _timer = nil;
        }
    }
}
- (void)changeTimeLabelText:(NSDictionary *)info {
    if (_secondNumber > 0) {
        [self.sendCodeBtn setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)_secondNumber] forState:UIControlStateNormal];
        self.sendCodeBtn.enabled = NO;
        _secondNumber--;
    }else {
        [self timerEnd];
        self.sendCodeBtn.enabled = YES;
    }
}
@end
