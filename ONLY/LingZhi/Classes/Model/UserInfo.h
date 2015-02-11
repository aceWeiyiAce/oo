//
//  UserInfo.h
//  LingZhi
//
//  Created by boguoc on 14-4-25.
//
//

#import "OnlyBaseModel.h"

@interface UserInfo : OnlyBaseModel

@property (nonatomic ,strong)NSString *userId;
@property (nonatomic ,strong)NSString *sound;
@property (nonatomic ,strong)NSString *silent;
@property (nonatomic ,strong)NSString *vibration;
@property (nonatomic ,strong)NSString *isOpenNoti;

@end
