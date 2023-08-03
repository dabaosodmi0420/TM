//
//  TM_AttributeTextView.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TM_AttributeTextView;

@protocol TM_AttributeTextViewDelegate <NSObject>
@optional
// 点击文本回调
- (void)tm_attributeTextViewClick:(TM_AttributeTextView *)attributeTextView;
// 点击链接索引回调
- (void)tm_attributeTextView:(TM_AttributeTextView *)attributeTextView linkClickIndex:(NSUInteger)index;
// 设置 linkTextSchemeArr 后 点击链接 scheme 回调
- (void)tm_attributeTextView:(TM_AttributeTextView *)attributeTextView linkScheme:(NSString *)scheme;
@end

@interface TM_AttributeTextView : UIView
/* 代理 */
@property (weak, nonatomic)     id<TM_AttributeTextViewDelegate> delegate;
/* text */
@property (copy, nonatomic)     NSString    *text;
/* textColoe */
@property (strong, nonatomic)   UIColor     *textColor;
/* font */
@property (strong, nonatomic)   UIFont      *font;
/* linkfont */
@property (strong, nonatomic)   UIFont      *linkFont;
/* 链接颜色 */
@property (nonatomic, strong)   UIColor     *linkColor;
/* 链接文本数组 */
@property (strong, nonatomic)   NSArray <NSString *>    *linkTextArr;
/* 链接文本scheme数组  */
@property (strong, nonatomic)   NSArray <NSString *>    *linkTextSchemeArr;
/* 是否自适应高度 */
@property (assign, nonatomic)   BOOL        isSizeToFit;

//@property (nonatomic, assign)   unichar     characterSpacing;   // 字距
//@property (nonatomic, assign)   CGFloat     linesSpacing;       // 行距
//@property (nonatomic, assign)   CGFloat     paragraphSpacing;   // 段落间距
//
//@property (nonatomic, assign)   CTTextAlignment textAlignment;  // 文本对齐方式 kCTTextAlignmentLeft
//@property (nonatomic, assign)   CTLineBreakMode lineBreakMode;  // 换行模式 kCTLineBreakByCharWrapping

@end

NS_ASSUME_NONNULL_END
