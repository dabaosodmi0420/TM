//
//  QQTJCalendarPickView.m
//  QStock_iP5_XCODE5
//
//  Created by leoshi on 2019/1/15.
//

#import "QQTJCalendarPickView.h"
//#import "PublicHeaders.h"
//#import "ViewTools.h"

#define pickerBlank         15
#define topBlank            25
#define ColorBlank          50

typedef void(^callBackDateBlock)(NSString   *dateStr);


@interface QQTJCalendarPickView()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSInteger           maxYear;
    NSInteger           maxMonth;
    NSInteger           maxDay;
    NSInteger           selectYear;
    NSInteger           selectMonth;
    NSInteger           selectDay;
}


@property (nonatomic, strong)       UIPickerView        *calendarPickerView;

@property (nonatomic, strong)       NSMutableArray      *yearArr;

@property (nonatomic, strong)       NSMutableArray      *monthArr;

@property (nonatomic, strong)       NSMutableArray      *dayArr;

@property (nonatomic, strong)       NSCalendar          *myCalendar;

@property (nonatomic, strong)       NSDateComponents    *myComponents;

@property (nonatomic, copy)         callBackDateBlock      dateBlock;

@end




@implementation QQTJCalendarPickView


- (NSCalendar *)myCalendar{
    
    if (_myCalendar == nil) {
        _myCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [_myCalendar setTimeZone:[NSTimeZone systemTimeZone]];
    }
    return _myCalendar;
}


- (NSMutableArray *)yearArr{
    
    if (_yearArr == nil) {
        _yearArr = [NSMutableArray array];
    }
    return _yearArr;
}

- (NSMutableArray *)monthArr{
    
    if (_monthArr == nil) {
        _monthArr = [NSMutableArray array];
    }
    return _monthArr;
}

- (NSMutableArray *)dayArr{
    
    if (_dayArr == nil) {
        _dayArr = [NSMutableArray array];
    }
    return _dayArr;
}



- (UIPickerView *)calendarPickerView{
    
    if (_calendarPickerView == nil) {
        _calendarPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(pickerBlank+ColorBlank, topBlank+ColorBlank, CGRectGetWidth(self.frame)-(pickerBlank+ColorBlank)*2, CGRectGetHeight(self.frame)-(topBlank+ColorBlank)*2)];
        _calendarPickerView.dataSource = self;
        _calendarPickerView.delegate = self;
        
    }
    return _calendarPickerView;
}

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self addMainView];
        [self getMaxDateIndex];
    }
    return self;
}



- (void)addMainView{
 
    UIView  *oneView = [[UIView alloc]initWithFrame:CGRectMake(ColorBlank, ColorBlank, CGRectGetWidth(self.frame)-ColorBlank*2, CGRectGetHeight(self.frame)-ColorBlank*2)];
    oneView.backgroundColor = [UIColor whiteColor];
    oneView.layer.borderWidth = 1;
    oneView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    oneView.layer.cornerRadius = 3;
    [self addSubview:oneView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(oneView.frame), topBlank)];
    titleLabel.textColor =  [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.text = @"统计日期选择";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [oneView addSubview:titleLabel];
    [self addSubview:self.calendarPickerView];
    NSArray *titleArr = @[@"取消",@"确定"];
    CGFloat btn_w = CGRectGetWidth(oneView.frame)/2.0;
    for (int i = 0 ; i < 2; i++) {
        UIButton *oneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        oneBtn.frame = CGRectMake(btn_w*i, CGRectGetHeight(oneView.frame)-topBlank, btn_w, topBlank);
        [oneBtn setTitle:[titleArr objectAtIndex:i] forState:UIControlStateNormal];
        if (i == 0) {
            [oneBtn setTitleColor:[UIColor colorWithRed:133/255.0 green:140/255.0 blue:158/255.0 alpha:1.0] forState:UIControlStateNormal];
        }else{
            [oneBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
       
        oneBtn.tag = 1000+i;
        [oneBtn addTarget:self action:@selector(selectDateAction:) forControlEvents:UIControlEventTouchUpInside];
        oneBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [oneView addSubview:oneBtn];
    }
    
}

- (void)getMaxDateIndex{
    
    self.myComponents = [self.myCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    maxYear = 1;
    maxMonth = self.myComponents.month-1;
    maxDay = self.myComponents.day-1;
    
}

- (void)selectDateAction:(UIButton *)mbtn{
    
    NSInteger tag = mbtn.tag;
    [self hideView];
    if (tag != 1000) {
        //回传日期
        NSString    *oneDateStr = [NSString stringWithFormat:@"%04d%02d%02d",[[self getStringWithArray:self.yearArr withIndex:selectYear] intValue],[[self getStringWithArray:self.monthArr withIndex:selectMonth] intValue],[[self getStringWithArray:self.dayArr withIndex:selectDay] intValue]];
        if (self.dateBlock) {
            self.dateBlock(oneDateStr);
        }
        
    }
    
}


#pragma mark - lirw refactor 20210204刷新年月日并做上市日期限制
- (void)setYearData {
    
    [self.yearArr removeAllObjects];
    
    NSDateComponents * com = [self.myCalendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:[NSDate date]];
    [self.yearArr addObject:[NSString stringWithFormat:@"%d年",((int)com.year)]];
    if (_earlistComponents) {
        for (int i = _earlistComponents.year; i<com.year; i++) {
            [self.yearArr addObject:[NSString stringWithFormat:@"%d年",i]];
        }
    }
}

-(void)setMonthDataWithDate:(NSString*)dateStr{
    
    [self.monthArr removeAllObjects];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYYMMdd"];
    
    NSString   *myDate = dateStr;
    if (myDate.length == 0) {
        myDate = [formatter stringFromDate:[NSDate date]];
    }
    NSDate *oneDate = [NSDate dateWithTimeInterval:8*3600 sinceDate:[formatter dateFromString:myDate]];
    NSDateComponents * oneCompments = [self.myCalendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:oneDate];
    
    NSDateComponents * todayCompments = [self.myCalendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:[NSDate date]];
        //月
    if (todayCompments.year == oneCompments.year ){
        
        if (_earlistComponents.year == oneCompments.year) {
            for (int i = _earlistComponents.month ; i <= todayCompments.month ; i++) {
                [_monthArr addObject:[NSString stringWithFormat:@"%d月",i]];
            }
        }else{
            for (int i = 1 ; i <= todayCompments.month ; i++) {
                [_monthArr addObject:[NSString stringWithFormat:@"%d月",i]];
            }
            
        }
        
    }else{
            //昨年
        if (_earlistComponents.year == oneCompments.year) {
            for (int i = _earlistComponents.month ; i <= 12 ; i++) {
                [_monthArr addObject:[NSString stringWithFormat:@"%d月",i]];
            }
        }else{
            for (int i = 1 ; i <= 12 ; i++) {
                [_monthArr addObject:[NSString stringWithFormat:@"%d月",i]];
            }
            
        }
    }
    
    self.myComponents = oneCompments;
}

-(void)setDaysDataWithDate:(NSString*)dateStr{
    
    [self.dayArr removeAllObjects];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYYMMdd"];
    
    NSString   *myDate = dateStr;
    if (myDate.length == 0) {
        myDate = [formatter stringFromDate:[NSDate date]];
    }
    NSDate *oneDate = [NSDate dateWithTimeInterval:8*3600 sinceDate:[formatter dateFromString:myDate]];
    NSDateComponents * oneCompments = [self.myCalendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:oneDate];
    
    NSDateComponents * todayCompments = [self.myCalendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:[NSDate date]];
    
    NSRange range = [_myCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:oneDate];
    
    if (todayCompments.year == oneCompments.year ){
            //日
        if (todayCompments.month == oneCompments.month) {
                //未来日期不做选择
            for (int i = 1 ; i <= todayCompments.day; i++) {
                [_dayArr addObject:[NSString stringWithFormat:@"%d日",i]];
            }
        }else if(oneCompments.year == _earlistComponents.year && oneCompments.month == _earlistComponents.month){
                //上市之前日期不做选择
            NSString *agoDateStr = [NSString stringWithFormat:@"%4d%02d01",_earlistComponents.year,_earlistComponents.month];
            NSDate *agoDate = [NSDate dateWithTimeInterval:8*3600 sinceDate:[formatter dateFromString:agoDateStr]];
            NSRange rangeAgo = [_myCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:agoDate];
            
            for (int i = _earlistComponents.day ; i <= rangeAgo.length; i++) {
                [_dayArr addObject:[NSString stringWithFormat:@"%d日",i]];
            }
            
        }else{
            for (int i = 1 ; i <= range.length; i++) {
                [_dayArr addObject:[NSString stringWithFormat:@"%d日",i]];
            }
        }
        
        
        
    }else{
            //昨年
        if(oneCompments.month == _earlistComponents.month){
                //上市之前日期不做选择
            NSString *agoDateStr = [NSString stringWithFormat:@"%4d%02d01",_earlistComponents.year,_earlistComponents.month];
            NSDate *agoDate = [NSDate dateWithTimeInterval:8*3600 sinceDate:[formatter dateFromString:agoDateStr]];
            NSRange rangeAgo = [_myCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:agoDate];
            for (int i = _earlistComponents.day ; i <= rangeAgo.length; i++) {
                [_dayArr addObject:[NSString stringWithFormat:@"%d日",i]];
            }
            
        }else{
            for (int i = 1 ; i <= range.length; i++) {
                [_dayArr addObject:[NSString stringWithFormat:@"%d日",i]];
            }
        }
        
    }
    
    
    self.myComponents = oneCompments;
}

- (void)updatePickDateWithString:( NSString *)dateStr withBackData:(void(^)(NSString *string))backData{
    
    _dateBlock = backData;

    
    
    //年
    [self setYearData];
    //月
    [self setMonthDataWithDate:dateStr];
    //日
    [self setDaysDataWithDate:dateStr];
    
   
    NSString *yearStr = [NSString stringWithFormat:@"%d年",(int)self.myComponents.year];
    NSString *monthStr = [NSString stringWithFormat:@"%d月",(int)self.myComponents.month];
    NSInteger yearIndex = [self.yearArr indexOfObject:yearStr];
    NSInteger monthIndex = [self.monthArr indexOfObject:monthStr];
    NSString *yearIndexStr = [NSString stringWithFormat:@"%d",(int)yearIndex];
    NSString *monthIndexStr = [NSString stringWithFormat:@"%d",(int)monthIndex];
    
    NSDictionary *indexDict = [NSDictionary dictionaryWithObjectsAndKeys:yearIndexStr,@"year",monthIndexStr,@"month",@(self.myComponents.day),@"day", nil];
    
    [self performSelectorOnMainThread:@selector(updatePickData:) withObject:indexDict waitUntilDone:NO];
    
    
}

- (void)updatePickData:(NSDictionary *)mDict{
    
    int year = [[mDict objectForKey:@"year"]intValue];
    int month = [[mDict objectForKey:@"month"]intValue];
    int day = [[mDict objectForKey:@"day"]intValue]-1;
    
    [self.calendarPickerView reloadAllComponents];
    
    [self.calendarPickerView selectRow:year inComponent:0 animated:NO];
    
    [self.calendarPickerView selectRow:month inComponent:1 animated:NO];
    
    [self.calendarPickerView selectRow:day inComponent:2 animated:NO];
    
    
}

- (void)hideView{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self setFrame:CGRectMake(CGRectGetMinX(self.frame), -(CGRectGetHeight(self.frame)), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    }];
    
}

- (void)showView{
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    self.alpha = 1;
    
}

#pragma -mark delegateAndDataSource Start

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;       //年月日
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    return CGRectGetWidth(self.calendarPickerView.frame)/3.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 30.0;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        //年
        return self.yearArr.count;
    }
    else if (component == 1){
        //月
        return self.monthArr.count;
    }
    else{
        //日
        return self.dayArr.count;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *oneLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_calendarPickerView.frame)/3.0, 30.0)];
    oneLabel.font = [UIFont systemFontOfSize:16];
    oneLabel.textColor = [UIColor blackColor];
    oneLabel.textAlignment = NSTextAlignmentCenter;
    NSString *titleStr = nil;
    switch (component) {
        case 0:
        {
            titleStr = [self.yearArr objectAtIndex:row];
        }
            break;
        case 1:
        {
            titleStr = [self.monthArr objectAtIndex:row];
        }
            break;
        case 2:
        {
            titleStr = [self.dayArr objectAtIndex:row];
        }
            break;
        default:
            break;
    }
    oneLabel.text = titleStr;
    return oneLabel;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    selectYear = [self.calendarPickerView selectedRowInComponent:0];
    selectMonth = [self.calendarPickerView selectedRowInComponent:1];
    selectDay = [self.calendarPickerView selectedRowInComponent:2];
    
    if (component == 0) {
        //年
        
        [self updateMonthArrWithYear:selectYear];
        //根据月份更新dayArr
        [self updateDayArrWithMonth:selectMonth withYear:selectYear];
        
    }
    else if (component == 1){
        //月
        [self updateDayArrWithMonth:selectMonth withYear:selectYear];
        
    }
    else{
        
        
    }
    [self.calendarPickerView selectRow:selectYear inComponent:0 animated:YES];
    [self.calendarPickerView selectRow:selectMonth inComponent:1 animated:YES];
    [self.calendarPickerView selectRow:selectDay inComponent:2 animated:YES];
}


- (void)updateDayArrWithMonth:(NSInteger)month withYear:(NSInteger)year{
    
    NSString    *oneDateStr = [NSString stringWithFormat:@"%04d%02d01",[[self getStringWithArray:self.yearArr withIndex:year] intValue],[[self getStringWithArray:self.monthArr withIndex:month] intValue]];
    
    [self setDaysDataWithDate:oneDateStr];
    selectDay = 0;
    [self.calendarPickerView reloadComponent:2];
}

- (void)updateMonthArrWithYear:(NSInteger)year{
    
    
    NSString    *oneDateStr = [NSString stringWithFormat:@"%04d0101",[[self getStringWithArray:self.yearArr withIndex:year] intValue]];
    
    [self setMonthDataWithDate:oneDateStr];
    selectMonth = 0;
    [self.calendarPickerView reloadComponent:1];
}

- (NSString *)getStringWithArray:(NSArray *)array withIndex:(NSInteger)index{
    
    NSString    *mStr = [array objectAtIndex:index];
    NSString    *lastStr = [mStr substringToIndex:mStr.length-1];
    return lastStr;
}

#pragma -mark delegateAndDataSource End
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
