//
//  PKBaseRequest.m
//  LingZhi
//
//  Created by boguoc on 14-3-25.
//
//

#import "PKBaseRequest.h"
#import "CollectProductModel.h"
#import "ColorModel.h"
#import "SizeModel.h"
#import "OrderModel.h"
#import "OrderDetailInfoModel.h"
#import "ProductDetailInfoModel.h"
#import "AboutUsModel.h"
#import "PostCompanyModel.h"
#import "UserDetailInfo.h"


@implementation PKBaseRequest

@end

//@implementation proListRequest
//
//-(NSString *)getRequestUrl
//{
//    return requestUrl(@"product/plist");
//}
//
//-(ITTRequestMethod)getRequestMethod
//{
//    return ITTRequestMethodGet;
//}
//
//-(void)processResult
//{
//    [super processResult];
//    
//    NSLog(@"%@",self.handleredResult);
//    
//}
//@end


/**
 *  根据商品颜色，获取对应的尺码
 */

@implementation RequestToGetSizeArrayByColor

-(NSString *)getRequestUrl
{
    return requestUrl(@"info/pcs");
}


-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}

-(void)processResult
{
    [super processResult];
    NSLog(@"%@",self.handleredResult);
    NSMutableArray * array = self.handleredResult[@"data"];
    NSMutableArray * dataArr = [NSMutableArray array];
    for (NSDictionary * dic in array) {
        SizeModel * size = [[SizeModel alloc] initWithDataDic:dic];
        [dataArr addObject:size];
    }
    [self.handleredResult addObject:dataArr forKey:@"keyModel"];
    
}

@end



/**
 *  加入收藏
 */
@implementation AddFavoriteRequest  //加入收藏

-(NSString *)getRequestUrl
{
    
    
    return requestUrl(@"info/addc");
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}

-(void)processResult
{
    [super processResult];
    NSLog(@"%@",self.handleredResult);
    
}

@end


/**
 *  删除收藏
 */
@implementation DeleteFavoriteRequest  //删除收藏

-(NSString *)getRequestUrl
{
    return requestUrl(@"info/delc");
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}

-(void)processResult
{
    [super processResult];
    NSLog(@"%@",self.handleredResult);
    
}

@end

/**
 *  收藏列表
 */
@implementation GetFavoriteListRequest  //收藏列表

-(NSString *)getRequestUrl
{
    return requestUrl(@"info/clist");
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}

-(void)processResult
{
    [super processResult];
    NSLog(@"%@",self.handleredResult);
    
    if ([self isSuccess]) {
        NSMutableArray *data = [[NSMutableArray alloc]init];
        
       NSLog(@"class = %@", [[self.handleredResult[@"data"] class] description] );
        if ([[[self.handleredResult[@"data"] class] description] hasSuffix:@"String"]) {
            NSLog(@"string");
            return;
        }else{
            NSLog(@"array");
        }
        
        NSArray *array = self.handleredResult[@"data"];

        for (NSDictionary *dic in array) {
            CollectProductModel *pModel = [[CollectProductModel alloc]initWithDataDic:dic];
            pModel.productInfo = [[ProductInfoModel alloc]initWithDataDic:dic[@"productInfo"]];
            
            NSMutableArray *colors = [[NSMutableArray alloc]init];
            NSArray *cArray = dic[@"productInfo"][@"availableColors"];
            for (NSDictionary *dic in cArray) {
                ColorModel *cModel = [[ColorModel alloc]initWithDataDic:dic];
                [colors addObject:cModel];
            }
            pModel.cModel = colors;
            
            NSMutableArray *sizes = [[NSMutableArray alloc]init];
            NSArray *sArray = dic[@"productInfo"][@"availableSizes"];
            for (NSDictionary *dic in sArray) {
                SizeModel *model = [[SizeModel alloc]initWithDataDic:dic];
                [sizes addObject:model];
            }
            pModel.zModel = sizes;
            [data addObject:pModel];
        }
        [self.handleredResult setObject:data forKey:@"keyModel"];
    }
    
}

@end

/**
 *  加入购物车
 */
@implementation AddCartRequest  //加入购物车

-(NSString *)getRequestUrl
{
    return requestUrl(@"info/addsc");
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}

-(void)processResult
{
    [super processResult];
    NSLog(@"%@",self.handleredResult);
    
}


@end

/**
 *  登录
 */
@implementation LoginRequest

-(NSString *)getRequestUrl
{
    return LoginModel_RequestUrl(@"ssoLogin");
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}

-(void)processResult
{
    [super processResult];
    
}

@end


/**
 *  注册
 */
@implementation RegisterRequest

-(NSString *)getRequestUrl
{
    return LoginModel_RequestUrl(@"member/register");
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}

-(void)processResult
{
    [super processResult];
    
    
}



@end

/**
 *  注册获取验证码
 */
@implementation RegisterCodeRequest

-(NSString *)getRequestUrl
{
    return LoginModel_RequestUrl(@"sendMsg");
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}

-(void)processResult
{
    [super processResult];
    
}
@end


/**
 *  忘记密码获取验证码
 */
@implementation ForgetPassToGetCodeRequest

-(NSString *)getRequestUrl
{
    return LoginModel_RequestUrl(@"updateSend");

}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}

-(void)processResult
{
    [super processResult];
    
}
@end



/**
 *  忘记密码修改密码
 */
@implementation UpdatePasswordRequest

-(NSString *)getRequestUrl
{
    return LoginModel_RequestUrl(@"updatePSW");
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}

-(void)processResult
{
    [super processResult];
    
}
@end


/**
 *  已登陆修改密码
 */
@implementation loginToUpdatePasswordRequest

-(NSString *)getRequestUrl
{
    return LoginModel_RequestUrl(@"loginUpdatePSW");
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}

-(void)processResult
{
    [super processResult];
    
}
@end

/***********************订单相关**********************/

/**
 *  获取订单列表
 */
@implementation RequestOrderList

-(NSString *)getRequestUrl
{
    //ss
    return requestUrl(@"onlyLZOrder/myList");
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}

-(void)processResult
{
    [super processResult];
    
    if ([self isSuccess]) {
        NSMutableArray *data = [[NSMutableArray alloc]init];
        NSArray *array = self.handleredResult[@"data"];
        
        for (NSDictionary *dic in array) {
            
            OrderModel *order = [[OrderModel alloc]initWithDataDic:dic];
            [data addObject:order];
            
        }
        [self.handleredResult setObject:data forKey:@"keyModel"];
    }
    ;

}


@end

/**
 *  获取订单详细信息
 */
@implementation RequestOrderDetailInfo

-(NSString *)getRequestUrl
{
    return requestUrl(@"onlyLZOrder/orderInfo");
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}

-(void)processResult
{
    [super processResult];
    
    if ([self isSuccess]) {
        OrderDetailInfoModel *data = [[OrderDetailInfoModel alloc]initWithDataDic:self.handleredResult[@"data"]];
        
        NSArray * array = self.handleredResult[@"data"][@"pInfoList"];
        NSMutableArray * products = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            
            ProductInfoModel * prodcutInfo = [[ProductInfoModel alloc]initWithDataDic:dic];
            [products addObject:prodcutInfo];
            
        }
        data.products = products;
        [self.handleredResult setObject:data forKey:@"keyModel"];
    }
    ;
    
}
@end


/**
 *  取消订单
 */
@implementation RequestCancelOrder

-(NSString *)getRequestUrl
{
    return requestUrl(@"onlyLZOrder/cancelOrder");
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}

-(void)processResult
{
    [super processResult];
    
}
@end

/**
 *  将商品重新放回购物车
 */
@implementation RequestToReturnProductInShopCar

-(NSString *)getRequestUrl
{
    return requestUrl(@"info/returnShopCarts");
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}

-(void)processResult
{
    [super processResult];
    
}
@end


/**
 *  确认收货
 */
@implementation RequestToConfirmReceiveOrder

-(NSString *)getRequestUrl
{
    return requestUrl(@"onlyLZOrder/confirmReceive");
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}

-(void)processResult
{
    [super processResult];
    
}
@end

/**
 *  保存收获地址
 */
@implementation RequestToSaveReceiceAddress

-(NSString *)getRequestUrl
{
    return requestUrl(@"onlyLZOrder/coa");
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}

-(void)processResult
{
    [super processResult];
    
}
@end


/**
 *  获取快递公司
 */
@implementation RequestToGetPostCompany

-(NSString *)getRequestUrl
{
//    http://118.194.170.63:8080/OnlyServiceIntegration/lzCarrier/findLZCarrier.do
    return requestUrl(@"lzCarrier/findLZCarrier");
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}

-(void)processResult
{
    [super processResult];
    if ([self isSuccess]) {
        
        NSArray * array = self.handleredResult[@"data"];
        NSMutableArray * postCs = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            
            PostCompanyModel * postInfo = [[PostCompanyModel alloc]initWithDataDic:dic];
            [postCs addObject:postInfo];
            
        }
        [self.handleredResult setObject:postCs forKey:@"keyModel"];
    }
    
}
@end


/**
 *  更新快递配送公司和支付方式
 */
@implementation RequestToUpdatePostAndPayCompany

-(NSString *)getRequestUrl
{
    return requestUrl(@"onlyLZOrder/updateExpress");
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}

-(void)processResult
{
    [super processResult];
    
}
@end


/**
 *  更新订单状态
 */
@implementation RequestToUpdateOrderState

-(NSString *)getRequestUrl
{
    return requestUrl(@"onlyLZOrder/updateOState");
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}

-(void)processResult
{
    [super processResult];
    
}
@end


/**************************商品详情*******************************/
/**
 *  获取商品详情
 */
@implementation RequestToGetProdeuctDetailInfo

-(NSString *)getRequestUrl
{
    return requestUrl(@"product/productByProId");
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}

-(void)processResult
{
    [super processResult];
//    NSLog(@"%@",self.handleredResult);
    if ([self isSuccess]) {

        ProductDetailInfoModel * detailProduct = [[ProductDetailInfoModel alloc] initWithDataDic:self.handleredResult[@"data"]];
        
        ProductInfoModel * productInfo = [[ProductInfoModel alloc] initWithDataDic: self.handleredResult[@"data"] ];
        
        NSMutableArray * colors        = [NSMutableArray array];
        NSArray * colorArr             = self.handleredResult[@"data"][@"availableColors"];
        
        NSMutableArray * sizes         = [NSMutableArray array];
        NSArray * sizeArr              = self.handleredResult[@"data"][@"availableSizes"];
        
        NSArray * imageUrls            = self.handleredResult[@"data"][@"availableImages"];
        
        NSMutableArray * matchArr = [NSMutableArray array];
        NSArray * matchs = self.handleredResult[@"data"][@"matchProList"];
        
        for (NSDictionary * dic in colorArr) {
            ColorModel * c = [[ColorModel alloc] initWithDataDic:dic];
            [colors addObject:c];
        }
        
        for (NSDictionary * dic in sizeArr) {
            SizeModel * s = [[SizeModel alloc] initWithDataDic:dic];
            [sizes addObject:s];
        }
        
        for (NSDictionary * dic in matchs) {
            ProductInfoModel * mp = [[ProductInfoModel alloc] initWithDataDic:dic];
            [matchArr addObject:mp];
        }
        
        detailProduct.productInfo   = productInfo;
        detailProduct.colorArr      = colors;
        detailProduct.sizeArr       = sizes;
        detailProduct.imageUrlArr   = [NSMutableArray arrayWithArray:imageUrls];
        detailProduct.macthProducts = matchArr;
        
        NSLog(@"detailProduct =  %@",[detailProduct description]);
        [self.handleredResult addObject:detailProduct forKey:@"keyModel"];
    }
    
}
@end

/**
 *  根据SKU码获取商品的详细信息
 */
@implementation RequestToGetProdeuctDetailInfoBySkuCode

-(NSString *)getRequestUrl
{
    return requestUrl(@"product/productByPnumber");
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}

-(void)processResult
{
    [super processResult];
    NSLog(@"%@",self.handleredResult);
    if ([self isSuccess]) {
        
        ProductDetailInfoModel * detailProduct = [[ProductDetailInfoModel alloc] initWithDataDic:self.handleredResult[@"data"]];
        
        ProductInfoModel * productInfo = [[ProductInfoModel alloc] initWithDataDic: self.handleredResult[@"data"] ];
        
        NSMutableArray * colors        = [NSMutableArray array];
        NSArray * colorArr             = self.handleredResult[@"data"][@"availableColors"];
        
        NSMutableArray * sizes         = [NSMutableArray array];
        NSArray * sizeArr              = self.handleredResult[@"data"][@"availableSizes"];
        
        NSArray * imageUrls            = self.handleredResult[@"data"][@"availableImages"];
        
        NSMutableArray * matchArr = [NSMutableArray array];
        NSArray * matchs = self.handleredResult[@"data"][@"matchProList"];
        
        for (NSDictionary * dic in colorArr) {
            ColorModel * c = [[ColorModel alloc] initWithDataDic:dic];
            [colors addObject:c];
        }
        
        for (NSDictionary * dic in sizeArr) {
            SizeModel * s = [[SizeModel alloc] initWithDataDic:dic];
            [sizes addObject:s];
        }
        
        for (NSDictionary * dic in matchs) {
            ProductInfoModel * mp = [[ProductInfoModel alloc] initWithDataDic:dic];
            [matchArr addObject:mp];
        }
        
        detailProduct.productInfo   = productInfo;
        detailProduct.colorArr      = colors;
        detailProduct.sizeArr       = sizes;
        detailProduct.imageUrlArr   = [NSMutableArray arrayWithArray:imageUrls];
        detailProduct.macthProducts = matchArr;
        
        NSLog(@"detailProduct =  %@",[detailProduct description]);
        [self.handleredResult addObject:detailProduct forKey:@"keyModel"];
        
    }
    
}
@end

/**
 *  查询SKU码对应的商品是否存在
 */
@implementation RequestToFindProductBySKU

-(NSString *)getRequestUrl
{
    return requestUrl(@"product/isPnumber");
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}

-(void)processResult
{
    [super processResult];
    
    if ([self isSuccess]) {
        
    }
    
}

@end




/**
 *  通过13位的条形码获取SKU码
 */
@implementation RequestToGetProductSKUByBarCode_13

-(NSString *)getRequestUrl
{
    return requestUrl(@"pnumberByCode");
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}

-(void)processResult
{
    [super processResult];
    
    if ([self isSuccess]) {
        
    }
    
}

@end


/**
 *  根据商品编号获取库存量
 */
@implementation RequestToGetStorageNum

-(NSString *)getRequestUrl
{
    return requestUrl(@"info/ps");
}


-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}

-(void)processResult
{
    [super processResult];
    
    if ([self isSuccess]) {
        
    }
    
}
@end

/**
 *  直接购买，跳转支付
 */
@implementation RequestToCreateOrderAndGoToPay

-(NSString *)getRequestUrl
{
    return requestUrl(@"info/genOrder");
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}

-(void)processResult
{
    [super processResult];
    
    if ([self isSuccess]) {
        
        OrderDetailInfoModel *data = [[OrderDetailInfoModel alloc]initWithDataDic:self.handleredResult[@"data"]];
        
        NSArray * array = self.handleredResult[@"data"][@"pInfoList"];
        NSMutableArray * products = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            
            ProductInfoModel * prodcutInfo = [[ProductInfoModel alloc]initWithDataDic:dic];
            [products addObject:prodcutInfo];
            
        }
        data.products = products;
        [self.handleredResult setObject:data forKey:@"keyModel"];
    }
    
    ;
    
}
@end

/***********************关于我们*************************/

/**
 *  获取关于我们信息
 */
@implementation RequestToGetAboutUsInfo

-(NSString *)getRequestUrl
{
    return requestUrl(@"cmsLZInfo/toLZInfo");
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}

-(void)processResult
{
    [super processResult];
    
    if ([self isSuccess]) {
        NSMutableArray * infos = [NSMutableArray array];
        NSArray * arr = self.handleredResult[@"data"];
        for (NSDictionary * dic in arr) {
            AboutUsModel * model = [[AboutUsModel alloc] initWithDataDic:dic];
            [infos addObject:model];
        }
        [self.handleredResult addObject:infos forKey:@"keyModel"];
    }
    
}
@end


/**
 *  获取联系我们的电话
 */
@implementation RequestToGetContactTel

-(NSString *)getRequestUrl
{
    return requestUrl(@"lzCallUs");
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}

-(void)processResult
{
    [super processResult];
    
    if ([self isSuccess]) {

    }
    
}
@end


/**
 * 银联支付接口,获取支付流水号
 */
@implementation RequestToGetUnionPayTN

-(NSString *)getRequestUrl
{
    return requestUrl(@"upmpBuy");
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}

-(void)processResult
{
    [super processResult];
    
    if ([self isSuccess]) {
        
    }
    
}

@end

#pragma mark -------------------  1.4 ------------------------
/**
 * 获取个人信息
 */
@implementation RequestToFindMemberInfo

-(NSString *)getRequestUrl
{
    return requestUrl(@"member/findMemberInfo");
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}

-(void)processResult
{
    [super processResult];
    
    if ([self isSuccess]) {

        if (![self.handleredResult[@"data"] isKindOfClass:[NSDictionary class]]) {
            return;
        }
        NSDictionary * dic = self.handleredResult[@"data"];
        UserDetailInfo * detailInfo = [[UserDetailInfo alloc]initWithDataDic:dic];
        [self.handleredResult addObject:detailInfo forKey:@"model"];
    }
    
}

@end

/**
 * 保存个人信息
 */
@implementation RequestToaddMember

-(NSString *)getRequestUrl
{
    return requestUrl(@"member/addMember");
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}

-(void)processResult
{
    [super processResult];
    
    if ([self isSuccess]) {
        
    }
    
}

@end


/**
 * 支付成功生成二维码页面
 */
@implementation RequestTopaySuccessInfo
-(NSString *)getRequestUrl
{
    return requestUrl(@"guide/paySuccessInfo");
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}

-(void)processResult
{
    [super processResult];
    
    if ([self isSuccess]) {
        
    }
}
@end


/**
 * 导购绑定
 */
@implementation RequestToAddGuidBinder

-(NSString *)getRequestUrl
{
    return requestUrl(@"guide/binding");
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}

-(void)processResult
{
    [super processResult];
    
    if ([self isSuccess]) {
        
    }
}

@end



