//
//  MyMapAnnotation.h
//  LingZhi
//
//  Created by boguoc on 14-3-4.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MyMapAnnotation : NSObject<MKAnnotation>

@property (nonatomic, strong) NSString *atitle;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;


@end
