//
//  TM_AttributeTextView.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/27.
//

#import "TM_AttributeTextView.h"

#define kScheme @"AttributeTextViewScheme"

@interface TM_AttributeTextView()<UITextViewDelegate> {
    NSMutableArray *_linkTextRanges; // 链接文字range
}
/* textView */
@property (strong, nonatomic) UITextView *textView;

@end

@implementation TM_AttributeTextView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _font = [UIFont systemFontOfSize:16];
        _textColor = [UIColor blackColor];
        [self createView];
    }
    return self;
}
- (void)createView {
    _textView                       = [[UITextView alloc] initWithFrame:self.bounds];
    _textView.backgroundColor       = [UIColor clearColor];
    _textView.textContainerInset    = UIEdgeInsetsZero;
    _textView.editable              = YES;
    _textView.delegate              = self;
    _textView.scrollEnabled         = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self addGestureRecognizer:tap];
    [self addSubview:_textView];
}

- (void)refresh {
    if (!_text || _text.length == 0) return;
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentLeft;
    paragraph.lineSpacing = 5;
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:_text];
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, _text.length)];
    [attributeString addAttributes:@{
        NSFontAttributeName             : _font,
        NSForegroundColorAttributeName  : _textColor
    } range:NSMakeRange(0, _text.length)];
    
    _linkTextRanges = [NSMutableArray array];
    for (int i = 0; i < _linkTextArr.count; i++) {
        NSString *text = _linkTextArr[i];
        NSRange range = [_text rangeOfString:text];
        if (range.length <= 0) break;
        if (_linkTextSchemeArr.count == _linkTextArr.count) {
            [attributeString addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%@://",_linkTextSchemeArr[i]] range:range];
        }else {
            // 默认添加scheme名称
            [attributeString addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%@%d://",kScheme, i] range:range];
        }
        _textView.linkTextAttributes = @{
            NSForegroundColorAttributeName : _linkColor != nil ? _linkColor : _textColor,
            NSFontAttributeName : _linkFont != nil ? _linkFont : _font
        };
        // 保存链接文字的范围
        [_linkTextRanges addObject:[NSNumber valueWithRange:range]];
    }
    
    _textView.attributedText = attributeString;
    
    if (_isSizeToFit) {
        CGSize size = [attributeString boundingRectWithSize:CGSizeMake(self.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        self.size = size;
        _textView.size = size;
    }
}

- (void)tapClick {
    if ([self.delegate respondsToSelector:@selector(tm_attributeTextViewClick:)]) {
        [self.delegate tm_attributeTextViewClick:self];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (self.userInteractionEnabled == NO || self.hidden == YES ||  self.alpha <= 0.01) return nil;
    // 触摸点若不在当前视图上则无法响应事件
    if ([self pointInside:point withEvent:event] == NO) return nil;
    
    BOOL contains = NO;
    for (NSNumber *value in _linkTextRanges) {
        NSRange range = [value rangeValue];
        //self.selectedRange -> 影响 self.selectedTextRange
        _textView.selectedRange = range;
        //获取选中模块的位置数组
        NSArray *rects = [_textView selectionRectsForRange:_textView.selectedTextRange];
        // 清空选中范围
        _textView.selectedRange = NSMakeRange(0, 0);
        for (UITextSelectionRect *selectionRect in rects) {
            CGRect rect = selectionRect.rect;
            if (rect.size.width == 0 || rect.size.height == 0) continue;
            //判断点是否在特殊框里
            if (CGRectContainsPoint(rect, point)) {
                contains = YES;
                break;
            }
        }
        if (contains) {
            return _textView;
        }
    }
    return self;
}
//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//    return NO;
//}
#pragma mark - setting
- (void)setText:(NSString *)text {
    _text = text;
    [self refresh];
}
- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    if (!_linkColor) _linkColor = textColor;
    [self refresh];
}
- (void)setFont:(UIFont *)font {
    _font = font;
    [self refresh];
}
- (void)setLinkFont:(UIFont *)linkFont {
    _linkFont = linkFont;
    [self refresh];
}
- (void)setLinkColor:(UIColor *)linkColor {
    _linkColor = linkColor;
    [self refresh];
}
- (void)setLinkTextArr:(NSArray<NSString *> *)linkTextArr {
    _linkTextArr = linkTextArr;
    [self refresh];
}
- (void)setLinkTextSchemeArr:(NSArray<NSString *> *)linkTextSchemeArr {
    _linkTextSchemeArr = linkTextSchemeArr;
    [self refresh];
}
- (void)setIsSizeToFit:(BOOL)isSizeToFit {
    _isSizeToFit = isSizeToFit;
    [self refresh];
}
#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    NSString *scheme = [URL scheme];
    if ([_linkTextSchemeArr containsObject:scheme]) {
        if ([self.delegate respondsToSelector:@selector(tm_attributeTextView:linkScheme:)]) {
            [self.delegate tm_attributeTextView:self linkScheme:scheme];
        }
        return NO;
    }else if ([scheme hasPrefix:kScheme]) {
        NSString *num = [scheme substringFromIndex:kScheme.length];
        if ([self.delegate respondsToSelector:@selector(tm_attributeTextView:linkClickIndex:)]) {
            [self.delegate tm_attributeTextView:self linkClickIndex:[num integerValue]];
        }
        return NO;
    }
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return NO;
}
@end
