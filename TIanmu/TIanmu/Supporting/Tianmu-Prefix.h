//
//  Tianmu-Prefix.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/13.
//

#ifndef Tianmu_Prefix_h
#define Tianmu_Prefix_h

#import "TM_BasicMacro.h"
#import "TM_ClassName.h"
#import "UIView+TM_Frame.h"
#import "UIColor+TM_HexToUIColor.h"
#import "UIImage+TM_Category.h"
#import "UIImageView+TM_Category.h"
#import "UILabel+TM_Category.h"
#import "UIView+TM_Category.h"

#import <YYImage/YYImage.h>
#import <YYWebImage/YYWebImage.h>
#import <MJExtension/MJExtension.h>
#import <SDCycleScrollView/SDCycleScrollView.h>
#import <MJRefresh/MJRefresh.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <SDWebImage/SDWebImage.h>
#import <Masonry/Masonry.h>

#define TM_ShowToast(v, m) \
({ \
MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:v]; \
hud.mode = MBProgressHUDModeText; \
hud.label.text = m; \
hud.removeFromSuperViewOnHide = YES; \
[hud showAnimated:YES]; \
[hud hideAnimated:YES afterDelay:1.5];\
[v addSubview:hud];\
})

#endif /* Tianmu_Prefix_h */
