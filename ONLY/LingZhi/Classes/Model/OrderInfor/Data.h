//
//  Data.h
//
//  Created by issuser  on 14-8-27
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Data : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double totalCount;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *totalPrice;
@property (nonatomic, strong) NSArray *pInfoList;
@property (nonatomic, strong) NSString *postCompany;
@property (nonatomic, strong) NSString *postId;
@property (nonatomic, strong) NSString *orderNumber;
@property (nonatomic, assign) double discount;
@property (nonatomic, strong) NSString *boroughId;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *currentState;
@property (nonatomic, strong) NSString *contact;
@property (nonatomic, strong) NSString *submitDate;
@property (nonatomic, strong) NSString *cityId;
@property (nonatomic, strong) NSString *provinceId;
@property (nonatomic, strong) NSString *postPrice;
@property (nonatomic, strong) NSString *sysDate;
@property (nonatomic, strong) NSString *receiver;
@property (nonatomic, strong) NSString *adress;
@property (nonatomic, strong) NSString *payCompany;
@property (nonatomic, strong) NSString *postCode;
@property (nonatomic, strong) NSString *borough;
@property (nonatomic, assign) double orderId;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
