//
//  TM_BasicMacro.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/13.
//

#ifndef TM_BasicMacro_h
#define TM_BasicMacro_h

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

// 颜色
#define TM_ColorRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define TM_ColorHex(s) [UIColor tm_colorWithHexString:s]

#define TM_SpecialGlobalColor TM_ColorRGB(38, 179,223)
#define TM_SpecialGlobalColorBg TM_ColorRGB(241, 241, 241)

// log
#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

// 尺寸
#define iPhoneWidth [UIScreen mainScreen].bounds.size.width
#define iPhoneHeight [UIScreen mainScreen].bounds.size.height

/** 屏幕物理尺寸 **/
#define TM_iPhoneScreenPhysicalWidth ([UIScreen mainScreen].nativeBounds.size.width / [UIScreen mainScreen].scale)
#define TM_iPhoneScreenPhysicalHeight ([UIScreen mainScreen].nativeBounds.size.height / [UIScreen mainScreen].scale)

//是否为放到模式
#define IS_BigMode ([UIScreen mainScreen].nativeBounds.size.width != [UIScreen mainScreen].currentMode.size.width)

// keyWindow
#define kSharedAppDelegateWindow [UIApplication sharedApplication].keyWindow

/** 是否为iPhone X **/
#define iPhoneX     \
({ \
   BOOL tmp = NO;      \
   if (@available(iOS 11.0, *)) { tmp = (kSharedAppDelegateWindow.safeAreaInsets.bottom > 0); } \
   (tmp);              \
})

#define Iphone_Top_UnsafeDis (iPhoneX ? 88 : 64)
#define IphoneX_Bottom_UnsafeDis 34
#define Iphone_UnsafeDis (iPhoneX ? 34 : 0)
#define Iphone_Bottom_UnsafeDis (iPhoneX ? 34 : 0)

//Method
#define kScreen_Bounds ([UIScreen mainScreen].bounds)
#define kScreen_Width ([UIScreen mainScreen].bounds.size.width)
//屏幕高度
#define kScreen_Height ([UIScreen mainScreen].bounds.size.height)
// 横屏时的屏幕宽高
#define kScreen_Width_Hor   (kSystem_Version_Less_Than(@"8.0") ? kScreen_Width : kScreen_Height)     // 横屏时的宽度
#define kScreen_Height_Hor  (kSystem_Version_Less_Than(@"8.0") ? kScreen_Height : kScreen_Width)     // 横屏时的高度
//包含热点栏（如有）高度，标准高度为20pt，当有个人热点连接时，高度为40pt。
#define KSTATUSBAR_HEIGHT ([UIApplication sharedApplication].statusBarFrame.size.height)



//安全区
#define kSafeArea_Insets \
({ \
    UIEdgeInsets tmp = UIEdgeInsetsZero; \
    if (@available(iOS 11.0, *)) { tmp = kSharedAppDelegateWindow.safeAreaInsets; } \
    (tmp);              \
})
#define APP_LINE_WIDTH     (1.0/UIScreen.mainScreen.scale)


//定义设备
#define kDevice_iPad ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)] && [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define kDevice_iphone ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)] && [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define kFullScreeniPad \
({ \
    BOOL tmp = NO;      \
    if (@available(iOS 11.0, *)) { tmp = (kDevice_iPad) && (kSharedAppDelegateWindow.safeAreaInsets.bottom > 0); } \
    (tmp);              \
})

#define kSystem_Version_Equal_To(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define kSystem_Version_Greater_Than(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define kSystem_Version_Greater_Than_Or_Equal_To(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define kSystem_Version_Less_Than(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define kSystem_Version_Less_Than_Or_Equal_To(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define kNavBarH                                ([[UIApplication sharedApplication] statusBarFrame].size.height + kNavigationBarHeight)  //导航栏高度
//width & height
#define kNavigationBarHeight                    44.0f   //导航条高度
#define kToolBarHeight                          44.0f   //工具栏高度
#define kNavi_StatusBarHeight (kNavigationBarHeight + kStatusBarHeight)
#define kTabBarHeight                           (iPhoneX ? 83.0f : 49.0f)   //tabbar高度
#define kTabBarRealHeight                       49.0f                       // tabbar真实高度
#define kStatusBarHeight                        (kSystem_Version_Less_Than(@"13.0") ? [UIApplication sharedApplication].statusBarFrame.size.height : [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height) //iPhone状态栏高度
#define kTabBarBottomMargin                     (iPhoneX ? 34.0f : 0.0f)   //iPhoneX tabbar 下面操作区的高度
#define KSafeAreaTopMargin                      (kNavigationBarHeight + kStatusBarHeight)
#define KKeyBoardBottomMargin                   (iPhoneX ? 34.0f : 0.0f)   //键盘底部的 margin
#define kPickViewHeight                          (kDevice_iPad ?396.0f: 216.0f)  //pickview高度
#define kKeyBoardHeight                         (getAutoSize(220.0f) + KKeyBoardBottomMargin) //自定义数字键盘的高度
#define kDownButton_Width                       60.0f   //键盘消失按钮的宽
#define kDownButton_Height                      38.0f   //键盘消失按钮的高
#define kHangQingPad_Height (kSystem_Version_Less_Than(@"7.0") ? 1.0f : 0.5f) //行情首页、列表等界面在块与块之间有条缝隙、此缝隙的高
// 检测字符串为空, 为空返回yes
#define KCNSSTRING_ISEMPTY(str) (str == nil || [str isEqual:[NSNull null]]||[str isEqualToString:@"(null)"]|| str.length <= 0)

#define kHQMainPad_Width     1.0f                       //行情首页 (中信建投)

#define kBASESCREENHEIGHT 667.0f    //以iPhone6屏size做为基准
#define kBASESCREENWIDTH  375.0f

#define kBaseScreenHeight_Hor   (kSystem_Version_Less_Than(@"8.0") ? kBASESCREENHEIGHT : kBASESCREENWIDTH)    // 横屏时的高度
#define kBaseScreenWidth_Hor    (kSystem_Version_Less_Than(@"8.0") ? kBASESCREENWIDTH : kBASESCREENHEIGHT)     // 横屏时的宽度

#define kWidthScale_Hor         (kScreen_Width_Hor / kBaseScreenWidth_Hor) // 当前屏幕的宽度/基准宽度
#define kHeightScale_Hor         (kScreen_Height_Hor / kBaseScreenHeight_Hor) // 当前屏幕的高度/基准高度

// 屏幕宽高适配比例（X 上如果小于6的比例，强制为6的）
#define kAutoSizeScaleX_ (kDevice_iPad ? 1.2 :(kScreen_Width/kBASESCREENWIDTH < 1.0f ? 1.0f : kScreen_Width/kBASESCREENWIDTH))    //竖屏_X
#define kAutoSizeScale_Hor_X (kScreen_Height/kBASESCREENWIDTH < 1.0f ? 1.0f : kScreen_Height/kBASESCREENWIDTH)//横屏_X

#define kiPadScale_ (kDevice_iPad ? 1.2 : 1.0) //交易使用
#define kAlertVCPreferredStyle  (kDevice_iPad ? UIAlertControllerStyleAlert : UIAlertControllerStyleActionSheet)

#define kAutoSizeScaleY_ kScreen_Height/kBASESCREENHEIGHT    // Y
#define getAutoSize(key) ((NSInteger)(kAutoSizeScaleX_ * (key)))     //竖屏
#define getAutoSize_Y(key) (kAutoSizeScaleY_ * (key))          // Y 竖屏
#define getAutoSize_Hor(key) (kAutoSizeScale_Hor_X * (key))    //横屏
#define getAutoDelSize(key) ((key) / kAutoSizeScaleX_)
#define getAutoSize_Hor_FSView(key) ((kScreen_Height/kBASESCREENWIDTH) * (key))    //分时K线横屏 以6为基准，进行等比例缩放。
    
#define adapt375(x) (kDevice_iPad ? (1.2*x) : (kScreen_Width/kBASESCREENWIDTH*x))  //等比例缩放X
#define adapt667(y) (kDevice_iPad ? (1.2*y) : (kScreen_Height/kBASESCREENHEIGHT*y)) //等比例缩放Y

#define adapt375ForAlert(x) (kDevice_iPad ? (kScreen_Width - 3.0/5.0*kScreen_Width)/2.0 : (adapt375(x))) //iPad弹框宽度适配

#define kStatusBarStyleDark  [tm_PublicMethod statusBarStyleDark]


//内容的高度（除了状态栏、导航栏、底部菜单栏）
#define kContentView_Height kScreen_Height - (KSTATUSBAR_HEIGHT == 40.0f ? 20 + kStatusBarHeight : kStatusBarHeight) - kNavigationBarHeight - kTabBarHeight
// 安全区上下边距的总高度
#define kSafeAreaVerticalMargin (kSystem_Version_Less_Than(@"11.0") ? kStatusBarHeight : (kSharedAppDelegateWindow.safeAreaInsets.top + kSharedAppDelegateWindow.safeAreaInsets.bottom))
// 安全区内容的总高度（除了状态栏、导航栏、底部菜单栏）
#define kSafeAreaContent_Height (kScreen_Height - kNavigationBarHeight - kTabBarRealHeight - kSafeAreaVerticalMargin)

//当前系统内部开发版本号(build)
#define kCurrAppBuild [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];

//当前系统发布版本号(version)
#define kCurrAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

//当前app的名称
#define kCurrAppName [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]

//设备判断
#define iPhone4         (kScreen_Width == 320.0f && kScreen_Height == 480.0f ? YES : NO)
#define iPhone5         (kScreen_Width == 320.0f && kScreen_Height == 568.0f ? YES : NO)
#define iPhone6         (kScreen_Width == 375.0f && kScreen_Height == 667.0f ? YES : NO)
#define iPhone6Plus     (kScreen_Width == 414.0f && kScreen_Height == 736.0f ? YES : NO)
#define iPhone4_5       (kScreen_Width == 320.0f && kAutoSizeScaleX_ == 1.0f ? YES : NO)
#define iPad6           (kScreen_Width == 320.0f && kScreen_Height == 480.0f ? YES : NO)
#define iPadMini6       (kScreen_Width == 744.0f && kScreen_Height == 1133.0f ? YES : NO)
#define iPad            ([[tm_SettingManager shareInstance].phoneType containsString:@"iPad"])

// 适配尺寸
#define getAutoWidth(w) ((w) / 1072.0 * kScreen_Width)
#define getAutoHeight(h) ((h) / 2400.0 * kScreen_Height)

#endif /* TM_BasicMacro_h */
