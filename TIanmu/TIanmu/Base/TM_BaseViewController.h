//
//  TM_BaseViewController.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TM_BaseViewController : UIViewController
- (void)createNav;
- (void)createView;

- (void)showNotOpenAlert;

- (void)leftNavItemClick;
@end

NS_ASSUME_NONNULL_END
