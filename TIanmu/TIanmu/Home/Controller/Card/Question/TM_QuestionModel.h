//
//  TM_QuestionModel.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/8/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TM_QuestionModel : NSObject
/* 字体 */
@property (strong, nonatomic, readonly) UIFont *font;

@property (copy, nonatomic)     NSString    *title;
@property (copy, nonatomic)     NSString    *content;
@property (nonatomic, assign)   BOOL        isExpand;    //是否展开
@property (nonatomic, assign)   CGFloat     cellHeight;  //cell高度
@end

NS_ASSUME_NONNULL_END
