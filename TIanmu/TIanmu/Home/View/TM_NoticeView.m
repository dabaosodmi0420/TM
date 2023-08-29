//
//  TM_NoticeView.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/8/29.
//

#import "TM_NoticeView.h"

@interface TM_NoticeView()
/* <#descript#> */
@property (strong, nonatomic) NSString *content;

@end
@implementation TM_NoticeView
- (instancetype)initWithFrame:(CGRect)frame content:(NSString *)content{
    if (self = [super initWithFrame:frame]) {
        self.content = content;
        [self createView:frame];
    }
    return self;
}
- (void)createView:(CGRect)frame {
    UILabel *l1 = [UIView createLabelWithFrame:CGRectMake(0, 0, frame.size.width, 30) title:@"注意事项" fontSize:19 color:TM_ColorHex(@"000000")];
    l1.textAlignment = NSTextAlignmentLeft;
    [self addSubview:l1];
    
    UIFont *font = [UIFont systemFontOfSize:16];
    CGFloat height = [self.content boundingRectWithSize:CGSizeMake(self.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size.height;
    UILabel *l2 = [UIView createLabelWithFrame:CGRectMake(0, l1.maxY + 5, frame.size.width, height) title:self.content fontSize:16 color:TM_ColorHex(@"555555")];
    l2.numberOfLines = 0;
    l2.textAlignment = NSTextAlignmentLeft;
    [self addSubview:l2];
    
    self.height = l2.maxY + 10;
}

@end
