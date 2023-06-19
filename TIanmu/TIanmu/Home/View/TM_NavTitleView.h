//
//  TM_NavTitleView.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kNavButtonTag   0x99
#define kScanButtonTag  0x98
#define kNavTitleTag    0x97

@protocol TM_NavTitleViewDelegate <NSObject>

@optional

// 导航栏按钮点击 signs: 1-搜索按钮点击 2-扫一扫
- (void)clickHomeNavTitleViewBtnsWithSigns:(NSString *)signs;

@end

@interface TM_NavTitleView : UIView

@property (nonatomic, weak) id <TM_NavTitleViewDelegate> navTitleViewDelegate;

@end

NS_ASSUME_NONNULL_END
