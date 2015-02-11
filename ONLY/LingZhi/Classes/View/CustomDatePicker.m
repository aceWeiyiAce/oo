
//
//  CustomDatePicker.m
//  TestCalender
//
//  Created by kping on 14-8-8.
//  Copyright (c) 2014年 iss. All rights reserved.
//

#import "CustomDatePicker.h"
#import "NSDate+Utilities.h"

@interface CustomDatePicker ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    
    __weak IBOutlet UILabel *_showLabel;
    
    NSMutableArray * _yearArr;
    NSMutableArray * _monthArr;
    NSMutableArray * _daysArr;
    
    NSUInteger _selectYear;
    NSUInteger _selectMonth;
    NSUInteger _selectDay;
    
    NSArray * fonts;
    NSArray * fontSize;
    NSArray * fontColor;
    
    BOOL isLeapYear;
    NSSet * _selectMonthSetOf30;

    int indexOfSelectDay;
    CGFloat recordMoveViewTop;
}

@property (weak, nonatomic) IBOutlet UIPickerView *yearPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *monthPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *dayPicker;

@end

@implementation CustomDatePicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"-----%@,",[self class]);
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
        self = array[0];
    
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self Dates];
    
    _selectMonthSetOf30 = [NSSet setWithObjects:@4,@6,@9,@11, nil];
    for(int i= 0;i<3;i++)
    {
        int row = 0;
        if(i==0)
        {
            row = [fonts count]/2;
        }
        else if (i==1)
        {
            row = [fontColor count]/2;
        }
        else if (i==2)
        {
            row =[fontSize count]/2;
        }
//        [_dayPicker selectRow:row inComponent:i animated:true];
    }
    [_yearPicker selectRow:76 inComponent:0 animated:true];
    _selectYear = [_yearArr[76] intValue];
    
    [_monthPicker selectRow:20 inComponent:0 animated:true];
    _selectMonth = [_monthArr[20] intValue];
    
    [_dayPicker selectRow:20 inComponent:0 animated:true];
    _selectDay = [_daysArr[20] intValue];
    
    _showLabel.text = [self birthday:_selectYear month:_selectMonth andDay:_selectDay];
}

-(void)Dates{
    _yearArr = [[NSMutableArray alloc] init];
    
    int maxYear = [[NSDate date] year] ;
//    int maxYear = 2050 ;
    for (int i = maxYear - 100; i<=maxYear; i++) {
        NSString * strYear = [NSString stringWithFormat:@"%d",i];
        [_yearArr addObject:strYear];
    }
    _monthArr = [NSMutableArray array];
    _daysArr = [NSMutableArray array];
    for (int j =0; j<10; j++) {
        [_monthArr addObjectsFromArray:[NSArray arrayWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12", nil]];
        NSMutableArray * days =[NSMutableArray array];
        for (int i =1; i<=31; i++) {
            
            NSString *str = nil;
            if (i < 10) {
                str = [NSString stringWithFormat:@"0%d",i];
            }else{
                str = [NSString stringWithFormat:@"%d",i];
            }
            [days addObject:str];
        }
        [_daysArr addObjectsFromArray:days];
    }

}

/**
 *  判断指定的年份是否为闰年
 *
 *  @param year
 *
 *  @return BOOL
 */
-(BOOL)isLeapYear:(int)year
{
    //判断闰年的方法是该年能被4整除并且不能被100整除，或者是可以被400整除。
    if(year % 400 == 0 || ((year % 4 == 0) && (year % 100 != 0)))
        return true;
    else
        return false;

}

-(NSString *)birthday:(int)year month:(int)month andDay:(int)day
{
    NSString * str = [NSString stringWithFormat:@"您的生日是:%d年%d月%d日",year,month,day];
    return str;
}

-(NSString *)birthdayOfDelegate:(int)year month:(int)month andDay:(int)day
{
    NSString * strMonth = month<10 ? [NSString stringWithFormat:@"0%d",month]:[NSString stringWithFormat:@"%d",month];
    NSString * strDay = day<10 ? [NSString stringWithFormat:@"0%d",day]:[NSString stringWithFormat:@"%d",day];
    NSString * str = [NSString stringWithFormat:@"%d-%@-%@",year,strMonth,strDay];
    return str;
}


#pragma mark -UIPickerViewDataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == _yearPicker) {
         return _yearArr.count;
    }
    
    if (pickerView == _monthPicker) {
        return _monthArr.count;
    }

    if (pickerView == _dayPicker) {
        return _daysArr.count;
    }

    return 0;
}

#pragma mark -UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    
    return 50;
}

// these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
// If you return back a different object, the old one will be released. the view will be centered in the row rect
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == _yearPicker) {
        return _yearArr[row] ;
    }
    
    if (pickerView == _monthPicker) {
        return _monthArr[row] ;
    }
    
    if (pickerView == _dayPicker) {
        return _daysArr[row] ;
    }

    return nil;
}
//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component NS_AVAILABLE_IOS(6_0); // attributed title is favored if both methods are implemented
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
    
    if (pickerView == _yearPicker) {
        _selectYear = [_yearArr[row] intValue];
       UIView * view = [_yearPicker viewForRow:row forComponent:0];
        NSLog(@"view = %@",view);
        isLeapYear = [self isLeapYear:_selectYear];
    }
    
    if (pickerView == _monthPicker) {
        _selectMonth = [_monthArr[row] intValue];
        
    }
    
    if (pickerView == _dayPicker) {
         _selectDay = [_daysArr[row] intValue];
        indexOfSelectDay = row;
    }
    //计算方法 1,3,5,7,8,10,12  为31天  4,6,9,11 为 30天   平年2月 28  闰年是29
    //对选择的日期进行判断
    if ([_selectMonthSetOf30 containsObject:[NSNumber numberWithInt:_selectMonth]]) {
        if (_selectDay == 31) {
            [_dayPicker selectRow:indexOfSelectDay-1 inComponent:0 animated:TRUE];
            _selectDay = [_daysArr[indexOfSelectDay-1] intValue];
        }
    }
    if (_selectMonth == 2 && isLeapYear) {
        if (_selectDay > 29) {
//            indexOfSelectDay = indexOfSelectDay-(_selectDay - 29);
            [_dayPicker selectRow:indexOfSelectDay-(_selectDay - 29) inComponent:0 animated:TRUE];
            _selectDay = [_daysArr[indexOfSelectDay-(_selectDay - 29)] intValue];
        }
    }
    if (_selectMonth == 2 && !isLeapYear) {
        if (_selectDay > 28) {
//            indexOfSelectDay = indexOfSelectDay-(_selectDay - 28);
            [_dayPicker selectRow:indexOfSelectDay-(_selectDay - 28) inComponent:0 animated:TRUE];
            _selectDay = [_daysArr[indexOfSelectDay-(_selectDay - 28)] intValue];
        }
    }
    
    _showLabel.text = [self birthday:_selectYear month:_selectMonth andDay:_selectDay];
    UIView * view = [pickerView viewForRow:row forComponent:0];
    NSLog(@"view.subviews.count = %d",view.subviews.count);
//    UILabel * lbl = (UILabel *)[view viewWithTag:200];
    
//    [UIView animateWithDuration:0.2 animations:^{
//        lbl.textColor = [UIColor colorWithRed:1.000 green:0.066 blue:0.506 alpha:1.000];
//    }];
    
}


//可以理解为自定义的view内容
-(UIView *) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    CGFloat width = 96;
    CGFloat rowheight = 50;
    
    UIView *myView = [[UIView alloc]init];
    myView.frame =CGRectMake(0.0f, 0.0f, width, rowheight);
    UILabel *txtlabel = [[UILabel alloc] init];
    txtlabel.tag=200;
    txtlabel.font = [UIFont systemFontOfSize:20.0];
    txtlabel.frame = myView.frame;
    txtlabel.textAlignment = NSTextAlignmentCenter;
    
    [myView addSubview:txtlabel];
    if(pickerView == _yearPicker)
    {
        txtlabel.text = _yearArr[row] ;
    }
    if(pickerView == _monthPicker)
    {
        txtlabel.text = _monthArr[row] ;
    }
    if(pickerView == _dayPicker)
    {
        txtlabel.text = _daysArr[row] ;
    }
    return myView;
}


- (IBAction)hideAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(cancelInput)]) {
        [_delegate cancelInput];
    }
    [UIView animateWithDuration:0.3f animations:^{
        self.superview.top = _hideTopHeight;
    } completion:^(BOOL finished) {
        [[self superview] setHidden:YES];
    }];
    
}

- (IBAction)finishAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(getBirthDay:)]) {
        [_delegate getBirthDay:[self birthdayOfDelegate:_selectYear month:_selectMonth andDay:_selectDay]];
        [UIView animateWithDuration:0.3f animations:^{
            self.superview.top = _hideTopHeight;
        } completion:^(BOOL finished) {
           
        }];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
