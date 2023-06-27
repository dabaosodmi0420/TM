//
//  TM_RegisterViewController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/26.
//

#import "TM_RegisterViewController.h"
#import "TM_LoginApiManger.h"
#import "TM_AttributeTextView.h"


@interface TM_RegisterViewController ()<UITextFieldDelegate, TM_AttributeTextViewDelegate>{
    NSTimer         * _timer;
    NSUInteger        _secondNumber;
}
/* 手机号 */
@property (strong, nonatomic) UITextField       *phoneNumTF;
/* 密码 */
@property (strong, nonatomic) UITextField       *passwordTF;
/* 确认密码 */
@property (strong, nonatomic) UITextField       *passwordAgainTF;
/* 验证码 */
@property (strong, nonatomic) UITextField       *codeTF;
/* 获取验证码 */
@property (strong, nonatomic) UIButton          *sendCodeBtn;
/* 同意协议按钮 */
@property (strong, nonatomic) UIButton          *agreeBtn;
/* 协议 */
@property (strong, nonatomic) TM_AttributeTextView  *attributeTV;


/* 注册按钮 */
@property (strong, nonatomic) UIButton          *registerBtn;
@end

@implementation TM_RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self timerEnd];
}

- (void)createView {
    [self setGradualChangingColor:self.view colorArr:@[TM_SpecialGlobalColor, TM_ColorRGB(108, 138, 205)]];
    
    // 返回按钮
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(20, iPhoneX ? 52 : 30, 30, 30);
    [returnBtn setImage:[UIImage imageNamed:@"back_white_icon"] forState:UIControlStateNormal];
    [returnBtn setImage:[UIImage imageNamed:@"back_white_icon"] forState:UIControlStateHighlighted];
    [returnBtn addTarget:self action:@selector(leftNavItemClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtn];
    
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
    
    UILabel *tLabel = [self createLabelWithFrame:CGRectMake(getAutoWidth(92), 20, 50, 30) title:@"注册" fontSize:23 color:[UIColor blackColor]];
    tLabel.textAlignment = NSTextAlignmentLeft;
    [contentView addSubview:tLabel];
    
    // 手机号输入框
    self.phoneNumTF = [self createTextFieldWithFrame:CGRectMake(getAutoWidth(92), tLabel.maxY + 15, contentView.width - 2 * getAutoWidth(92) , getAutoHeight(100))
                                            fontSize:16
                                         placeholder:@"请输入手机号"
                                            isSecure:NO];
    [self.phoneNumTF addTarget:self action:@selector(phoneTextFieldEdit:) forControlEvents:UIControlEventEditingChanged];
    self.phoneNumTF.keyboardType = UIKeyboardTypeNumberPad;
    [contentView addSubview:self.phoneNumTF];
    
    
    // 验证码输入框
    self.codeTF = [self createTextFieldWithFrame:CGRectMake(getAutoWidth(92), self.phoneNumTF.maxY + 15, getAutoWidth(480) , getAutoHeight(100))
                                        fontSize:16
                                     placeholder:@"请输入手机验证码"
                                        isSecure:NO];
    self.codeTF.keyboardType = UIKeyboardTypeNumberPad;
    [contentView addSubview:self.codeTF];
    
    // 获取验证码
    UIButton *sendCode = [self createButton:CGRectMake(0, 0, getAutoWidth(241), getAutoHeight(110))
                                            title:@"获取验证码"
                                       titleColoe:TM_ColorRGB(255, 255, 255)
                                    selectedColor:TM_ColorRGB(255, 255, 255)
                                         fontSize:15
                                        sel:@selector(sendCodeClick:)];
    sendCode.center = CGPointMake(contentView.width - getAutoWidth(92) - getAutoHeight(241) * 0.5, self.codeTF.centerY);
    sendCode.backgroundColor = TM_SpecialGlobalColor;
    sendCode.layer.cornerRadius = sendCode.height * 0.5;
    sendCode.clipsToBounds = YES;
    [contentView addSubview:sendCode];
    self.sendCodeBtn = sendCode;
    
    // 密码输入框
    self.passwordTF = [self createTextFieldWithFrame:CGRectMake(getAutoWidth(92), self.codeTF.maxY + 15, contentView.width - 2 * getAutoWidth(92) , getAutoHeight(100))
                                            fontSize:16
                                         placeholder:@"请输入密码"
                                            isSecure:YES];
    [contentView addSubview:self.passwordTF];
    
    // 确认密码输入框
    self.passwordAgainTF = [self createTextFieldWithFrame:CGRectMake(getAutoWidth(92), self.passwordTF.maxY + 15, contentView.width - 2 * getAutoWidth(92) , getAutoHeight(100))
                                                 fontSize:16
                                              placeholder:@"请再次输入密码"
                                                 isSecure:YES];
    [contentView addSubview:self.passwordAgainTF];
    
    UIButton *agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeBtn.frame = CGRectMake(self.passwordAgainTF.x, self.passwordAgainTF.maxY + 15, 15, 15);
    [agreeBtn setImage:[UIImage imageNamed:@"register_select_default_icon"] forState:UIControlStateNormal];
    [agreeBtn setImage:[UIImage imageNamed:@"register_select_default_icon"] forState:UIControlStateHighlighted];
    [agreeBtn setImage:[UIImage imageNamed:@"register_selected_icon"] forState:UIControlStateSelected];
    [agreeBtn addTarget:self action:@selector(agreeClick:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:agreeBtn];
    self.agreeBtn = agreeBtn;
    
    TM_AttributeTextView *attributeTV = [[TM_AttributeTextView alloc] initWithFrame:CGRectMake(self.agreeBtn.maxX + 10, self.agreeBtn.y , contentView.width - self.agreeBtn.maxX - 10 - getAutoWidth(92), 30)];
    attributeTV.text = @"我已阅读并同意《天目e生活用户协议》和《隐私协议》";
    attributeTV.font = [UIFont systemFontOfSize:14];
    attributeTV.textColor = TM_ColorHex(@"#888888");
    attributeTV.linkColor = TM_SpecialGlobalColor;
    attributeTV.linkTextArr = @[@"《天目e生活用户协议》", @"《隐私协议》"];
    attributeTV.linkTextSchemeArr = @[@"userProtocal", @"privateProtocal"];
    attributeTV.delegate = self;
    attributeTV.isSizeToFit = YES;
    [contentView addSubview:attributeTV];
    self.attributeTV = attributeTV;
    
    // 注册
    UIButton *registerBtn = [self createButton:CGRectMake(getAutoWidth(60), self.attributeTV.maxY + 10, contentView.width - getAutoWidth(120), self.sendCodeBtn.height)
                                   title:@"登录"
                              titleColoe:TM_ColorRGB(255, 255, 255)
                           selectedColor:TM_ColorRGB(255, 255, 255)
                                fontSize:16
                                     sel:@selector(registerClick:)];
    registerBtn.backgroundColor = TM_SpecialGlobalColor;
    registerBtn.layer.cornerRadius = sendCode.height * 0.5;
    registerBtn.clipsToBounds = YES;
    [contentView addSubview:registerBtn];
    self.registerBtn = registerBtn;
    
    UILabel *hasAccountL = [self createLabelWithFrame:CGRectZero title:@"已有账号？" fontSize:14 color:[UIColor darkGrayColor]];
    [contentView addSubview:hasAccountL];
    CGSize size = [hasAccountL sizeThatFits:CGSizeMake(MAXFLOAT, 18)];
    CGFloat registerAccountW = 60;
    hasAccountL.frame = CGRectMake((contentView.width - size.width - registerAccountW) * 0.5, self.registerBtn.maxY + 15, size.width, size.height);
    
    UIButton *returnLogin = [self createButton:CGRectMake(hasAccountL.maxX, hasAccountL.y, registerAccountW, size.height)
                                      title:@"立即登录"
                                 titleColoe:TM_SpecialGlobalColor
                              selectedColor:nil
                                   fontSize:14
                                        sel:@selector(leftNavItemClick)];
    [contentView addSubview:returnLogin];
    
    contentView.height = hasAccountL.maxY + 15;
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
    
    [TM_LoginApiManger  sendRegisterWithPhoneNum:self.phoneNumTF.text password:self.passwordTF.text code:self.codeTF.text success:^(id  _Nullable respondObject) {
        NSLog(@"%@",respondObject);
        if ([[NSString stringWithFormat:@"%@", respondObject[@"state"]] isEqualToString:@"success"]) {
            [self leftNavItemClick];
        }else {
            NSString *msg = [NSString stringWithFormat:@"%@", respondObject[@"info"]];
            TM_ShowToast(self.view, msg);
        }
    } failure:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
        TM_ShowToast(self.view, @"发送验证码失败");
    }];
}

// 返回
- (void)leftNavItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

// 协议同意按钮
- (void)agreeClick:(UIButton *)btn {
    self.agreeBtn.selected = !self.agreeBtn.isSelected;
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

#pragma mark - TM_AttributeTextViewDelegate
- (void)tm_attributeTextView:(TM_AttributeTextView *)attributeTextView linkScheme:(NSString *)scheme {
    NSLog(@"%@",scheme);
}
- (void)tm_attributeTextView:(TM_AttributeTextView *)attributeTextView linkClickIndex:(NSUInteger)index {
    NSLog(@"%@",@(index));
}
- (void)tm_attributeTextViewClick:(TM_AttributeTextView *)attributeTextView {
    NSLog(@"%@",@"点击");
    [self agreeClick:self.agreeBtn];
}

#pragma mark - 创建控件
- (UIButton *)createButton:(CGRect)frame title:(NSString *)title titleColoe:(UIColor *)titleColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize sel:(SEL)sel{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    btn.titleEdgeInsets = UIEdgeInsetsZero;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor: titleColor forState:UIControlStateNormal];
    [btn setTitleColor: titleColor forState:UIControlStateHighlighted];
    if (selectedColor) {
        [btn setTitleColor: selectedColor forState:UIControlStateSelected];
    }
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UITextField *)createTextFieldWithFrame:(CGRect)frame fontSize:(CGFloat)fontSize placeholder:(NSString *)placeholder isSecure:(BOOL)isSecure{
    UITextField *tf = [[UITextField alloc] initWithFrame:frame];
    tf.delegate = self;
    tf.font = [UIFont systemFontOfSize:fontSize];
    tf.textColor = [UIColor blackColor];
    tf.placeholder = placeholder;
    [tf setSecureTextEntry:isSecure];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:TM_ColorRGB(174, 174, 174),
                    NSFontAttributeName:tf.font
            }];
    tf.attributedPlaceholder = attrString;

    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, tf.height - 1, tf.width, 1)];
    lineView.backgroundColor = TM_ColorRGB(174, 174, 174);
    [tf addSubview:lineView];
    return tf;
}

- (UILabel *)createLabelWithFrame:(CGRect)frame title:(NSString *)title fontSize:(CGFloat)fontSize color:(UIColor *)color{
    UILabel *t = [[UILabel alloc] initWithFrame:frame];
    t.text = title;
    t.textColor = color;
    t.font = [UIFont systemFontOfSize:fontSize];
    return t;
}

- (void)setGradualChangingColor:(UIView *)view colorArr:(NSArray *)colorArr{
    //    CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    
    NSMutableArray *temps = [NSMutableArray arrayWithCapacity:0];
    for (int i=0; i<colorArr.count; i++) {
        UIColor *tempColor = colorArr[i];
        [temps addObject:(__bridge id)tempColor.CGColor];
    }
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = temps;
    
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    
    //  设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0,@1];
    
    [view.layer addSublayer:gradientLayer];
}
@end
