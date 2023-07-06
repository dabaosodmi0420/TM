//
//  JT_TopSegmentMenuView.h
//  头部类别选择器

#import <UIKit/UIKit.h>


@interface JT_TopSegmentMenuView : UIView

// 点击切换分组按钮回调
@property (nonatomic, copy) void(^clickGroupBtnBlock)(NSString *btnName, NSInteger index);
// 按钮文字大小
@property (nonatomic, strong) UIFont *btnTextFont;
// 按钮文字正常颜色
@property (nonatomic, strong) UIColor *btnTitleNormalColor;
// 按钮文字选中颜色
@property (nonatomic, strong) UIColor *btnTitleSeletColor;
// 按钮背景正常颜色
@property (nonatomic, strong) UIColor *btnBackNormalColor;
// 按钮背景选中颜色
@property (nonatomic, strong) UIColor *btnBackSeletColor;
// 按钮宽度  默认：70.0(宽度超过70，内部自动进行计算)
@property (nonatomic, assign) CGFloat btnWidth;
// 按钮高度  默认：30.0
@property (nonatomic, assign) CGFloat btnHeight;
// 按钮间隔  默认：15.0
@property (nonatomic, assign) CGFloat btnJianGe;
// 按钮标题文字高度（用于计算按钮文字宽度）  默认：20.0
@property (nonatomic, assign) CGFloat btnTitleTextHeight;
// 底部横线是否隐藏
@property (nonatomic, assign) BOOL botLineIsHidden;
// 是否需要圆角
@property (nonatomic, assign) BOOL isCorner;
// 是否均分
@property (nonatomic, assign) BOOL isAverageWidth;

@property (nonatomic, assign) BOOL isHomePage;

/// 创建segment中按钮
/// @param dataArr 按钮标题数据源
/// @param selectIndex 选中的索引，不使用时请传值-1（优先级最高）
/// @param selectSegName 选中的标题
- (void)makeSegmentUIWithSegDataArr:(NSArray<NSString *> *)dataArr selectIndex:(NSInteger)selectIndex selectSegName:(NSString *)selectSegName;

- (void)setSelectIndex:(NSInteger)selectIndex selectSegName:(NSString *)selectSegName;

-(void)reloadColor:(NSInteger)selectIndex;
@end

