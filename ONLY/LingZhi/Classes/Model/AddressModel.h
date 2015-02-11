//
//  AddressModel.h
//  LingZhi
//
//  Created by boguoc on 14-3-11.
//
//

#import "OnlyBaseModel.h"

@interface AddressModel : OnlyBaseModel

@property (nonatomic,strong) NSString *operation;
@property (nonatomic,strong) NSString *addressId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *province;
@property (nonatomic,strong) NSString *provinceId;

@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *cityId;

@property (nonatomic,strong) NSString *area;
@property (nonatomic,strong) NSString *areaId;

@property (nonatomic,strong) NSString *postalNum;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *isDefault;
@property (nonatomic,strong) NSString *isSelect;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *fixIndex;
@property (nonatomic,strong) NSString *isAdd;

@end
