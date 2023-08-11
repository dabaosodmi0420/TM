//
//  DatePickerView.h
//  TIanmu
//
//  Created by 郑连杰 on 2023/8/11.
//

#import "BasePickerView.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    DatePickerTypeDefault = 0,
    DatePickerTypeYearAndMonth,
    DatePickerTypeOnlyYear,
} DatePickerType;

@class BasePickerView;
@protocol  DatePickerViewDelegate<NSObject>   //定义一个代理。
//此方法目的是得到当前选择器的选择结果
- (void)pickerDateView:(BasePickerView *)pickerDateView selectYear:(NSInteger)year selectMonth:(NSInteger)month selectDay:(NSInteger)day;

@end
@interface DatePickerView : BasePickerView
<UIPickerViewDelegate,
UIPickerViewDataSource>
@property(nonatomic, weak)id <DatePickerViewDelegate>delegate ;

/* 日历类别 */
@property (assign, nonatomic) DatePickerType type;

/** 选择的年 */
@property (nonatomic, assign)NSInteger selectYear;
/** 选择的月 */
@property (nonatomic, assign)NSInteger selectMonth;
/** 选择的日 */
@property (nonatomic, assign)NSInteger selectDay;
//现在的年月日
@property (nonatomic, assign)NSInteger currentYear;
@property (nonatomic, assign)NSInteger currentMonth;
@property (nonatomic, assign)NSInteger currentDay;
//默认年月日
@property (nonatomic, assign)NSInteger defaultYear;
@property (nonatomic, assign)NSInteger defaultMonth;
@property (nonatomic, assign)NSInteger defaultDay;

//显示的最低年
@property (nonatomic, assign)NSInteger minShowYear;

@property (nonatomic, assign)NSInteger yearSum;

- (void)setDefaultTSelectYear:(NSInteger)defaultSelectYear defaultSelectMonth:(NSInteger)defaultSelectMonth defaultSelectDay:(NSInteger)defaultSelectDay;

@end
NS_ASSUME_NONNULL_END

