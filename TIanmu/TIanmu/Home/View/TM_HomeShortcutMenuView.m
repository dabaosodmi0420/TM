//
//  TM_HomeShortcutMenuView.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/14.
//

#import "TM_HomeShortcutMenuView.h"
#import "TM_imgLabelButton.h"

#define kFuncationTag        100000001     //功能开始tag号

@interface TM_HomeShortcutMenuView(){
    NSUInteger _nLineNum;
    NSUInteger _nEachLineNum;
}

@end

@implementation TM_HomeShortcutMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        _nLineNum = 2;
        _nEachLineNum = 4;
    }
    return self;
}

- (void)createUI {
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    CGFloat left_X = getAutoSize(10.0f);
    CGFloat midd_X = getAutoSize(0.0f);
    CGFloat top_Y = getAutoSize(15.0f);
    CGFloat midd_Y = getAutoSize(14.0f);
    if (iPhone4_5) {
        left_X -= 8;
        midd_X -= 10;
        top_Y  -= 2;
        midd_Y -= 1;
    }
    NSInteger W = (self.frame.size.width - (_nEachLineNum - 1) * midd_X - 2 * left_X) / _nEachLineNum + 1;   //快捷菜单宽
    NSInteger H = getAutoSize((30+5+18.5)); //快捷菜单高
    NSInteger screenNum = _nEachLineNum * _nLineNum;     //每页的按钮个数
    NSInteger page = 0;      //页数
    NSInteger row = 0;       //行数
    NSInteger col = 0;       //列数
    
    CGRect buttFrame = CGRectMake(left_X, top_Y, W, H);
    
    //创建
    for (NSInteger i = 0; i < _dataArray.count; i++) {
        page = i/screenNum;      //页数
        row = (i%screenNum)/_nEachLineNum;       //行数
        col = (i%screenNum)%_nEachLineNum;       //列数
        buttFrame.origin.x = left_X + (midd_X + W)*col + self.frame.size.width * page - getAutoSize(2.0f);
        buttFrame.origin.y = top_Y + (midd_Y + H)*row;
        buttFrame.size.width = W;
        TM_imgLabelButton *menuBtn = [[TM_imgLabelButton alloc] initWithFrame:buttFrame];
        menuBtn.color = TM_ColorRGB(101, 101, 101);
        menuBtn.bottomNameFont = [UIFont systemFontOfSize:12];
        menuBtn.tag = kFuncationTag + i;
        [menuBtn addTarget:self action:@selector(menuItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:menuBtn];
        menuBtn.text = _dataArray[i].menuname;
        menuBtn.image = [UIImage imageNamed:_dataArray[i].iconImgName];
    }
}

- (void)setDataArray:(NSArray<TM_ShortMenuModel *> *)dataArray {
    _dataArray = dataArray;
    [self createUI];
}

- (void)menuItemClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(clickHomeShortcutMenuWithIndex:)]) {
        [self.delegate clickHomeShortcutMenuWithIndex:btn.tag - kFuncationTag];
    }
    if ([self.delegate respondsToSelector:@selector(clickHomeShortcutMenuWithModel:)]) {
        [self.delegate clickHomeShortcutMenuWithModel:_dataArray[btn.tag - kFuncationTag]];
    }
}
@end
