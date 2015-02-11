//
//  CreateScanCodeViewController.m
//  LingZhi
//
//  Created by kping on 14-8-14.
//
//

#import "CreateScanCodeViewController.h"

#import "OrderDetailController.h"
#import "ZXingObjC.h"
#import "QRCodeGenerator.h"
#import "OrderModel.h"
#import "PKBaseRequest.h"

@interface CreateScanCodeViewController ()
{
    ZXBitMatrix* _result;
    CGImageRef _image;
}

@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *orderCount;
@property (weak, nonatomic) IBOutlet UILabel *orderPrice;
@property (weak, nonatomic) IBOutlet ITTImageView *codeImageView;
@property (weak, nonatomic) IBOutlet UIButton *checkOrderBtn;

@end

@implementation CreateScanCodeViewController

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
    _checkOrderBtn.layer.borderColor = [UIColor blackColor].CGColor;
    _checkOrderBtn.layer.borderWidth = 0.5;
    
    _orderNum.text   = _orderDetail.orderNumber;
    _orderCount.text = _orderDetail.totalCount;
    _orderPrice.text = _orderDetail.totalPrice;
    
    //客户端二维码生成
//    UIColor * codeColor =  [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
//    UIImage * codeImage = [QRCodeGenerator qrImageForString:@"FUCK YOU LU MEI MEI!" imageSize:_codeImageView.frame.size.width withPointType:QRPointRect withPositionType:QRPositionRound withColor:codeColor];
//    [_codeImageView setImage:codeImage];
    
    [self requestToGetBarCode];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - ButtomMethods
- (IBAction)checkOrderAction:(id)sender {
    OrderModel * orderM = [[OrderModel alloc] init];
    orderM.orderId = _orderDetail.orderId;
    orderM.state = _orderDetail.currentState;
    OrderDetailController * detailVc = [[OrderDetailController alloc] init];
    detailVc.order = orderM;
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (IBAction)backGoOnAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)requestToGetBarCode
{
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    [parameter setObject:_orderDetail.orderNumber forKey:@"orderNumber"];
    [parameter setObject:DATA_ENV.userInfo.userId forKey:@"memberNo"];
    
    [RequestTopaySuccessInfo requestWithParameters:parameter
                                withIndicatorView:self.view
                                withCancelSubject:@"RequestTopaySuccessInfo"
                                   onRequestStart:nil
                                onRequestFinished:^(ITTBaseDataRequest *request) {
                                    if ([request isSuccess]) {
                                        if ([request.handleredResult[@"status"] isEqualToString:@"0"]) {
                                            NSString * barCodeUrl = request.handleredResult[@"data"][@"matrixImageUrl"];
                                            [_codeImageView loadImage:barCodeUrl];
                                        }
                                    }
                                    
                                } onRequestCanceled:nil
                                  onRequestFailed:^(ITTBaseDataRequest *request) {
                                      NSLog(@"request = %@",request.handleredResult);
                                  }];
}

@end
