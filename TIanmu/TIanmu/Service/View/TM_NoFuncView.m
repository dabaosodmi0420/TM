//
//  TM_NoFuncView.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/7/11.
//

#import "TM_NoFuncView.h"

@implementation TM_NoFuncView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}
- (void)createView {
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.width / 259 * 271)];
    img.image = [UIImage imageNamed:@"icon_thing_no_bg"];
    img.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:img];
    
    UILabel *l = [UIView createLabelWithFrame:CGRectMake(0, img.maxY + 15, self.width, 20) title:@"功能暂未开启" fontSize:14 color:TM_ColorHex(@"aaaaaa")];
    l.textAlignment = NSTextAlignmentCenter;
    [self addSubview:l];
    
    self.height = l.maxY + 5;
}

@end
