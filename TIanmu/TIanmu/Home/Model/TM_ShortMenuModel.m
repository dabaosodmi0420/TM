//
//  TM_ShortMenuModel.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/16.
//

#import "TM_ShortMenuModel.h"

@implementation TM_ShortMenuModel

- (TM_ShortMenuType)funcType {
    TM_ShortMenuType type = TM_ShortMenuTypeDefault;
    
    if ([self.funcCode isEqualToString:@"rechargeBalance"]) {
        type = TM_ShortMenuTypeBalanceRecharge;
    }else if ([self.funcCode isEqualToString:@"orderFlow"]) {
        type = TM_ShortMenuTypeFlowRecharge;
    }else if ([self.funcCode isEqualToString:@"control"]) {
        type = TM_ShortMenuTypeRemoteControl;
    }else if ([self.funcCode isEqualToString:@"changeNet"]) {
        type = TM_ShortMenuTypeNetChange;
    }else if ([self.funcCode isEqualToString:@"auth"]) {
        type = TM_ShortMenuTypeRealNameAuth;
    }else if ([self.funcCode isEqualToString:@"tradeRecord"]) {
        type = TM_ShortMenuTypeTransactionRecord;
    }else if ([self.funcCode isEqualToString:@"electronicWaste"]) {
        type = TM_ShortMenuTypeElectronicWaste;
    }else if ([self.funcCode isEqualToString:@"newGuide"]) {
        type = TM_ShortMenuTypeNewGuide;
    }else if ([self.funcCode isEqualToString:@"weChatService"]) {
        type = TM_ShortMenuTypeService;
    }else if ([self.funcCode isEqualToString:@"updateApp"]) {
        type = TM_ShortMenuTypeUpdate;
    }else if ([self.funcCode isEqualToString:@"taocanUsed"]) {
        type = TM_ShortMenuTypeTaocanUsed;
    }else if ([self.funcCode isEqualToString:@"guzhangFix"]) {
        type = TM_ShortMenuTypeGuzhang;
    }else if ([self.funcCode isEqualToString:@"cancelCard"]) {
        type = TM_ShortMenuTypeCancelCard;
    }else if ([self.funcCode isEqualToString:@"question"]) {
        type = TM_ShortMenuTypeQuestion;
    }
    
    return type;
}

@end
