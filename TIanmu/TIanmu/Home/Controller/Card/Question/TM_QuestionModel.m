//
//  TM_QuestionModel.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/8/29.
//

#import "TM_QuestionModel.h"

@implementation TM_QuestionModel

- (UIFont *)font {
    return [UIFont systemFontOfSize:17];
}

- (void)setContent:(NSString *)content {
    _content = content;
    CGSize size = [content boundingRectWithSize:CGSizeMake(kScreen_Width - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.font} context:nil].size;
    self.cellHeight = size.height + 20;
}

@end
