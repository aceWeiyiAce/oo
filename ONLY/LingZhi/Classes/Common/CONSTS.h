//
//  CONSTS.h
//  Hupan
//
//  Copyright 2010 iTotem Studio. All rights reserved.
//

#import "Reachability.h"

#define isReachability          [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable

#define KEY_SHOW_COMPLETEBTN @"keyofCompleteButton"

#define SelectedColor     [UIColor colorWithRed:252/255.0 green:20/255.0 blue:104/255.0 alpha:1.0]
#define url_adress   @"http://m.only.cn:8102/OnlyServiceIntegration/"   //内网地址
//#define url_adress   @"http://172.16.10.134:8090/OnlyServiceIntegration/"   //内网地址  带登录
//#define url_adress   @"http://106.120.205.116:8083/OnlyServiceIntegration/"   //外网地址118.194.170.63   106.120.205.116
//#define url_adress   @"http://118.194.170.63:8080/OnlyServiceIntegration/"   //only官方地址
#define requestUrl(url)     [NSString stringWithFormat:@"%@%@.do",url_adress,url]

#define scanLoginRequestUrl     @"http://m.only.cn:8500/guide_shop/LoginRegistController/saveScanLoginMark.do"


#define Login_address   @"http://192.168.1.101/ecshop/upload/ecmobile/?url=/user/signin"   //jiuba官方地址

#define LoginModel_RequestUrl(url)  [NSString stringWithFormat:@"%@",Login_address]

//#define ALiPay_Notify_Url  @"http://118.194.170.63:8080/OnlyServiceIntegration/alipayNotify.do" //正式

#define ALiPay_Notify_Url  @"http://m.only.cn:8102/OnlyServiceIntegration/alipayNotify.do" //测试

#define REQUEST_DOMAIN @"http://cx.itotemstudio.com/api.php" // default env

//text
#define TEXT_LOAD_MORE_NORMAL_STATE @"向上拉动加载更多..."
#define TEXT_LOAD_MORE_LOADING_STATE @"更多数据加载中..."


#define testImage @"http://image3.uuu9.com/war3/dota/UploadFiles_5254/201212/20121207120528364911.jpg"




#define UserNameKey     @"UserName"
#define PWDKey          @"PWD"
#define TicketKey       @"Ticket"

//customAlertTitle
#define CustomAlertTitle @"温馨提示"

//限制收货地址容许输入的最大长度
#define MaxLengthOfAddressInput 35

//键盘高度
#define KeyBoardHeight  216


//支付方式编码
#define UnionPayCode  @"PAY_BANK"
#define AliPayCode    @"PAY_ZFB"




//other consts
typedef enum{
	kTagWindowIndicatorView = 501,
	kTagWindowIndicator,
} WindowSubViewTag;

typedef enum{
    kTagHintView = 101
} HintViewTag;

typedef enum{
    kPersonCenterCart = 0,
    kPersonCenterFavorite,
    kPersonCenterOrder,
    kPersonCenterAddress,
    kPersonCenterPassword,
    kPersonCenterLogin,
}PersonCenterButtonType;

typedef enum{
    kMoreMyTrack = 0,
    kMoreMap,
    kMoreClearMemory,
    kMoreExchange,
    kMoreNotification,
    kMoreAbout,
    kMoreContact,
    kMoreScore,
    
}MoreFunctionType;


typedef enum {
    oWaitPay=1,       //待付款
    oDealCanceled,    //已取消
    oWaitPost,        //待发货
    oHasPosted,       //已发货
    oDealFinished,    //交易完成
    oReturnOrChange,  //退货处理
    oReceivedGoods,   //交易关闭
    oDealClosed,      //退货处理
    
}OrderState;

NS_INLINE NSString * MessageByOrderState(OrderState state)
{
    NSString * resultMsg = Nil;
    switch (state) {
        case oWaitPay:
            resultMsg = @"待付款";
            break;
        case oWaitPost:
            resultMsg = @"待发货";
            break;
        case oHasPosted:
            resultMsg = @"已发货";
            break;
        case oReceivedGoods:
            resultMsg = @"已收货";
            break;
        case oReturnOrChange:
            resultMsg = @"退换货";
            break;
        case oDealFinished:
            resultMsg = @"已完成";
            break;
        case oDealClosed:
            resultMsg = @"已关闭";
            break;
        case oDealCanceled:
            resultMsg = @"已取消";
            break;
        default:
            break;
    }
    return resultMsg;
}


#define IOS7 [[[UIDevice currentDevice] systemVersion]floatValue]>=7
#define Height (IOS7?64:44)

//View
#define GET_VIEW_HEIGHT(id) (id.bounds.size.height)
#define GET_VIEW_WIDTH(id) (id.bounds.size.width)


#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


//#define loginCellNormalHeight  35.0
//#define loginCellWrongheight   67.0


#define loginCellNormalHeight  43.0
#define loginCellWrongheight   75.0
#define remindCellHeightForOneLine 30.0;

#define UMengAPPKey  @"5331460e56240bb2670075ff"


#pragma mark - SSO授权登录分享

//#define kSinaAppKey        @"721883611"
//#define kAppSecret         @"f518e07e64886a9c971a901a0e4c7489"

//#define kSinaAppKey        @"3955885131"
//#define kAppSecret         @"36f15e69c058361c3cdf5a0c588f5d2b"

//#define kRedirectURL      @"http://www.sina.com"
#define kRedirectURL       @"https://api.weibo.com/oauth2/default.html"
#define kSinaUserInfo      @"sinaResponseUserInfo"
#define kSinaExpireDate    @"sinaExoireDate"
#define kSinaAccessToken   @"sinaAccessToken"

//WeiChat
//#define WEICHAT_AppKey     @"wx8949e2f8b78e171d"


//For only
#define WEICHAT_AppKey     @"wx62ea9291649a8504"

#define USERID  @"15210048796"

/**********************支付信息***********************/

#define APPURLSCHEME  @"AliPayForOnly"


#define NOTIFICATION_ALIPAY_KEY  @"NOTIFICATION_ALIPAY_KEY"

#define ProductCompanyName @"绫致时装(天津)有限公司"

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088901691044183"

//收款支付宝账号
#define SellerID  @"onlyofficial@bestseller.com.cn"




//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @"ovsvtt59vc41n9ou92nybwwb4w0w59cf"

//商户私钥，自助生成


#define PartnerPrivKey @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAJmXxj9Hed1yI7BpXT188ZwXqYE0UHFG9rPhc0wdgTTh8jO2Qd4++Jv8uwVaPsjU5rZXFVWpyU1D1GIbOdDuvswhsJDM5xIV7fCi/sLsl50f5OumUYovneNaPmFEE9JFQxkS4IXIX83kYKynhxfxdJp8CzqZ9CGo/cYrEElRuHZtAgMBAAECgYEAlTSkyLo1v5Lu6qQgiOgEij9OUg6xCqoGZM5hxBJxfx7zu5qVOEJyHo6QW+3ESjLQgVftiM8sl9uJyVhrfPVA8OlhUyabger08sdS1Yfh5oYSPdOJmkiPUTHd4nni9j6j0XAM3OLgj0aUxjiiL8r9FXAvemnQn/kEM5ryko99fx0CQQDMpF05/TQrnWxPwxkL8FSS5mYvxu7YvcJxrWV7CYF8Jcy8VR/HwfS4W/lJLG9v/VolP3FXPd6EQym+JPTMdMZTAkEAwCOnctz3GOUWbs2MO0QaRcti1rUDc6CqU7gJ4UgL0XU2zUbdLNzG8KCV3VAkN3Fe7yI+jKJ+47+EqyPmddC4PwJBAKg2GuOFvBJ1zggqSDZGEF7HwAtZrA7AvEoQy6+8+pB/ybCtD/h096FrCJgbTGZzjFu9sH6TvopdYryHSCmfez0CQA/1JhwZFACiTimnsqTddB0l1jCk2gOJbXwEhfWK6UhdJs8HuqjWMUOc4rV9yXQ9WzgbLPy7JjS+HEOmeKaCTjsCQDER98g40OhZJuRPS15MyYGp/Jz+HG3avE5NSf3VVjS8ogea/CQE20wF1Duo3dbJUfS5IIMvUI6ByAxf+nXEQlE="


#define PartnerPublicKey @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCZl8Y/R3ndciOwaV09fPGcF6mBNFBxRvaz4XNMHYE04fIztkHePvib/LsFWj7I1Oa2VxVVqclNQ9RiGznQ7r7MIbCQzOcSFe3wov7C7JedH+TrplGKL53jWj5hRBPSRUMZEuCFyF/N5GCsp4cX8XSafAs6mfQhqP3GKxBJUbh2bQIDAQAB"

//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"




/*
 支付宝账号：
 账户：alipay-test09@alipay.com
 PID:2088101568358171
 KEY：uxt01uurwxvstkxpmleeok76ezicp8k4
 
 
 银联测试账号信息：
 商户名：绫致时装有限公司
 商户号：880000000001165
 合作秘钥：Z08gWIWFfV03pdLlgFfamNrD2Tuhykzc
 交易地址：upmp.trade.url=http://222.66.233.198:8080/gateway/merchant/trade
 查询地址：upmp.query.url=http://222.66.233.198:8080/gateway/merchant/query
 测试卡号信息：
 银行：招商银行
 卡类型：预付费
 卡号：6226440123456785
 密码：111101
 这是绫致的测试商户号
 
 
 */


//百度地图相关
//ONLY	kS95ZTLeyRyOOrUGWFkWo8CG
//JACK&JONES	zmt92ydLwAINPPoZGfEpjnsr
//J_LINDEBERG	jMowFTLFUjsTx4QN9dSmSI2y
//SELECTED	Lq7UXHesDwH5pCGQi4kUXyh8
//VERO MODA	xsZsCepXpQ4LETUnmD09x57G
//only
#define BAIDU_MAP_KEY  @"kS95ZTLeyRyOOrUGWFkWo8CG"
#define SEARCH_CODE  @"only"

//JACKJONES
//#define BAIDU_MAP_KEY  @"zmt92ydLwAINPPoZGfEpjnsr"
//#define SEARCH_CODE  @"jackjones"

////JLINDEBERG
//#define BAIDU_MAP_KEY  @"jMowFTLFUjsTx4QN9dSmSI2y"
//#define SEARCH_CODE  @"jlindeberg"

////SELECTED
//#define BAIDU_MAP_KEY_FOR_SELECTED  @"Lq7UXHesDwH5pCGQi4kUXyh8"
//#define SEARCH_CODE  @"selected"

////VEROMODA
//#define BAIDU_MAP_KEY  @"xsZsCepXpQ4LETUnmD09x57G"
//#define SEARCH_CODE  @"veromoda"

//systemBelongsId
typedef enum : NSUInteger {
    ONLY_APP       = 1,
    JACKJONES_APP  = 2,
    VEROMODA_APP   = 3,
    SELECTED_APP   = 4,
    JLINDEBERG_APP = 5
} AppBelongsId;

#define AppSystemId  [NSString stringWithFormat:@"%d",ONLY_APP]

/**********************全局通知***********************/
#define checkMainData @"checkMainData"

