//
//  TM_AddDeviceViewController.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/7/12.
//

#import "TM_AddDeviceViewController.h"
#import "TM_DataCardApiManager.h"

@interface TM_AddDeviceViewController ()
/* 输入框 */
@property (strong, nonatomic) UITextField *tf;


@end

@implementation TM_AddDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
#pragma mark - 创建UI
- (void)createView {
    self.title = @"流量卡绑定";
    // 712056132 868723043758901
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, kScreen_Width - 40, 30)];
    tf.keyboardType = UIKeyboardTypeNumberPad;
    tf.font = [UIFont systemFontOfSize:14];
    tf.textColor = [UIColor blackColor];
    tf.placeholder = @"请输入卡号";
    tf.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:tf];
    self.tf = tf;
    
    UIButton *OK = [UIView createButton:CGRectMake(tf.x, tf.maxY + 16, tf.width, 40)
                                  title:@"确认"
                             titleColoe:[UIColor whiteColor]
                          selectedColor:[UIColor whiteColor]
                               fontSize:15
                                    sel:@selector(OKClick)
                                 target:self];
    OK.backgroundColor = TM_SpecialGlobalColor;
    OK.layer.masksToBounds = YES;
    OK.layer.cornerRadius = 5;
    [self.view addSubview:OK];
    
    UILabel *label = [UIView createLabelWithFrame:CGRectMake(OK.x, OK.maxY + 6, OK.width, 30) title:@"温馨提示：系统会自动记住您最近绑定的卡号" fontSize:14 color:TM_ColorHex(@"#555555")];
    [self.view addSubview:label];
}

- (void)OKClick {
    if (self.tf.text.length == 0) {
        TM_ShowToast(self.view, @"请输入流量卡号");
        return;
    }
    [TM_DataCardApiManager sendUserBindCardWithPhoneNum:[TM_SettingManager shareInstance].sIdentifierId CardNo:self.tf.text success:^(id  _Nullable respondObject) {
        if ([[NSString stringWithFormat:@"%@", respondObject[@"state"]] isEqualToString:@"success"]) {
            TM_ShowToast(self.view, @"添加成功");
            self.tf.text = @"";
            if (self.refreshDataBlock) {
                self.refreshDataBlock();
            }
        }else {
            NSString *msg = [NSString stringWithFormat:@"%@", respondObject[@"info"]];
            TM_ShowToast(self.view, msg);
        }
    } failure:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
        TM_ShowToast(self.view, @"添加失败");
    }];
    
    
}

@end
