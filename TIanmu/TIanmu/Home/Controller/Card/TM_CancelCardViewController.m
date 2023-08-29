//
//  TM_CancelCardViewController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/8/29.
//

#import "TM_CancelCardViewController.h"
#import "TM_DataCardApiManager.h"
@interface TM_CancelCardViewController ()
/* 卡号 */
@property (strong, nonatomic) UITextField       *phoneNumTF;
/* 姓名 */
@property (strong, nonatomic) UITextField       *codeTF;
@end

@implementation TM_CancelCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)createView {
    self.title = @"申请销卡";
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, kScreen_Width, 220)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];

    UILabel *label1 = [UIView createLabelWithFrame:CGRectMake(20, 30, 0, 30) title:@"销卡卡号:" fontSize:16 color:TM_ColorHex(@"222222")];
    [label1 sizeToFit];
    [topView addSubview:label1];
    
    self.phoneNumTF = [UIView createTextFieldWithFrame:CGRectMake(label1.maxX + 8, label1.y, kScreen_Width - label1.maxX - 8 - 10, label1.height)
                                            fontSize:14
                                         placeholder:self.model.card_define_no
                                            isSecure:NO
                                              delegate:self];
    self.phoneNumTF.enabled = NO;
    [topView addSubview:self.phoneNumTF];
    
    UILabel *label2 = [UIView createLabelWithFrame:CGRectMake(20, label1.maxY + 40, 0, 30) title:@"真实姓名:" fontSize:16 color:TM_ColorHex(@"222222")];
    [label2 sizeToFit];
    [topView addSubview:label2];
    
    self.codeTF = [UIView createTextFieldWithFrame:CGRectMake(label2.maxX + 8, label2.y, kScreen_Width - label2.maxX - 8 - 10, label2.height)
                                        fontSize:16
                                     placeholder:@"请输入真实姓名"
                                        isSecure:NO
                                          delegate:self];
    [topView addSubview:self.codeTF];
    
    UIButton *recharge = [UIView createButton:CGRectMake(60, label2.maxY + 40, kScreen_Width - 120, 44)
                                        title:@"提交"
                                   titleColoe:TM_ColorRGB(255, 255, 255)
                                selectedColor:TM_ColorRGB(255, 255, 255)
                                     fontSize:16
                                          sel:@selector(rechargeClick)
                                       target:self];
    recharge.backgroundColor = TM_SpecialGlobalColor;
    [recharge setCornerRadius:10];
    [topView addSubview:recharge];
}

- (void)rechargeClick {
    
    if (self.codeTF.text.length <= 0) {
        TM_ShowToast(self.view, @"请输入真实姓名");
        return;
    }
    
    [TM_DataCardApiManager sendCancelCardWithCardNo:self.model.card_define_no realName:self.codeTF.text success:^(id  _Nullable respondObject) {
        NSString *msg = [NSString stringWithFormat:@"%@", respondObject[@"info"]];
        TM_ShowToast(self.view, msg);
    } failure:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
        TM_ShowToast(self.view, @"销卡失败");
    }];
}
@end
