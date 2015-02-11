//
//  UILabel+ITTAdditions.m
//  iTotemFrame
//
//  Created by jack 廉洁 on 3/15/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "UILabel+ITTAdditions.h"

@implementation UILabel (ITTAdditions)

+ (UILabel *)labelWithFrame:(CGRect)frame
                       text:(NSString *)text
                  textColor:(UIColor *)textColor
                       font:(UIFont *)font
                        tag:(NSInteger)tag
                  hasShadow:(BOOL)hasShadow{
	UILabel *label = [[UILabel alloc] initWithFrame:frame];
	label.text = text;
	label.textColor = textColor;
	label.backgroundColor = [UIColor clearColor];
	if( hasShadow ){
		label.shadowColor = [UIColor blackColor];
		label.shadowOffset = CGSizeMake(1,1);
	}
	label.textAlignment = UITextAlignmentLeft;
	label.font = font;
	label.tag = tag;
	
	return label;
}
+ (UILabel *)labelForNavigationBarWithTitle:(NSString*)title
                                  textColor:(UIColor *)textColor
                                       font:(UIFont *)font
                                  hasShadow:(BOOL)hasShadow{
	UILabel *titleLbl = [UILabel labelWithFrame:CGRectMake(0,0,320,44)
                                           text:title
                                      textColor:textColor
                                           font:font
                                            tag:0
                                      hasShadow:hasShadow];
    titleLbl.textAlignment = UITextAlignmentCenter;

	return titleLbl;
}

+ (float)layoutLabelWidthWithText:(NSString *)str
                             font:(UIFont *)font
                           height:(float)height
{
    return [str sizeWithFont:font
                   constrainedToSize:CGSizeMake(MAXFLOAT, height) lineBreakMode:NSLineBreakByTruncatingMiddle].width;
}

+ (float)layoutLabelHeightText:(NSString *)str
                               font:(UIFont *)font
                              width:(float)width
{
    return [str sizeWithFont:font
           constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height;
}
@end
