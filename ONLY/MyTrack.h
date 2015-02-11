//
//  MyTrack.h
//  LingZhi
//
//  Created by pk on 3/21/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MyTrack : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * productId;
@property (nonatomic, retain) NSString * productInfo;
@property (nonatomic, retain) NSString * productPrice;

@end
