//
//  ProductPicture.h
//  LingZhi
//
//  Created by pk on 14-4-3.
//
//

#import "BaseModel.h"

@interface ProductPicture : BaseModel

@property (nonatomic ,strong) NSString *pictureId;
@property (nonatomic ,strong) NSString *pnumber;
@property (nonatomic ,strong) NSString *imageUrl;

@end
