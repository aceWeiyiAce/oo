//
//  PInfoList.h
//
//  Created by issuser  on 14-8-27
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface PInfoList : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *sizeName;
@property (nonatomic, strong) NSString *purl;
@property (nonatomic, assign) double productId;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *pnumber;
@property (nonatomic, assign) double buyNumber;
@property (nonatomic, strong) NSString *pname;
@property (nonatomic, strong) NSString *totalPrice;
@property (nonatomic, strong) NSString *colorName;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
