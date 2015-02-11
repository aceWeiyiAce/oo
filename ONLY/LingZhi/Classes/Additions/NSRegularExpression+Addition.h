//
//  NSRegularExpression+Addition.h
//  LingZhi
//
//  Created by pk on 3/13/14.
//
//

#import <Foundation/Foundation.h>

@interface NSRegularExpression (Addition)


/**
 *  邮箱验证
 *
 *  @param email
 *
 *  @return
 */
+ (BOOL) validateEmail:(NSString *)email;

/**
 *  手机号码验证
 *
 *  @param mobile
 *
 *  @return
 */
+ (BOOL) validateMobile:(NSString *)mobile;

/**
 *  邮编验证
 *
 *  @param mobile
 *
 *  @return
 */
+ (BOOL) validatePostcode:(NSString *)mobile;

/**
 *  车牌号验证
 *
 *  @param carNo
 *
 *  @return
 */
+ (BOOL) validateCarNo:(NSString *)carNo;


/**
 *  车型
 *
 *  @param CarType
 *
 *  @return
 */
+ (BOOL) validateCarType:(NSString *)CarType;

/**
 *  用户名
 *
 *  @param name
 *
 *  @return
 */
+ (BOOL) validateUserName:(NSString *)name;


/**
 *  密码
 *
 *  @param passWord
 *
 *  @return
 */
+ (BOOL) validatePassword:(NSString *)passWord;

/**
 *  昵称
 *
 *  @param nickname
 *
 *  @return
 */
+ (BOOL) validateNickname:(NSString *)nickname;



/**
 *  身份证号
 *
 *  @param identityCard
 *
 *  @return
 */
+ (BOOL) validateIdentityCard: (NSString *)identityCard;

/**
 *  银行卡
 *
 *  @param bankCardNumber
 *
 *  @return
 */
+ (BOOL) validateBankCardNumber: (NSString *)bankCardNumber;



/**
 *  银行卡后四位
 *
 *  @param bankCardNumber
 *
 *  @return
 */
+ (BOOL) validateBankCardLastNumber: (NSString *)bankCardNumber;

/**
 *  CVN
 *
 *  @param cvnCode
 *
 *  @return
 */
+ (BOOL) validateCVNCode: (NSString *)cvnCode;

/**
 *  month
 *
 *  @param month
 *
 *  @return
 */
+ (BOOL) validateMonth: (NSString *)month;


/**
 *  year
 *
 *  @param year
 *
 *  @return
 */
+ (BOOL) validateYear: (NSString *)year;


/**
 *  verifyCode 验证码
 *
 *  @param verifyCode
 *
 *  @return
 */
+ (BOOL) validateVerifyCode: (NSString *)verifyCode;


@end
