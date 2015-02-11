//
//  Data.m
//
//  Created by issuser  on 14-8-27
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "Data.h"
#import "PInfoList.h"


NSString *const kDataTotalCount = @"totalCount";
NSString *const kDataProvince = @"province";
NSString *const kDataTotalPrice = @"totalPrice";
NSString *const kDataPInfoList = @"pInfoList";
NSString *const kDataPostCompany = @"postCompany";
NSString *const kDataPostId = @"postId";
NSString *const kDataOrderNumber = @"orderNumber";
NSString *const kDataDiscount = @"discount";
NSString *const kDataBoroughId = @"boroughId";
NSString *const kDataCity = @"city";
NSString *const kDataCurrentState = @"currentState";
NSString *const kDataContact = @"contact";
NSString *const kDataSubmitDate = @"submitDate";
NSString *const kDataCityId = @"cityId";
NSString *const kDataProvinceId = @"provinceId";
NSString *const kDataPostPrice = @"postPrice";
NSString *const kDataSysDate = @"sysDate";
NSString *const kDataReceiver = @"receiver";
NSString *const kDataAdress = @"adress";
NSString *const kDataPayCompany = @"payCompany";
NSString *const kDataPostCode = @"postCode";
NSString *const kDataBorough = @"borough";
NSString *const kDataOrderId = @"orderId";


@interface Data ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Data

@synthesize totalCount = _totalCount;
@synthesize province = _province;
@synthesize totalPrice = _totalPrice;
@synthesize pInfoList = _pInfoList;
@synthesize postCompany = _postCompany;
@synthesize postId = _postId;
@synthesize orderNumber = _orderNumber;
@synthesize discount = _discount;
@synthesize boroughId = _boroughId;
@synthesize city = _city;
@synthesize currentState = _currentState;
@synthesize contact = _contact;
@synthesize submitDate = _submitDate;
@synthesize cityId = _cityId;
@synthesize provinceId = _provinceId;
@synthesize postPrice = _postPrice;
@synthesize sysDate = _sysDate;
@synthesize receiver = _receiver;
@synthesize adress = _adress;
@synthesize payCompany = _payCompany;
@synthesize postCode = _postCode;
@synthesize borough = _borough;
@synthesize orderId = _orderId;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.totalCount = [[self objectOrNilForKey:kDataTotalCount fromDictionary:dict] doubleValue];
            self.province = [self objectOrNilForKey:kDataProvince fromDictionary:dict];
            self.totalPrice = [self objectOrNilForKey:kDataTotalPrice fromDictionary:dict];
    NSObject *receivedPInfoList = [dict objectForKey:kDataPInfoList];
    NSMutableArray *parsedPInfoList = [NSMutableArray array];
    if ([receivedPInfoList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedPInfoList) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedPInfoList addObject:[PInfoList modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedPInfoList isKindOfClass:[NSDictionary class]]) {
       [parsedPInfoList addObject:[PInfoList modelObjectWithDictionary:(NSDictionary *)receivedPInfoList]];
    }

    self.pInfoList = [NSArray arrayWithArray:parsedPInfoList];
            self.postCompany = [self objectOrNilForKey:kDataPostCompany fromDictionary:dict];
            self.postId = [self objectOrNilForKey:kDataPostId fromDictionary:dict];
            self.orderNumber = [self objectOrNilForKey:kDataOrderNumber fromDictionary:dict];
            self.discount = [[self objectOrNilForKey:kDataDiscount fromDictionary:dict] doubleValue];
            self.boroughId = [self objectOrNilForKey:kDataBoroughId fromDictionary:dict];
            self.city = [self objectOrNilForKey:kDataCity fromDictionary:dict];
            self.currentState = [self objectOrNilForKey:kDataCurrentState fromDictionary:dict];
            self.contact = [self objectOrNilForKey:kDataContact fromDictionary:dict];
            self.submitDate = [self objectOrNilForKey:kDataSubmitDate fromDictionary:dict];
            self.cityId = [self objectOrNilForKey:kDataCityId fromDictionary:dict];
            self.provinceId = [self objectOrNilForKey:kDataProvinceId fromDictionary:dict];
            self.postPrice = [self objectOrNilForKey:kDataPostPrice fromDictionary:dict];
            self.sysDate = [self objectOrNilForKey:kDataSysDate fromDictionary:dict];
            self.receiver = [self objectOrNilForKey:kDataReceiver fromDictionary:dict];
            self.adress = [self objectOrNilForKey:kDataAdress fromDictionary:dict];
            self.payCompany = [self objectOrNilForKey:kDataPayCompany fromDictionary:dict];
            self.postCode = [self objectOrNilForKey:kDataPostCode fromDictionary:dict];
            self.borough = [self objectOrNilForKey:kDataBorough fromDictionary:dict];
            self.orderId = [[self objectOrNilForKey:kDataOrderId fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.totalCount] forKey:kDataTotalCount];
    [mutableDict setValue:self.province forKey:kDataProvince];
    [mutableDict setValue:self.totalPrice forKey:kDataTotalPrice];
    NSMutableArray *tempArrayForPInfoList = [NSMutableArray array];
    for (NSObject *subArrayObject in self.pInfoList) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForPInfoList addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForPInfoList addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForPInfoList] forKey:kDataPInfoList];
    [mutableDict setValue:self.postCompany forKey:kDataPostCompany];
    [mutableDict setValue:self.postId forKey:kDataPostId];
    [mutableDict setValue:self.orderNumber forKey:kDataOrderNumber];
    [mutableDict setValue:[NSNumber numberWithDouble:self.discount] forKey:kDataDiscount];
    [mutableDict setValue:self.boroughId forKey:kDataBoroughId];
    [mutableDict setValue:self.city forKey:kDataCity];
    [mutableDict setValue:self.currentState forKey:kDataCurrentState];
    [mutableDict setValue:self.contact forKey:kDataContact];
    [mutableDict setValue:self.submitDate forKey:kDataSubmitDate];
    [mutableDict setValue:self.cityId forKey:kDataCityId];
    [mutableDict setValue:self.provinceId forKey:kDataProvinceId];
    [mutableDict setValue:self.postPrice forKey:kDataPostPrice];
    [mutableDict setValue:self.sysDate forKey:kDataSysDate];
    [mutableDict setValue:self.receiver forKey:kDataReceiver];
    [mutableDict setValue:self.adress forKey:kDataAdress];
    [mutableDict setValue:self.payCompany forKey:kDataPayCompany];
    [mutableDict setValue:self.postCode forKey:kDataPostCode];
    [mutableDict setValue:self.borough forKey:kDataBorough];
    [mutableDict setValue:[NSNumber numberWithDouble:self.orderId] forKey:kDataOrderId];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.totalCount = [aDecoder decodeDoubleForKey:kDataTotalCount];
    self.province = [aDecoder decodeObjectForKey:kDataProvince];
    self.totalPrice = [aDecoder decodeObjectForKey:kDataTotalPrice];
    self.pInfoList = [aDecoder decodeObjectForKey:kDataPInfoList];
    self.postCompany = [aDecoder decodeObjectForKey:kDataPostCompany];
    self.postId = [aDecoder decodeObjectForKey:kDataPostId];
    self.orderNumber = [aDecoder decodeObjectForKey:kDataOrderNumber];
    self.discount = [aDecoder decodeDoubleForKey:kDataDiscount];
    self.boroughId = [aDecoder decodeObjectForKey:kDataBoroughId];
    self.city = [aDecoder decodeObjectForKey:kDataCity];
    self.currentState = [aDecoder decodeObjectForKey:kDataCurrentState];
    self.contact = [aDecoder decodeObjectForKey:kDataContact];
    self.submitDate = [aDecoder decodeObjectForKey:kDataSubmitDate];
    self.cityId = [aDecoder decodeObjectForKey:kDataCityId];
    self.provinceId = [aDecoder decodeObjectForKey:kDataProvinceId];
    self.postPrice = [aDecoder decodeObjectForKey:kDataPostPrice];
    self.sysDate = [aDecoder decodeObjectForKey:kDataSysDate];
    self.receiver = [aDecoder decodeObjectForKey:kDataReceiver];
    self.adress = [aDecoder decodeObjectForKey:kDataAdress];
    self.payCompany = [aDecoder decodeObjectForKey:kDataPayCompany];
    self.postCode = [aDecoder decodeObjectForKey:kDataPostCode];
    self.borough = [aDecoder decodeObjectForKey:kDataBorough];
    self.orderId = [aDecoder decodeDoubleForKey:kDataOrderId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_totalCount forKey:kDataTotalCount];
    [aCoder encodeObject:_province forKey:kDataProvince];
    [aCoder encodeObject:_totalPrice forKey:kDataTotalPrice];
    [aCoder encodeObject:_pInfoList forKey:kDataPInfoList];
    [aCoder encodeObject:_postCompany forKey:kDataPostCompany];
    [aCoder encodeObject:_postId forKey:kDataPostId];
    [aCoder encodeObject:_orderNumber forKey:kDataOrderNumber];
    [aCoder encodeDouble:_discount forKey:kDataDiscount];
    [aCoder encodeObject:_boroughId forKey:kDataBoroughId];
    [aCoder encodeObject:_city forKey:kDataCity];
    [aCoder encodeObject:_currentState forKey:kDataCurrentState];
    [aCoder encodeObject:_contact forKey:kDataContact];
    [aCoder encodeObject:_submitDate forKey:kDataSubmitDate];
    [aCoder encodeObject:_cityId forKey:kDataCityId];
    [aCoder encodeObject:_provinceId forKey:kDataProvinceId];
    [aCoder encodeObject:_postPrice forKey:kDataPostPrice];
    [aCoder encodeObject:_sysDate forKey:kDataSysDate];
    [aCoder encodeObject:_receiver forKey:kDataReceiver];
    [aCoder encodeObject:_adress forKey:kDataAdress];
    [aCoder encodeObject:_payCompany forKey:kDataPayCompany];
    [aCoder encodeObject:_postCode forKey:kDataPostCode];
    [aCoder encodeObject:_borough forKey:kDataBorough];
    [aCoder encodeDouble:_orderId forKey:kDataOrderId];
}

- (id)copyWithZone:(NSZone *)zone
{
    Data *copy = [[Data alloc] init];
    
    if (copy) {

        copy.totalCount = self.totalCount;
        copy.province = [self.province copyWithZone:zone];
        copy.totalPrice = [self.totalPrice copyWithZone:zone];
        copy.pInfoList = [self.pInfoList copyWithZone:zone];
        copy.postCompany = [self.postCompany copyWithZone:zone];
        copy.postId = [self.postId copyWithZone:zone];
        copy.orderNumber = [self.orderNumber copyWithZone:zone];
        copy.discount = self.discount;
        copy.boroughId = [self.boroughId copyWithZone:zone];
        copy.city = [self.city copyWithZone:zone];
        copy.currentState = [self.currentState copyWithZone:zone];
        copy.contact = [self.contact copyWithZone:zone];
        copy.submitDate = [self.submitDate copyWithZone:zone];
        copy.cityId = [self.cityId copyWithZone:zone];
        copy.provinceId = [self.provinceId copyWithZone:zone];
        copy.postPrice = [self.postPrice copyWithZone:zone];
        copy.sysDate = [self.sysDate copyWithZone:zone];
        copy.receiver = [self.receiver copyWithZone:zone];
        copy.adress = [self.adress copyWithZone:zone];
        copy.payCompany = [self.payCompany copyWithZone:zone];
        copy.postCode = [self.postCode copyWithZone:zone];
        copy.borough = [self.borough copyWithZone:zone];
        copy.orderId = self.orderId;
    }
    
    return copy;
}


@end
