//
//  PInfoList.m
//
//  Created by issuser  on 14-8-27
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "PInfoList.h"


NSString *const kPInfoListSizeName = @"sizeName";
NSString *const kPInfoListPurl = @"purl";
NSString *const kPInfoListProductId = @"productId";
NSString *const kPInfoListPrice = @"price";
NSString *const kPInfoListPnumber = @"pnumber";
NSString *const kPInfoListBuyNumber = @"buyNumber";
NSString *const kPInfoListPname = @"pname";
NSString *const kPInfoListTotalPrice = @"totalPrice";
NSString *const kPInfoListColorName = @"colorName";


@interface PInfoList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PInfoList

@synthesize sizeName = _sizeName;
@synthesize purl = _purl;
@synthesize productId = _productId;
@synthesize price = _price;
@synthesize pnumber = _pnumber;
@synthesize buyNumber = _buyNumber;
@synthesize pname = _pname;
@synthesize totalPrice = _totalPrice;
@synthesize colorName = _colorName;


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
            self.sizeName = [self objectOrNilForKey:kPInfoListSizeName fromDictionary:dict];
            self.purl = [self objectOrNilForKey:kPInfoListPurl fromDictionary:dict];
            self.productId = [[self objectOrNilForKey:kPInfoListProductId fromDictionary:dict] doubleValue];
            self.price = [self objectOrNilForKey:kPInfoListPrice fromDictionary:dict];
            self.pnumber = [self objectOrNilForKey:kPInfoListPnumber fromDictionary:dict];
            self.buyNumber = [[self objectOrNilForKey:kPInfoListBuyNumber fromDictionary:dict] doubleValue];
            self.pname = [self objectOrNilForKey:kPInfoListPname fromDictionary:dict];
            self.totalPrice = [self objectOrNilForKey:kPInfoListTotalPrice fromDictionary:dict];
            self.colorName = [self objectOrNilForKey:kPInfoListColorName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.sizeName forKey:kPInfoListSizeName];
    [mutableDict setValue:self.purl forKey:kPInfoListPurl];
    [mutableDict setValue:[NSNumber numberWithDouble:self.productId] forKey:kPInfoListProductId];
    [mutableDict setValue:self.price forKey:kPInfoListPrice];
    [mutableDict setValue:self.pnumber forKey:kPInfoListPnumber];
    [mutableDict setValue:[NSNumber numberWithDouble:self.buyNumber] forKey:kPInfoListBuyNumber];
    [mutableDict setValue:self.pname forKey:kPInfoListPname];
    [mutableDict setValue:self.totalPrice forKey:kPInfoListTotalPrice];
    [mutableDict setValue:self.colorName forKey:kPInfoListColorName];

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

    self.sizeName = [aDecoder decodeObjectForKey:kPInfoListSizeName];
    self.purl = [aDecoder decodeObjectForKey:kPInfoListPurl];
    self.productId = [aDecoder decodeDoubleForKey:kPInfoListProductId];
    self.price = [aDecoder decodeObjectForKey:kPInfoListPrice];
    self.pnumber = [aDecoder decodeObjectForKey:kPInfoListPnumber];
    self.buyNumber = [aDecoder decodeDoubleForKey:kPInfoListBuyNumber];
    self.pname = [aDecoder decodeObjectForKey:kPInfoListPname];
    self.totalPrice = [aDecoder decodeObjectForKey:kPInfoListTotalPrice];
    self.colorName = [aDecoder decodeObjectForKey:kPInfoListColorName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_sizeName forKey:kPInfoListSizeName];
    [aCoder encodeObject:_purl forKey:kPInfoListPurl];
    [aCoder encodeDouble:_productId forKey:kPInfoListProductId];
    [aCoder encodeObject:_price forKey:kPInfoListPrice];
    [aCoder encodeObject:_pnumber forKey:kPInfoListPnumber];
    [aCoder encodeDouble:_buyNumber forKey:kPInfoListBuyNumber];
    [aCoder encodeObject:_pname forKey:kPInfoListPname];
    [aCoder encodeObject:_totalPrice forKey:kPInfoListTotalPrice];
    [aCoder encodeObject:_colorName forKey:kPInfoListColorName];
}

- (id)copyWithZone:(NSZone *)zone
{
    PInfoList *copy = [[PInfoList alloc] init];
    
    if (copy) {

        copy.sizeName = [self.sizeName copyWithZone:zone];
        copy.purl = [self.purl copyWithZone:zone];
        copy.productId = self.productId;
        copy.price = [self.price copyWithZone:zone];
        copy.pnumber = [self.pnumber copyWithZone:zone];
        copy.buyNumber = self.buyNumber;
        copy.pname = [self.pname copyWithZone:zone];
        copy.totalPrice = [self.totalPrice copyWithZone:zone];
        copy.colorName = [self.colorName copyWithZone:zone];
    }
    
    return copy;
}


@end
