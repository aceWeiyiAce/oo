//
//  MapModel.h
//  LingZhi
//
//  Created by boguoc on 14-3-19.
//
//

#import "OnlyBaseModel.h"

@interface MapModel : OnlyBaseModel

@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *area;
@property (nonatomic,strong) NSString *num;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *latitude;
@property (nonatomic,strong) NSString *longitude;
@property (nonatomic,strong) NSString *city;

@end
