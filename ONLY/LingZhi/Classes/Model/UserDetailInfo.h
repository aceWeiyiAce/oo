//
//  UserDetailInfo.h
//  LingZhi
//
//  Created by kping on 14-8-18.
//
//

#import "OnlyBaseModel.h"

@interface UserDetailInfo : OnlyBaseModel

@property (nonatomic,strong) NSString *loginName;
@property (nonatomic,strong) NSString *realName;
@property (nonatomic,strong) NSString *birthday;
@property (nonatomic,strong) NSString *sex;

@end
