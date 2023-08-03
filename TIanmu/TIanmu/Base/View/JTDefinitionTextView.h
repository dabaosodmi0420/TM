//
//  JTDefinitionTextView.h
//  IOS_108
//
//  Created by Apple on 2017/12/6.
//  Copyright © 2017年 csctest. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JTAlertType) {
    JTAlertTypeNot,
    JTAlertTypeSuccess,
    JTAlertTypeError,
    JTAlertTypeGanTanHao,
    JTAlertTypeWenHao
};

typedef void(^HandlerClick)(NSInteger index);

typedef void (^LinkTextClickHandler)(NSString *scheme);

@interface JTDefinitionTextView : UIView

+ (void)jt_showWithTitle:(NSString *)title
                    Text:(NSString *)text
                    type:(JTAlertType)type
           actionTextArr:(NSArray *)actionTextArr
                 handler:(HandlerClick)handler;

+ (void)jt_showWithTitle:(NSString *)title
                    text:(NSString *)text
             linkTextArr:(NSArray *)linkTextArr
       linkTextSchemeArr:(NSArray *)linkTextSchemeArr
           actionTextArr:(NSArray *)actionTextArr
                 handler:(HandlerClick)handle
    linkTextClickHandler:(LinkTextClickHandler)linkTextClickHandler;

@end
