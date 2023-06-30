//
//  TM_LoginViewController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/20.
//

#import "TM_LoginViewController.h"
#import "TM_LoginApiManger.h"
#import "TM_RegisterViewController.h"
#import "TM_NavigationController.h"
@interface TM_LoginViewController ()<UITextFieldDelegate>{
    NSTimer         * _timer;
    NSUInteger        _secondNumber;
    BOOL              _isPWLogin; //是否是密码登录
    
}

/* 登录 */
@property (strong, nonatomic) UIButton          *loginMenuBtn;
/* 快捷登录 */
@property (strong, nonatomic) UIButton          *loginQuickMenuBtn;
/* 手机号 */
@property (strong, nonatomic) UITextField       *phoneNumTF;
/* 密码 */
@property (strong, nonatomic) UITextField       *passwordTF;
/* 验证码 */
@property (strong, nonatomic) UITextField       *codeTF;
/* 获取验证码 */
@property (strong, nonatomic) UIButton          *sendCodeBtn;
/* 登录按钮 */
@property (strong, nonatomic) UIButton          *loginBtn;





@end

@implementation TM_LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 默认密码登录
    [self changeLoginType:self.loginMenuBtn];
        
    self.phoneNumTF.text = @"15910906332";
    self.passwordTF.text = @"123456";
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self timerEnd];
}
- (void)createView {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, getAutoHeight(840.0))];
    [self.view addSubview:topView];
    [UIView setHorGradualChangingColor:topView colorArr:@[TM_SpecialGlobalColor, TM_ColorRGB(108, 138, 205)]];
    
    // 顶部logo
    UIImageView *logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,  getAutoWidth(234.0), getAutoWidth(234.0))];
    logoImg.y = getAutoHeight(335.0);
    logoImg.centerX = self.view.centerX;
    logoImg.image = [UIImage imageNamed:@"logo"];
    logoImg.layer.cornerRadius = logoImg.width * 0.5;
    logoImg.clipsToBounds = YES;
    logoImg.contentMode = UIViewContentModeScaleAspectFit;
    logoImg.backgroundColor = [UIColor clearColor];
    [self.view addSubview:logoImg];
    
    // 中间登录View
    CGFloat wh = getAutoWidth(920);
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake((kScreen_Width - wh) * 0.5, CGRectGetMaxY(logoImg.frame) + getAutoHeight(148), wh, wh - 10)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 6;
    contentView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    contentView.layer.shadowOffset = CGSizeMake(0,3.5);
    contentView.layer.shadowOpacity = 0.6;
    contentView.layer.shadowRadius = 3.0;
    contentView.clipsToBounds = NO;
    [self.view addSubview:contentView];
    
    // 登录菜单
    UIButton *loginMenu = [UIView createButton:CGRectMake(0, 0, getAutoWidth(155), getAutoHeight(88))
                                       title:@"登录"
                                  titleColoe:TM_ColorRGB(174, 174, 174)
                               selectedColor:TM_ColorRGB(0, 0, 0)
                                    fontSize:23
                                         sel:@selector(changeLoginType:)
                                        target:self];
    loginMenu.center = CGPointMake(contentView.width * 0.25, getAutoHeight(120));
    loginMenu.selected = YES;
    [contentView addSubview:loginMenu];
    self.loginMenuBtn = loginMenu;
    
    // 快捷登录菜单
    UIButton *loginQuickMenu = [UIView createButton:CGRectMake(0, 0, getAutoWidth(290), getAutoHeight(88))
                                            title:@"快捷登录"
                                       titleColoe:TM_ColorRGB(174, 174, 174)
                                    selectedColor:TM_ColorRGB(0, 0, 0)
                                         fontSize:23
                                              sel:@selector(changeLoginType:)
                                             target:self];
    loginQuickMenu.center = CGPointMake(contentView.width * 0.75, getAutoHeight(120));
    [contentView addSubview:loginQuickMenu];
    self.loginQuickMenuBtn = loginQuickMenu;
    
    // 手机号输入框
    self.phoneNumTF = [UIView createTextFieldWithFrame:CGRectMake(getAutoWidth(92), getAutoHeight(230), contentView.width - 2 * getAutoWidth(92) , getAutoHeight(100))
                                            fontSize:16
                                         placeholder:@"请输入手机号"
                                            isSecure:NO
                                            delegate:self];
    [self.phoneNumTF addTarget:self action:@selector(phoneTextFieldEdit:) forControlEvents:UIControlEventEditingChanged];
    self.phoneNumTF.keyboardType = UIKeyboardTypeNumberPad;
    [contentView addSubview:self.phoneNumTF];
    
    // 密码输入框
    self.passwordTF = [UIView createTextFieldWithFrame:CGRectMake(getAutoWidth(92), getAutoHeight(387), contentView.width - 2 * getAutoWidth(92) , getAutoHeight(100))
                                            fontSize:16
                                         placeholder:@"请输入密码"
                                            isSecure:YES
                                            delegate:self];
    [contentView addSubview:self.passwordTF];
    
    // 验证码输入框
    self.codeTF = [UIView createTextFieldWithFrame:CGRectMake(getAutoWidth(92), getAutoHeight(387), getAutoWidth(480) , getAutoHeight(100))
                                        fontSize:16
                                     placeholder:@"请输入验证码"
                                        isSecure:NO
                                          delegate:self];
    self.codeTF.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTF.hidden = YES;
    [contentView addSubview:self.codeTF];
    
    // 获取验证码
    UIButton *sendCode = [UIView createButton:CGRectMake(0, 0, getAutoWidth(241), getAutoHeight(110))
                                            title:@"获取验证码"
                                       titleColoe:TM_ColorRGB(255, 255, 255)
                                    selectedColor:TM_ColorRGB(255, 255, 255)
                                         fontSize:15
                                        sel:@selector(sendCodeClick:)
                                       target:self];
    sendCode.center = CGPointMake(contentView.width - getAutoWidth(92) - getAutoHeight(241) * 0.5, self.codeTF.centerY);
    sendCode.backgroundColor = TM_SpecialGlobalColor;
    sendCode.layer.cornerRadius = sendCode.height * 0.5;
    sendCode.clipsToBounds = YES;
    [contentView addSubview:sendCode];
    sendCode.hidden = YES;
    self.sendCodeBtn = sendCode;
    
    // 忘记密码
    UIButton *forgetPW = [UIView createButton:CGRectMake(self.sendCodeBtn.x, self.sendCodeBtn.maxY + 15, self.sendCodeBtn.width, 20)
                                      title:@"忘记密码？"
                                 titleColoe:TM_ColorRGB(110, 110, 110)
                              selectedColor:TM_ColorRGB(110, 110, 110)
                                   fontSize:16
                                        sel:@selector(forgetPwClick)
                                       target:self];
    [contentView addSubview:forgetPW];
    
    // 登录
    UIButton *login = [UIView createButton:CGRectMake(getAutoWidth(60), forgetPW.maxY + 15, contentView.width - getAutoWidth(120), self.sendCodeBtn.height)
                                   title:@"登录"
                              titleColoe:TM_ColorRGB(255, 255, 255)
                           selectedColor:TM_ColorRGB(255, 255, 255)
                                fontSize:16
                                     sel:@selector(loginClick:)
                                    target:self];
    login.backgroundColor = TM_SpecialGlobalColor;
    login.layer.cornerRadius = sendCode.height * 0.5;
    login.clipsToBounds = YES;
    [contentView addSubview:login];
    self.loginBtn = login;
    
    UILabel *noAccountL = [UIView createLabelWithFrame:CGRectZero title:@"没有账号？" fontSize:14 color:[UIColor darkGrayColor]];
    [contentView addSubview:noAccountL];
    CGSize size = [noAccountL sizeThatFits:CGSizeMake(MAXFLOAT, 18)];
    CGFloat registerAccountW = 60;
    noAccountL.frame = CGRectMake((contentView.width - size.width - registerAccountW) * 0.5, (contentView.height - self.loginBtn.maxY - size.height) * 0.5 + self.loginBtn.maxY, size.width, size.height);
    // 注册
    UIButton *registerAccount = [UIView createButton:CGRectMake(noAccountL.maxX, noAccountL.y, registerAccountW, size.height)
                                      title:@"立即注册"
                                 titleColoe:TM_SpecialGlobalColor
                              selectedColor:TM_SpecialGlobalColor
                                   fontSize:14
                                        sel:@selector(registerAccountClick)
                                              target:self];
    [contentView addSubview:registerAccount];
    
    // 三方登录
    UILabel *threeL = [UIView createLabelWithFrame:CGRectMake(10, self.view.height - getAutoHeight(377), kScreen_Width - 20, 20) title:@"第三方登录" fontSize:16 color:[UIColor darkGrayColor]];
    threeL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:threeL];
//    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, tf.height - 1, tf.width, 1)];
//    lineView.backgroundColor = TM_ColorRGB(174, 174, 174);
//    [self.view addSubview:lineView];
//    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, tf.height - 1, tf.width, 1)];
//    lineView.backgroundColor = TM_ColorRGB(174, 174, 174);
//    [tf addSubview:lineView];
    
    UIButton *threeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    threeBtn.frame = CGRectMake(0, self.view.height - getAutoHeight(270), getAutoWidth(130), getAutoWidth(130));
    threeBtn.centerX = kScreen_Width * 0.5;
    [threeBtn setImage:[UIImage imageNamed:@"login_third_wechat"] forState:UIControlStateNormal];
    [threeBtn setImage:[UIImage imageNamed:@"login_third_wechat"] forState:UIControlStateHighlighted];
    
    [threeBtn addTarget:self action:@selector(wechatLoginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:threeBtn];
    
    UILabel *threeL1 = [UIView createLabelWithFrame:CGRectMake(10, self.view.height - getAutoHeight(106), kScreen_Width - 20, 20) title:@"Copyright ©2021 天目e生活，AllRights Reserved" fontSize:12 color:[UIColor darkGrayColor]];
    threeL1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:threeL1];
}

#pragma mark - Activity
// 切换登录方式
- (void)changeLoginType:(UIButton *)btn {
    // 是否是密码登录
    _isPWLogin = self.loginMenuBtn == btn;
    
    self.loginMenuBtn.selected = _isPWLogin;
    self.loginQuickMenuBtn.selected = !_isPWLogin;
    self.passwordTF.hidden = !_isPWLogin;
    self.codeTF.hidden = _isPWLogin;
    self.sendCodeBtn.hidden = _isPWLogin;
}
// 登录
- (void)loginClick:(UIButton *)btn {
    if (self.phoneNumTF.text.length != 11) {
        TM_ShowToast(self.view, @"请输入正确的手机号码");
        return;
    }
    if (_isPWLogin && self.passwordTF.text.length == 0) {
        TM_ShowToast(self.view, @"请输入密码");
        return;
    }
    if (!_isPWLogin && self.codeTF.text.length == 0) {
        TM_ShowToast(self.view, @"请输入验证码");
        return;
    }
    [TM_LoginApiManger sendLoginWithPhoneNum:self.phoneNumTF.text password:self.passwordTF.text code:self.codeTF.text isPwLogin:_isPWLogin success:^(id  _Nullable respondObject) {
        NSLog(@"%@",respondObject);
        if ([[NSString stringWithFormat:@"%@", respondObject[@"state"]] isEqualToString:@"success"]) {
            [TM_KeyChainDataDIc tm_addValueToKeyChainDic:[self.phoneNumTF.text tm_sm4_ecb_encryptWithKey:sm4_ecb_key] key:kIdentifierId];
            [TM_SettingManager shareInstance].sIdentifierId = self.phoneNumTF.text;
            [self dismissViewControllerAnimated:YES completion:nil];
        }else {
            NSString *msg = [NSString stringWithFormat:@"%@", respondObject[@"info"]];
            TM_ShowToast(self.view, msg);
        }
    } failure:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
        TM_ShowToast(self.view, @"登录失败");
    }];
    
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
// 忘记密码
- (void)forgetPwClick {
    
}
// 注册
- (void)registerAccountClick {
    TM_RegisterViewController *registerVC = [[TM_RegisterViewController alloc] init];
//    TM_NavigationController *nav = [[TM_NavigationController alloc] initWithRootViewController:registerVC];
    [self.navigationController pushViewController:registerVC animated:YES];
}
// 微信登录
- (void)wechatLoginClick {
    
}
// 限制手机号输入个数
- (void)phoneTextFieldEdit:(UITextField*)textfield {
    NSString * tempStr = textfield.text;
    if (textfield == self.phoneNumTF && tempStr.length >= 11){
        textfield.text = [tempStr substringToIndex:11];
    }
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
