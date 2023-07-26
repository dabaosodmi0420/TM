//
//  TM_WXBindViewController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/7/25.
//

#import "TM_WXBindViewController.h"
#import "TM_LoginApiManger.h"

@interface TM_WXBindViewController (){
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

@end

@implementation TM_WXBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self timerEnd];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self createNav];
}
#pragma mark - 创建UI
- (void)createNav {
    [super createNav];
    self.title = @"手机绑定";
    self.view.backgroundColor = TM_SpecialGlobalColorBg;
    // 返回按钮
    UIButton *bind = [UIButton buttonWithType:UIButtonTypeCustom];
    bind.frame = CGRectMake(0, 0, 20, 20);
    [bind setTitle:@"绑定" forState:UIControlStateNormal];
    [bind setTitle:@"绑定" forState:UIControlStateHighlighted];
    bind.titleLabel.font = [UIFont systemFontOfSize:14];
    bind.frame = CGRectMake(0, 0, 30, 30);
    [bind addTarget:self action:@selector(rightNavItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bindItem = [[UIBarButtonItem alloc] initWithCustomView:bind];
    self.navigationItem.rightBarButtonItems = @[ bindItem];

}
- (void)createView {
    
    
    CGFloat itemH = 40;
    NSArray *titleArr = @[@"手机号", @"验证码", @"密 码", @"确认密码"];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 8, kScreen_Width, itemH * titleArr.count)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    
    
    for (int i = 0; i < titleArr.count; i++) {
        
        UILabel *label = [UIView createLabelWithFrame:CGRectMake(0, i * itemH, getAutoWidth(318), itemH) title:titleArr[i] fontSize:15 color:[UIColor darkTextColor]];
        label.textAlignment = NSTextAlignmentCenter;
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, itemH * (i + 1) - 1, contentView.width, 1)];
        lineView.backgroundColor = TM_ColorRGB(200, 200, 200);
        [contentView addSubview:lineView];
        [contentView addSubview:label];
    }
    // 手机号输入框
    self.phoneNumTF = [UIView createTextFieldWithFrame:CGRectMake(getAutoWidth(318), 0, kScreen_Width - getAutoWidth(318) - getAutoWidth(200) - 2 * getAutoWidth(40) , itemH)
                                            fontSize:16
                                         placeholder:@"请输入手机号"
                                            isSecure:NO
                                              delegate:self
                                        leftImageName:@""
                                      isShowBottomLine:YES];
    [self.phoneNumTF addTarget:self action:@selector(phoneTextFieldEdit:) forControlEvents:UIControlEventEditingChanged];
    self.phoneNumTF.keyboardType = UIKeyboardTypeNumberPad;
    [contentView addSubview:self.phoneNumTF];
    
    // 获取验证码
    UIButton *sendCode = [UIView createButton:CGRectMake(self.phoneNumTF.maxX + getAutoWidth(40), 0, getAutoWidth(200), getAutoHeight(60))
                                            title:@"获取验证码"
                                       titleColoe:TM_SpecialGlobalColor
                                    selectedColor:TM_SpecialGlobalColor
                                         fontSize:12
                                        sel:@selector(sendCodeClick:)
                                       target:self];
    sendCode.centerY = self.phoneNumTF.centerY;
//    sendCode.backgroundColor = TM_SpecialGlobalColor;
    sendCode.layer.cornerRadius = sendCode.height * 0.5;
    sendCode.layer.borderColor = TM_SpecialGlobalColor.CGColor;
    sendCode.layer.borderWidth = 0.5;
    sendCode.clipsToBounds = YES;
    [contentView addSubview:sendCode];
    self.sendCodeBtn = sendCode;
    
    // 验证码输入框
    self.codeTF = [UIView createTextFieldWithFrame:CGRectMake(self.phoneNumTF.x, self.phoneNumTF.maxY, kScreen_Width - getAutoWidth(318) -  getAutoWidth(92) , itemH)
                                        fontSize:16
                                     placeholder:@"请输入验证码"
                                        isSecure:NO
                                          delegate:self
                                     leftImageName:@""
                                   isShowBottomLine:NO];
    self.codeTF.keyboardType = UIKeyboardTypeNumberPad;
    [contentView addSubview:self.codeTF];
    
    // 密码输入框
    self.passwordTF = [UIView createTextFieldWithFrame:CGRectMake(self.phoneNumTF.x, self.codeTF.maxY, kScreen_Width - getAutoWidth(318) -  getAutoWidth(92), itemH)
                                            fontSize:16
                                         placeholder:@"请输入密码"
                                            isSecure:YES
                                              delegate:self
                                         leftImageName:@""
                                       isShowBottomLine:NO];
    [contentView addSubview:self.passwordTF];
    
    // 确认密码输入框
    self.passwordAgainTF = [UIView createTextFieldWithFrame:CGRectMake(self.phoneNumTF.x, self.passwordTF.maxY, kScreen_Width - getAutoWidth(318) -  getAutoWidth(92) , itemH)
                                                 fontSize:16
                                              placeholder:@"请再次输入密码"
                                                 isSecure:YES
                                                   delegate:self
                                              leftImageName:@""
                                            isShowBottomLine:NO];
    [contentView addSubview:self.passwordAgainTF];
    
    
    
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

- (void)rightNavItemClick {
    NSLog(@"%@",@"绑定");
    if (self.phoneNumTF.text.length != 11) {
        TM_ShowToast(self.view, @"请输入正确的手机号码");
        return;
    }
    if (self.passwordTF.text.length == 0) {
        TM_ShowToast(self.view, @"请输入密码");
        return;
    }
    if (self.codeTF.text.length == 0) {
        TM_ShowToast(self.view, @"请输入验证码");
        return;
    }
    [TM_LoginApiManger sendBindWXLoginWithPhoneNum:self.phoneNumTF.text password:self.passwordTF.text code:self.codeTF.text wxData:self.wxdata success:^(id  _Nullable respondObject) {
        NSLog(@"%@",respondObject);
        if ([[NSString stringWithFormat:@"%@", respondObject[@"state"]] isEqualToString:@"success"]) {
            TM_ShowToast(self.view, @"绑定成功");
            [TM_KeyChainDataDIc tm_addValueToKeyChainDic:[self.phoneNumTF.text tm_sm4_ecb_encryptWithKey:sm4_ecb_key] key:kIdentifierId];
            [TM_SettingManager shareInstance].sIdentifierId = self.phoneNumTF.text;
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }else {
            NSString *msg = [NSString stringWithFormat:@"%@", respondObject[@"info"]];
            TM_ShowToast(self.view, msg);
        }
    } failure:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
        TM_ShowToast(self.view, @"登录失败");
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
