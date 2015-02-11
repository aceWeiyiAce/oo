//
//  ProductInfo.h
//  LingZhi
//
//  Created by boguoc on 14-3-21.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ProductInfo : NSManagedObject

@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * info;
@property (nonatomic, retain) NSString * material;
@property (nonatomic, retain) NSString * num;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * productId;
@property (nonatomic, retain) NSString * sellCount;
@property (nonatomic, retain) NSString * size;
@property (nonatomic, retain) NSString * stateInOrder;
@property (nonatomic, retain) NSString * storeCount;
@property (nonatomic, retain) NSManagedObject *cart;

@end
