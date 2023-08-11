//
//  QQTJCalendarPickView.h
//  QStock_iP5_XCODE5
//
//  Created by leoshi on 2019/1/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QQTJCalendarPickView : UIView
@property(nonatomic,copy) NSString*  earlisdtDay;
@property (nonatomic, strong)  NSDateComponents    *earlistComponents;

- (void)updatePickDateWithString:( NSString *)dateStr withBackData:(void(^)(NSString *string))backData;


- (void)hideView;

- (void)showView;
@end

NS_ASSUME_NONNULL_END
