//
//  TM_ForgetPassswordViewController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/26.
//

#import "TM_ForgetPassswordViewController.h"
#import "TM_LoginApiManger.h"

@interface TM_ForgetPassswordViewController ()<UITextFieldDelegate>{
    NSTimer         * _timer;
    NSUInteger        _secondNumber;
}
/* 手机号 */
@property (strong, nonatomic) UITextField       *phoneNumTF;
/* 验证码 */
@property (strong, nonatomic) UITextField       *codeTF;
/* 获取验证码 */
@property (strong, nonatomic) UIButton          *sendCodeBtn;
/* 密码 */
@property (strong, nonatomic) UITextField       *passwordTF;
/* 确认密码 */
@property (strong, nonatomic) UITextField       *passwordAgainTF;

/* 确定按钮 */
@property (strong, nonatomic) UIButton          *OKBtn;
@end

@implementation TM_ForgetPassswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)createView {
    
    self.title = @"忘记密码";
    
    // 手机号输入框
    self.phoneNumTF = [UIView createTextFieldWithFrame:CGRectMake(getAutoWidth(92), 25, kScreen_Width - 2 * getAutoWidth(92) , getAutoHeight(100))
                                            fontSize:16
                                         placeholder:@"请输入手机号"
                                            isSecure:NO
                                              delegate:self
                                        leftImageName:@"login_phone_icon"
                                      isShowBottomLine:YES];
    [self.phoneNumTF addTarget:self action:@selector(phoneTextFieldEdit:) forControlEvents:UIControlEventEditingChanged];
    self.phoneNumTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.phoneNumTF];
    
    
    // 验证码输入框
    self.codeTF = [UIView createTextFieldWithFrame:CGRectMake(getAutoWidth(92), self.phoneNumTF.maxY + 15, getAutoWidth(600) , getAutoHeight(100))
                                        fontSize:16
                                     placeholder:@"请输入手机验证码"
                                        isSecure:NO
                                          delegate:self
                                     leftImageName:@"register_code_icon"
                                   isShowBottomLine:YES];
    self.codeTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.codeTF];
    
    // 获取验证码
    UIButton *sendCode = [UIView createButton:CGRectMake(0, 0, getAutoWidth(241), getAutoHeight(110))
                                            title:@"获取验证码"
                                       titleColoe:TM_SpecialGlobalColor
                                    selectedColor:TM_SpecialGlobalColor
                                         fontSize:15
                                        sel:@selector(sendCodeClick:)
                                       target:self];
    sendCode.center = CGPointMake(kScreen_Width - getAutoWidth(92) - getAutoHeight(241) * 0.5, self.codeTF.centerY);
//    sendCode.backgroundColor = TM_SpecialGlobalColor;
    sendCode.layer.cornerRadius = sendCode.height * 0.5;
    sendCode.clipsToBounds = YES;
    [self.view addSubview:sendCode];
    self.sendCodeBtn = sendCode;
    
    // 密码输入框
    self.passwordTF = [UIView createTextFieldWithFrame:CGRectMake(getAutoWidth(92), self.codeTF.maxY + 15, kScreen_Width - 2 * getAutoWidth(92) , getAutoHeight(100))
                                            fontSize:16
                                         placeholder:@"请输入密码"
                                            isSecure:YES
                                              delegate:self
                                         leftImageName:@"login_pwd_icon"
                                       isShowBottomLine:YES];
    [self.view addSubview:self.passwordTF];
    
    // 确认密码输入框
    self.passwordAgainTF = [UIView createTextFieldWithFrame:CGRectMake(getAutoWidth(92), self.passwordTF.maxY + 15, kScreen_Width - 2 * getAutoWidth(92) , getAutoHeight(100))
                                                 fontSize:16
                                              placeholder:@"请再次输入密码"
                                                 isSecure:YES
                                                   delegate:self
                                              leftImageName:@"login_pwd_icon"
                                            isShowBottomLine:YES];
    [self.view addSubview:self.passwordAgainTF];
    
    // 注册
    UIButton *OKBtn = [UIView createButton:CGRectMake(getAutoWidth(60), self.passwordAgainTF.maxY + 45, kScreen_Width - getAutoWidth(120), self.sendCodeBtn.height)
                                   title:@"确定"
                              titleColoe:TM_ColorRGB(255, 255, 255)
                           selectedColor:TM_ColorRGB(255, 255, 255)
                                fontSize:16
                                     sel:@selector(registerClick:)
                                          target:self];
    OKBtn.backgroundColor = TM_SpecialGlobalColor;
    OKBtn.layer.cornerRadius = sendCode.height * 0.5;
    OKBtn.clipsToBounds = YES;
    [self.view addSubview:OKBtn];
    self.OKBtn = OKBtn;
    
    
}
#pragma mark - activity
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

// 注册
- (void)registerClick:(UIButton *)btn {
    if (self.phoneNumTF.text.length != 11) {
        TM_ShowToast(self.view, @"请输入正确的手机号码");
        return;
    }
    if (self.codeTF.text.length == 0) {
        TM_ShowToast(self.view, @"请输入验证码");
        return;
    }
    if (self.passwordTF.text.length == 0) {
        TM_ShowToast(self.view, @"请输入密码");
        return;
    }
    if (![self.passwordTF.text isEqualToString: self.passwordAgainTF.text]) {
        TM_ShowToast(self.view, @"两次密码不一致，请重新输入密码");
        return;
    }
    
    [TM_LoginApiManger  sendFixPWWithPhoneNum:self.phoneNumTF.text password:self.passwordTF.text code:self.codeTF.text success:^(id  _Nullable respondObject) {
        NSLog(@"%@",respondObject);
        if ([[NSString stringWithFormat:@"%@", respondObject[@"state"]] isEqualToString:@"success"]) {
            TM_ShowToast(self.view, @"修改成功");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self leftNavItemClick];
            });
        }else {
            NSString *msg = [NSString stringWithFormat:@"%@", respondObject[@"info"]];
            TM_ShowToast(self.view, msg);
        }
    } failure:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
        TM_ShowToast(self.view, @"修改失败");
    }];
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
