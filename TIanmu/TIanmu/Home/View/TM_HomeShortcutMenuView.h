//
//  TM_HomeShortcutMenuView.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/14.
//

#import <UIKit/UIKit.h>
#import "TM_ShortMenuModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TM_HomeShortcutMenuViewDelegate <NSObject>
@optional
// 点击快捷菜单
- (void)clickHomeShortcutMenuWithIndex:(NSUInteger)index;

@end

@interface TM_HomeShortcutMenuView : UIView

/* 代理 */
@property (weak, nonatomic) id<TM_HomeShortcutMenuViewDelegate> delegate;

/* datas */
@property (strong, nonatomic) NSArray<TM_ShortMenuModel *> *dataArray;


@end

NS_ASSUME_NONNULL_END
