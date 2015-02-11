//
//  MapViewController.h
//  LingZhi
//
//  Created by boguoc on 14-3-4.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapModel.h"

@interface MapViewController : UIViewController

@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic,strong) MapModel *mapModel;

@end
