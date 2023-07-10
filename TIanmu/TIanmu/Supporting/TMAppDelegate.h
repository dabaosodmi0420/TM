//
//  AppDelegate.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/12.
//

#import <UIKit/UIKit.h>
#import <WXApi.h>

@interface TMAppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate>

/** UIWindow **/
@property (nonatomic, strong) UIWindow *window;

@end
