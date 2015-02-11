//
//  MapViewController.m
//  LingZhi
//
//  Created by boguoc on 14-3-4.
//
//

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "MyMapAnnotation.h"
#import "PhoneView.h"
#import "BMKMapView.h"
#import "BMapKit.h"

@interface MapViewController ()<BMKMapViewDelegate>
{
    __weak IBOutlet BMKMapView      *_mapView;
    __weak IBOutlet UILabel         *_titleLabel;
    __weak IBOutlet UILabel         *_addressLabel;
    __weak IBOutlet UILabel         *_areaLabel;
    __weak IBOutlet UILabel         *_cityLabel;
    __weak IBOutlet UIButton        *_phoneButton;
    
    BMKPointAnnotation              *_pointAnnotation;
    BMKAnnotationView               *_newAnnotation;

}
@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.

    //改变地图类型
    [_mapView setZoomLevel:19];
CLLocationCoordinate2D location =CLLocationCoordinate2DMake([self.mapModel.latitude floatValue], [self.mapModel.longitude floatValue]);
    [_mapView setCenterCoordinate:location animated:YES];
//    [self setAnnotionsWithList:nil];

    _pointAnnotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = [self.mapModel.latitude floatValue];
    coor.longitude = [self.mapModel.longitude floatValue];
    _pointAnnotation.coordinate = coor;
    _pointAnnotation.title = nil;
    _pointAnnotation.subtitle = @"此Annotation可拖拽!";
    [_mapView addAnnotation:_pointAnnotation];
    
    [self initMapView];
}

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)initMapView
{
    NSArray *tempArray = [self.mapModel.name componentsSeparatedByString:@"y"];
    NSArray *tempArr = [self.mapModel.name componentsSeparatedByString:@"Y"];
    NSString *tempStr;
    if (tempArray.count > 1) {
        tempStr = [tempArray lastObject];
    } else {
        tempStr = [tempArr lastObject];
    }
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@")" withString:@""];
    if ([tempStr isEqualToString:@""]) {
        tempStr = @"Only";
    }
    _titleLabel.text = tempStr;
    _cityLabel.text = self.mapModel.city;
//    _areaLabel.text = tempStr;
    if (self.mapModel.phone.length > 0) {
        [_phoneButton setTitle:self.mapModel.phone forState:UIControlStateNormal];
    } else {
        _phoneButton.enabled = NO;
    }
    _addressLabel.text = self.mapModel.address;

}

//-(void)setAnnotionsWithList:(NSArray *)list
//{
////    for (NSDictionary *dic in list) {
//    
////        CLLocationDegrees latitude=[[dic objectForKey:@"latitude"] doubleValue];
////        CLLocationDegrees longitude=[[dic objectForKey:@"longitude"] doubleValue];
////        CLLocationCoordinate2D location=CLLocationCoordinate2DMake(latitude, longitude);
//        
//        CLLocationCoordinate2D location = CLLocationCoordinate2DMake([self.mapModel.latitude floatValue], [self.mapModel.longitude floatValue]);
//
//        MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(location,400 ,400 );
//        MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:region];
//        [_mapView setRegion:adjustedRegion animated:YES];
//        
//        MyMapAnnotation *  annotation=[[MyMapAnnotation alloc] initWithLatitude:[self.mapModel.latitude floatValue] andLongitude:[self.mapModel.longitude floatValue]];
//        [_mapView   addAnnotation:annotation];
////    }
//}

#pragma mark - Button Methods

- (IBAction)onBackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onPhoneButton:(id)sender
{
    PhoneView *phone = [PhoneView loadFromXib];
    phone.phoneNum = self.mapModel.phone;
    [phone showPhoneViewForMapViewWithSuperView:self.view
                                title:@"拨打联系电话"
                              content:self.mapModel.phone
                        oneButtonText:@"呼叫"
                        twoButtonText:@"取消"];
}

#pragma mark - MKMapViewDelegate

//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
//{
//    if ([annotation isKindOfClass:[MyMapAnnotation class]]) {
//        
//        MKAnnotationView *annotationView =[_mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
//        if (!annotationView) {
//            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
//                                                           reuseIdentifier:@"CustomAnnotation"];
//            annotationView.canShowCallout = NO;
//            annotationView.image = [UIImage imageNamed:@"ping_img.png"];
//        }
//		
//		return annotationView;
//    }
//    return nil;
//}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"renameMark";
    if (_newAnnotation == nil) {
        _newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        // 设置颜色
		((BMKPinAnnotationView*)_newAnnotation).pinColor = BMKPinAnnotationColorGreen;
        // 从天上掉下效果
		((BMKPinAnnotationView*)_newAnnotation).animatesDrop = NO;
        // 设置可拖拽
		((BMKPinAnnotationView*)_newAnnotation).draggable = NO;
    }
    return _newAnnotation;
}

@end
