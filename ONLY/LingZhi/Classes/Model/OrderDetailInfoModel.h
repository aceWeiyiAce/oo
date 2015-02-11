//
//  OrderDetailInfoModel.h
//  LingZhi
//
//  Created by pk on 4/1/14.
//
//

#import "OnlyBaseModel.h"

@interface OrderDetailInfoModel : OnlyBaseModel

@property (nonatomic,strong)NSString *address;
@property (nonatomic,strong)NSString *province;
@property (nonatomic,strong)NSString *provinceId;
@property (nonatomic,strong)NSString *receiver;
@property (nonatomic,strong)NSString *city;
@property (nonatomic,strong)NSString *cityId;
@property (nonatomic,strong)NSString *borough;
@property (nonatomic,strong)NSString *boroughId;
@property (nonatomic,strong)NSString *contact;




@property (nonatomic,strong)NSString *postCode;

@property (nonatomic,strong)NSString *currentState;
@property (nonatomic,strong)NSString *discount;
@property (nonatomic,strong)NSString *orderId;
@property (nonatomic,strong)NSString *payCompany;
@property (nonatomic,strong)NSString *postCompany;
@property (nonatomic,strong)NSString *postId;
@property (nonatomic,strong)NSString *postPrice;
@property (nonatomic,strong)NSString *submitDate;
@property (nonatomic,strong)NSString *sysDate;

@property (nonatomic,strong)NSString *orderNumber;
@property (nonatomic,strong)NSString *totalPrice;
@property (nonatomic,strong)NSString *totalCount;
@property (nonatomic,strong)NSMutableArray *products;




@end
