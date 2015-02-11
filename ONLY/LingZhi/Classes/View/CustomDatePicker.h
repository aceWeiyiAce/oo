//
//  CustomDatePicker.h
//  TestCalender
//
//  Created by kping on 14-8-8.
//  Copyright (c) 2014年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomDatePickerDelegate <NSObject>

@optional

-(void)getBirthDay:(NSString *)birth;
-(void)cancelInput;

@end

@interface CustomDatePicker : UIView

@property (assign,nonatomic) CGFloat hideTopHeight;
@property (assign,nonatomic)id<CustomDatePickerDelegate> delegate;


@end
