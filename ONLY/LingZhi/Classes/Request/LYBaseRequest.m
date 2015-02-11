//
//  LYBaseRequest.m
//  LingZhi
//
//  Created by boguoc on 14-3-25.
//
//

#import "LYBaseRequest.h"
#import "HomeListModel.h"
#import "HomeModel.h"
#import "ProductCellModel.h"
#import "CartModel.h"
#import "ProductInfoModel.h"
#import "AddressModel.h"
#import "ClassificationModel.h"
#import "SecondClassModel.h"
#import "CityModel.h"
#import "LogisticsTrackModel.h"
#import "OrderDetailInfoModel.h"

@implementation LYBaseRequest

@end

@implementation HomeRecommendListRequest

-(NSString *)getRequestUrl
{
    return requestUrl(@"info/ctg");
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}
//首页推荐
-(void)processResult
{
    [super processResult];
    ITTDPRINT(@"首页的数据为-----------%@",self.handleredResult);
    if ([self isSuccess]) {
//        NSLog(@"%@",self.handleredResult);
        
        NSMutableArray *data = [[NSMutableArray alloc]init];
        
        NSArray *array = self.handleredResult[@"data"];
        for (NSDictionary *dic in array) {
            HomeListModel *homeList = [[HomeListModel alloc]initWithDataDic:dic];
            homeList.pageNum = @"0";
            NSArray *arr = dic[@"categoryList"];
            
            NSMutableArray *homes = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in arr) {
                HomeModel *home = [[HomeModel alloc]initWithDataDic:dic];
                [homes addObject:home];
            }
            homeList.homes = homes;
            [data addObject:homeList];
        }
        [self.handleredResult setObject:data forKey:@"keyModel"];
    }
}

@end

@implementation GetCategoryListRequest

-(NSString *)getRequestUrl
{
    return requestUrl(@"info/ctg");
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}
//首页列表
-(void)processResult
{
    [super processResult];
    if ([self isSuccess]) {
//        NSLog(@"%@",self.handleredResult);
        
        NSMutableArray *data1 = [[NSMutableArray alloc]init];
        
        ClassificationModel *homeOne = [[ClassificationModel alloc]init];
        homeOne.name = @"特别推荐";
        homeOne.isSelect = @"0";
        [data1 addObject:homeOne];
        
        if (![self.handleredResult[@"data"] isKindOfClass:[NSArray class]]) {
            return;
        }
        NSArray *array = self.handleredResult[@"data"];
        for (NSDictionary *dic in array) {
            NSArray *arr = dic[@"categoryList"];
            ClassificationModel *home = [[ClassificationModel alloc]initWithDataDic:arr[0]];
            home.isSelect = @"0";
            
            NSMutableArray *temp = [[NSMutableArray alloc]init];
            for (int i = 1 ;i < arr.count; i++) {
                HomeModel *second = [[HomeModel alloc]initWithDataDic:arr[i]];
                [temp addObject:second];
            }
            home.classArray = temp;
            [data1 addObject:home];
        }
        
        ClassificationModel *homeLast = [[ClassificationModel alloc]init];
        homeLast.name = @"更多";
        homeLast.isSelect = @"0";
        
        NSArray *Seconds = [NSArray arrayWithObjects:@"我的足迹",@"附近门店",@"清理缓存",@"退换货服务说明",@"通知设置",@"关于我们",@"联系我们",@"给我评分", nil];
        NSMutableArray *moreArr = [[NSMutableArray alloc]init];
        for (NSString *str in Seconds) {
            HomeModel *homeS = [[HomeModel alloc]init];
            homeS.className = str;
            [moreArr addObject:homeS];
        }
        homeLast.classArray = moreArr;
        [data1 addObject:homeLast];
        
        
        [self.handleredResult setObject:data1 forKey:@"keyModel"];
    }
}

@end

@implementation ProtuctListRequest

-(NSString *)getRequestUrl
{
    return requestUrl(@"/product/toPList");
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}

-(void)processResult
{
    [super processResult];
    
    if ([self isSuccess]) {
        NSLog(@"end__Pk%@",self.handleredResult);
        
        NSMutableArray *data = [[NSMutableArray alloc]init];
        
        NSArray *array = self.handleredResult[@"data"][@"productArry"];
        for (NSDictionary *dic in array) {
            ProductCellModel *model = [[ProductCellModel alloc]initWithDataDic:dic];
            [data addObject:model];
        }
        [self.handleredResult setObject:data forKey:@"keyModel"];
    }
}

@end

@implementation GetCartListRequest      //购物车列表

-(NSString *)getRequestUrl
{
    return requestUrl(@"info/getProsByShopcarts");
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}

-(void)processResult
{
    [super processResult];
//    NSLog(@"%@",self.handleredResult);
    if ([self isSuccess]) {
        
        NSMutableArray *data = [[NSMutableArray alloc]init];
        
//        if ([NSJSONSerialization isValidJSONObject:self.handleredResult[@"data"]]) {
//            NSData *dataa = [NSJSONSerialization dataWithJSONObject:self.handleredResult[@"data"] options:NSJSONWritingPrettyPrinted error:nil];
//            NSLog(@"%@",dataa);
//            NSString *str = [[NSString alloc]initWithData:dataa encoding:4];
//            NSLog(@"%@",str);
//        }
        
        NSArray *array = self.handleredResult[@"data"][@"productInfoList"];
        for (NSDictionary *dic in array) {
            CartModel *cart = [[CartModel alloc]initWithDataDic:dic];
            cart.isSelect = @"0";
            cart.productInfo = [[ProductInfoModel alloc]initWithDataDic:dic];
            if ([cart.buyCount integerValue]>[cart.houseCount integerValue] || [cart.productInfo.state isEqualToString:@"-1"]) {
                cart.hasTip = @"1";
            }
            [data addObject:cart];


        }
        [self.handleredResult setObject:data forKey:@"keyModel"];
    }
    
}

@end
//172.16.10.181:8080/SI/lzAddress/toAddressList.do?loginName=15210079564

@implementation getAddressListRequest

-(NSString *)getRequestUrl
{
    return requestUrl(@"lzAddress/toAddressVoList");
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
        NSMutableArray *data = [[NSMutableArray alloc]init];
        
        NSArray *array = self.handleredResult[@"data"];
        for (NSDictionary *dic in array) {
            AddressModel *address = [[AddressModel alloc]initWithDataDic:dic];
            address.isSelect = @"0";
            [data addObject:address];
        }
        [self.handleredResult setObject:data forKey:@"keyModel"];
    }
}

@end

@implementation DeleteCartRequest

-(NSString *)getRequestUrl
{
    return requestUrl(@"info/deleteShopCart");
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
        
    }
}

@end

@implementation GetCityListRequest      //城市列表

-(NSString *)getRequestUrl
{
    return requestUrl(@"lzAddress/findProvinceList");
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
        NSArray *array = self.handleredResult[@"data"];
        
        NSMutableArray *data = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in array) {
            CityModel *model = [[CityModel alloc]initWithDataDic:dic];
            [data addObject:model];
        }
        [self.handleredResult setObject:data forKey:@"keyModel"];
    }
}

@end

@implementation GetAreaListRequest      //地区列表

-(NSString *)getRequestUrl
{
    return requestUrl(@"lzAddress/findCityArea");
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
        if ([(self.handleredResult[@"data"]) isKindOfClass:[NSArray class]]) {
            NSArray *array = self.handleredResult[@"data"];
            
            NSMutableArray *data = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in array) {
                CityModel *model = [[CityModel alloc]initWithDataDic:dic];
                [data addObject:model];
            }
            [self.handleredResult setObject:data forKey:@"keyModel"];
        }
        
    }
}

@end

@implementation UpdataAddressRequest      //上传地址

-(NSString *)getRequestUrl
{
    return requestUrl(@"lzAddress/addressComplate");
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}

-(void)processResult
{
    [super processResult];
    NSLog(@"%@",self.handleredResult);
    if ([self isSuccess]) {

        
    }
}

@end

@implementation GetDeliveryListRequest      //物流

-(NSString *)getRequestUrl
{
    return requestUrl(@"onlyLZOrder/getWuLiuByOrderId");
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
        NSMutableArray *data = [[NSMutableArray alloc]init];
        
        NSArray *array = self.handleredResult[@"data"][@"dataList"];
        for (int i = 0; i<array.count; i++) {
            LogisticsTrackModel *model = [[LogisticsTrackModel alloc]initWithDataDic:array[i]];
            if (0 == i) {
                model.status = @"1";
                model.line = @"1";
            } else if (array.count -1 == i){
                model.line = @"2";
            } else {
                model.line = @"0";
            }
            [data addObject:model];
        }
        [self.handleredResult setObject:data forKey:@"kModel"];
    }
}

@end

@implementation CartCheckoutRequest      //购物车结算

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
//    NSLog(@"%@",self.handleredResult);
    if ([self isSuccess]) {
        NSString *message = self.handleredResult[@"messg"];
        if ([message isEqualToString:@"订单失败,商品库存不足"]) {
            NSMutableArray *data = [[NSMutableArray alloc]init];
            
            NSArray *array = self.handleredResult[@"data"][@"productInfoList"];
            
            for (NSDictionary *dic in array) {
                CartModel *cart = [[CartModel alloc]init];
                cart.productInfo = [[ProductInfoModel alloc]initWithDataDic:dic];
                if ([cart.productInfo.enough isEqualToString:@"0"]) {
                    cart.hasTip = @"1";
                }
                [data addObject:cart];
            }
            [self.handleredResult setObject:data forKey:@"kModel"];
        } else {
            NSDictionary *dictionary = self.handleredResult[@"data"];
            OrderDetailInfoModel *model = [[OrderDetailInfoModel alloc]initWithDataDic:self.handleredResult[@"data"]];
            NSMutableArray *products = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in dictionary[@"pInfoList"]) {
                ProductInfoModel *infoModel = [[ProductInfoModel alloc]initWithDataDic:dic];
                [products addObject:infoModel];
            }
            model.products = products;
            
            [self.handleredResult setObject:model forKey:@"kModel"];
        }
    }
}

@end

@implementation PadLoginRequest

-(NSString *)getRequestUrl
{
//    return @"http://172.16.8.200:8080/guide_shop/LoginRegistController/saveScanLoginMark.do";
//    return requestUrl(@"guide_shop/LoginRegistController/saveScanLoginMark");
    return scanLoginRequestUrl;
}

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}

//-(void)processResult
//{
//    [super processResult];
//    //    NSLog(@"%@",self.handleredResult);
//    if ([self isSuccess]) {
//        NSString *message = self.handleredResult[@"messg"];
//        if ([message isEqualToString:@"订单失败,商品库存不足"]) {
//            NSMutableArray *data = [[NSMutableArray alloc]init];
//            
//            NSArray *array = self.handleredResult[@"data"][@"productInfoList"];
//            
//            for (NSDictionary *dic in array) {
//                CartModel *cart = [[CartModel alloc]init];
//                cart.productInfo = [[ProductInfoModel alloc]initWithDataDic:dic];
//                if ([cart.productInfo.enough isEqualToString:@"0"]) {
//                    cart.hasTip = @"1";
//                }
//                [data addObject:cart];
//            }
//            [self.handleredResult setObject:data forKey:@"kModel"];
//        } else {
//            NSDictionary *dictionary = self.handleredResult[@"data"];
//            OrderDetailInfoModel *model = [[OrderDetailInfoModel alloc]initWithDataDic:self.handleredResult[@"data"]];
//            NSMutableArray *products = [[NSMutableArray alloc]init];
//            for (NSDictionary *dic in dictionary[@"pInfoList"]) {
//                ProductInfoModel *infoModel = [[ProductInfoModel alloc]initWithDataDic:dic];
//                [products addObject:infoModel];
//            }
//            model.products = products;
//            
//            [self.handleredResult setObject:model forKey:@"kModel"];
//        }
//    }
//}


@end

