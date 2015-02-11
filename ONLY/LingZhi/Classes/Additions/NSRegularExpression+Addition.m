//
//  NSRegularExpression+Addition.m
//  LingZhi
//
//  Created by pk on 3/13/14.
//
//

#import "NSRegularExpression+Addition.h"

@implementation NSRegularExpression (Addition)



/**
 *  邮箱验证
 *
 *  @param email
 *
 *  @return
 */
+ (BOOL) validateEmail:(NSString *)email
{

    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/**
 *  手机号码验证
 *
 *  @param mobile
 *
 *  @return
 */
+ (BOOL) validateMobile:(NSString *)mobile
{
////    手机号以13， 15，18开头，八个 \d 数字字符
//    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(170))\\d{8}$";
//    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
//    BOOL result = [phoneTest evaluateWithObject:mobile];
    NSString *phoneRegex = @".*[A-z]+.*";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    BOOL result = [phoneTest evaluateWithObject:mobile];
    NSLog(@"result = %d",result);
    return result;
}

+ (BOOL) validatePostcode:(NSString *)mobile
{
    NSString *postRegex = @"^[0-9]\\d{5}(?!\\d)";
    NSPredicate *postcode = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",postRegex];
    return [postcode evaluateWithObject:mobile];
}

/**
 *  车牌号验证
 *
 *  @param carNo
 *
 *  @return
 */
+ (BOOL) validateCarNo:(NSString *)carNo
{
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:carNo];
}



/**
 *  车型
 *
 *  @param CarType
 *
 *  @return
 */
+ (BOOL) validateCarType:(NSString *)CarType

{
    NSString *CarTypeRegex = @"^[\u4E00-\u9FFF]+$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CarTypeRegex];
    return [carTest evaluateWithObject:CarType];
}


/**
 *  用户名
 *
 *  @param name
 *
 *  @return
 */
+ (BOOL) validateUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[A-Za-z0-9]{4,20}+$";

    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];

    BOOL B = [userNamePredicate evaluateWithObject:name];

    return B;

}



/**
 *  密码
 *
 *  @param passWord
 *
 *  @return
 */
+ (BOOL) validatePassword:(NSString *)passWord

{
    
    BOOL result = NO;
//^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$
    
    //数字和字母都可以
//    NSString *passWordRegex = @"^[a-zA-Z0-9]{8,12}+$";
//    NSString *passWordRegex = @"^[(a-zA-Z){1,}+(0-9){1,}]{8,12}$";
    
    //数字和字母同时满足至少一位
//    NSString *passWordRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,12}$";
//    
//    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
//
//    BOOL result = [passWordPredicate evaluateWithObject:passWord];
//    
//    NSLog(@"reslut = %d",result);
    
    //20140512 根据需求修改
    int length = [passWord length];
    result = (length >= 8 && length <= 12) ? YES : NO;
    return result;

}


/**
 *  昵称
 *
 *  @param nickname
 *
 *  @return
 */
+ (BOOL) validateNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"([\u4e00-\u9fa5]{2,5})(&middot;[\u4e00-\u9fa5]{2,5})*";
    
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    
    return [passWordPredicate evaluateWithObject:nickname];
}



/**
 *  身份证号
 *
 *  @param identityCard
 *
 *  @return
 */
+ (BOOL) validateIdentityCard: (NSString *)identityCard

{
    BOOL flag;
    
    if (identityCard.length <= 0) {
        
        flag = NO;
        
        return flag;
        
    }
    
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}


/**
 *  银行卡
 *
 *  @param bankCardNumber
 *
 *  @return
 */
+ (BOOL) validateBankCardNumber: (NSString *)bankCardNumber
{

    BOOL flag;
    if (bankCardNumber.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{15,30})";

    NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    
    return [bankCardPredicate evaluateWithObject:bankCardNumber];

}



/**
 *  银行卡后四位
 *
 *  @param bankCardNumber
 *
 *  @return
 */
+ (BOOL) validateBankCardLastNumber: (NSString *)bankCardNumber

{

    BOOL flag;

    if (bankCardNumber.length != 4) {

        flag = NO;

        return flag;

    }

    NSString *regex2 = @"^(\\d{4})";

    NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];

    return [bankCardPredicate evaluateWithObject:bankCardNumber];

}


/**
 *  CVN
 *
 *  @param cvnCode
 *
 *  @return
 */
+ (BOOL) validateCVNCode: (NSString *)cvnCode
{

    BOOL flag;

    if (cvnCode.length <= 0) {

        flag = NO;

        return flag;
    }

    NSString *regex2 = @"^(\\d{3})";

    NSPredicate *cvnCodePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [cvnCodePredicate evaluateWithObject:cvnCode];
}


/**
 *  month
 *
 *  @param month
 *
 *  @return
 */
+ (BOOL) validateMonth: (NSString *)month
{
    BOOL flag;
    if (!month.length == 2) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"(^(0)([0-9])$)|(^(1)([0-2])$)";
    NSPredicate *monthPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [monthPredicate evaluateWithObject:month];
}

/**
 *  year
 *
 *  @param year
 *
 *  @return
 */
+ (BOOL) validateYear: (NSString *)year
{
    BOOL flag;
    if (!year.length == 2) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^([1-3])([0-9])$";
    NSPredicate *yearPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [yearPredicate evaluateWithObject:year];
}


/**
 *  verifyCode 验证码
 *
 *  @param verifyCode
 *
 *  @return
 */
+ (BOOL) validateVerifyCode: (NSString *)verifyCode
{
    BOOL flag;
    if (!verifyCode.length == 6) {
        flag = NO;
        return flag;
    }

    NSString *regex2 = @"^(\\d{6})";
    NSPredicate *verifyCodePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [verifyCodePredicate evaluateWithObject:verifyCode];
}



@end
