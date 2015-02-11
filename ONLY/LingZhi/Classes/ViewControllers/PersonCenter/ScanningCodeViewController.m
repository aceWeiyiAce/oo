//
//  ScanningCodeViewController.m
//  LingZhi
//
//  Created by boguoc on 14-2-27.
//
//

#import "ScanningCodeViewController.h"
#import "WebResultViewController.h"
#import "ProductDetailInfoController.h"
#import "ScanLoginViewController.h"
#import "ScanDetailWebController.h"


#define SCANNER_WIDTH 200.0f


@interface ScanningCodeViewController ()
//<WebResultViewControllerDelegate>
{
    BOOL isScaned;
}

@property (nonatomic, strong) ZXCapture * capture;
@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic,strong) UIImageView *lineView;//扫描线
@property (nonatomic,assign) BOOL willUp;//扫描移动方向
@property (nonatomic,strong) NSTimer *timer;//扫描线定时器

@property (nonatomic,strong) ProductDetailInfoController *detailVc;
@end

@implementation ScanningCodeViewController{
    CGFloat scanner_X;
    CGFloat scanner_Y;
    CGRect viewFrame;
    
}


//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

//- (void)dealloc
//{
//    self.resultLabel=nil;
//    self.capture=nil;
//    [self.timer invalidate];
//    self.timer = nil;
//    self.lineView=nil;
//}




////扫描线动画
//-(void)lineAnimation{
//    float y=self.lineView.frame.origin.y;
//    if (y<=scanner_Y) {
//        self.willUp=NO;
//    }else if(y>=scanner_Y+SCANNER_WIDTH){
//        self.willUp=YES;
//    }
//    if(self.willUp){
//        y-=2;
//        self.lineView.frame=CGRectMake(scanner_X, y, SCANNER_WIDTH , 2);
//    }else{
//        y+=2;
//        self.lineView.frame=CGRectMake(scanner_X, y, SCANNER_WIDTH, 2);
//    }
//}
//
-(void)initBackgroundView{
    CGRect scannerFrame=CGRectMake(scanner_X, scanner_Y,SCANNER_WIDTH, SCANNER_WIDTH);
    float x=scannerFrame.origin.x;
    float y=scannerFrame.origin.y;
    float width=scannerFrame.size.width;
    float height=scannerFrame.size.height;
    float mainWidth=viewFrame.size.width;
    
    UIView *upView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, mainWidth, y-64)];

//    UIButton *clearBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    clearBtn.frame=CGRectMake(70, 36, 45, 34);
//    [clearBtn setImage:[UIImage imageNamed:@"ScanCamera.png"] forState:UIControlStateNormal];
//    [clearBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//    [clearBtn addTarget:self action:@selector(restart) forControlEvents:UIControlEventTouchUpInside];
//    [upView addSubview:clearBtn];
//    
//    UIButton *submitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    submitBtn.frame=CGRectMake(190, 36, 60, 32);
//    [submitBtn setImage:[UIImage imageNamed:@"ScanKeyBoard.png"] forState:UIControlStateNormal];
//    [submitBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//    [submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
//    [upView addSubview:submitBtn];

    
    UIView *leftView=[[UIView alloc]initWithFrame:CGRectMake(0, y, x, height)];
    UIView *rightView=[[UIView alloc]initWithFrame:CGRectMake(x+width, y, mainWidth-x-width, height)];
    UIView *downView=[[UIView alloc]initWithFrame:CGRectMake(0, y+height, mainWidth, SCREEN_HEIGHT-y-64)];
    
    NSArray *viewArray=[NSArray arrayWithObjects:upView,downView,leftView,rightView, nil];
    for (UIView *view in viewArray) {
        view.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
        [self.view addSubview:view];
    }
    //    UIImageView * imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    //    imageView.image = [UIImage imageNamed:@"C14.jpg"];
    //    imageView.alpha = 0.6;
//        [self.view addSubview:imageView];
}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    [self reloadCamera];
//}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
////    [self reloadCamera];
//    
//    self.capture.delegate = self;
//    [self.timer setFireDate:[NSDate distantPast]];
//}
//
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    self.capture.delegate = nil;
//    [self.timer setFireDate:[NSDate distantFuture]];
//}
//
//-(void)showCamera
//{
//    //扫描器初始化
//    self.capture = [[ZXCapture alloc] init];
//    self.capture.camera = self.capture.back;
//    self.capture.focusMode = AVCaptureFocusModeAutoFocus;
//    NSLog(@"hints =  %@",self.capture.hints);
//    
//    
//    //    self.capture.layer.frame = self.view.bounds;
//    [self.capture.layer setFrame:CGRectMake(0, 64, 320, SCREEN_HEIGHT-64)];
//    
//    
//    //    self.capture.rotation=90.0f;//可以竖屏扫描条形码
//    [self.view.layer addSublayer:self.capture.layer];
//    
//    
//    //坐标初始化
//    CGRect frame=self.view.frame;
//    NSLog(@"frame = %@",NSStringFromCGRect(frame));
//    
//    //如果是ipad，横屏，交换坐标
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
//        viewFrame=CGRectMake(frame.origin.y, frame.origin.x, frame.size.height, frame.size.width);
//    }else{
//        viewFrame=self.view.bounds;
//    }
//    CGPoint centerPoint=CGPointMake(viewFrame.size.width/2, viewFrame.size.height/2);
//    //扫描框的x、y坐标
//    scanner_X=centerPoint.x-(SCANNER_WIDTH/2);
//    scanner_Y=centerPoint.y-(SCANNER_WIDTH/2) + 15;
////    scanner_Y=centerPoint.y-(SCANNER_WIDTH/2);
//    
//    //半透明背景初始化
//    [self initBackgroundView];
//    //扫描框
//    CGRect scanFrame = CGRectMake(scanner_X-5, scanner_Y -5, SCANNER_WIDTH+10, SCANNER_WIDTH+10);
//    UIImageView *borderView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"border"]];
//    borderView.frame= scanFrame;
//    
//    [self.view addSubview:borderView];
//    //扫描线
//    self.lineView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line"]];
//    self.lineView.frame=CGRectMake(scanner_X, scanner_Y, SCANNER_WIDTH, 2);
//    [self.view addSubview:self.lineView];
//    self.timer=[NSTimer scheduledTimerWithTimeInterval:0.02f target:self selector:@selector(lineAnimation) userInfo:nil repeats:YES];
//    
//    
//    //菜单
//    float viewHeight=viewFrame.size.height;
//    float viewWidth=viewFrame.size.width;
//    UIView *menuView=[[UIView alloc]initWithFrame:CGRectMake(0, viewHeight-150, viewWidth, 100)];
//    menuView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f];
//    [self.view addSubview:menuView];
//
//    self.resultLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, viewWidth-20, 40)];
////    self.resultLabel.backgroundColor=[UIColor grayColor];
//    [menuView addSubview:self.resultLabel];
//    self.resultLabel.hidden = YES;
//    self.resultLabel.backgroundColor = [UIColor clearColor];
//    self.resultLabel.textColor = [UIColor whiteColor];
//
//
//
//}
//
//-(void)restart
//{
//    self.resultLabel.text=@"";
//    self.resultLabel.hidden = YES;
//    isScaned = NO;
//}
//
//-(void)clear{
//    self.resultLabel.text=@"";
//}
//
//-(void)submit{
//    ScannerViewController  * scan = [[ScannerViewController alloc] init];
//    [self.navigationController pushViewController:scan animated:YES];
//}
//
//
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//}
//
//-(NSUInteger)supportedInterfaceOrientations {
//	
//	// iPhone only
//	if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
//		return UIInterfaceOrientationMaskPortrait;
//	
//	// iPad only
//	return UIInterfaceOrientationMaskLandscape;
//}
//
//// Supported orientations. Customize it for your own needs
//// Only valid on iOS 4 / 5. NOT VALID for iOS 6.
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//	// iPhone only
//	if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
//		return UIInterfaceOrientationIsPortrait(interfaceOrientation);
//	
//	// iPad only
//	// iPhone only
//	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
//}
//
//#pragma mark -ZXCaptureDelegate
//
//-(void)captureResult:(ZXCapture *)capture result:(ZXResult *)result{
//    
//
//    
////    [self.resultLabel performSelectorOnMainThread:@selector(setText:) withObject:result.text waitUntilDone:YES];
//    
//    
//    if (!isScaned) {
//        NSString * sku = nil;
//        if ([result.text length] == 13) {
//            sku = result.text;
//            [self requestToGetSKUBy13BarCode:sku];
//
//        }else{
//            NSArray * array = [result.text componentsSeparatedByString:@"/"];
//            sku = (NSString *)[array lastObject];
//            [self requestToCheckProductIsExistBySKU:sku];
//
//        }
//        NSLog(@"sku = %@",sku);
//    }
//
//}
//
//
//
-(void)reloadCamera
{
    isScaned = NO;

    //扫描器初始化
    self.capture = [[ZXCapture alloc] init];
    self.capture.camera = self.capture.back;
    self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    self.capture.layer.frame = self.view.bounds;
    self.capture.rotation=90.0f;//可以竖屏扫描条形码
    [self.view.layer addSublayer:self.capture.layer];
    [self.capture.layer setFrame:CGRectMake(0, 64, 320, SCREEN_HEIGHT-64)];
    //坐标初始化
    CGRect frame=self.view.frame;
    //如果是ipad，横屏，交换坐标
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        viewFrame=CGRectMake(frame.origin.y, frame.origin.x, frame.size.height, frame.size.width);
    }else{
        viewFrame=self.view.frame;
    }
    CGPoint centerPoint=CGPointMake(viewFrame.size.width/2, viewFrame.size.height/2);
    //扫描框的x、y坐标
    scanner_X=centerPoint.x-(SCANNER_WIDTH/2);
    scanner_Y=centerPoint.y-(SCANNER_WIDTH/2);
    
    //半透明背景初始化
    [self initBackgroundView];
    //扫描框
    UIImageView *borderView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"border"]];
    borderView.frame=CGRectMake(scanner_X-5, scanner_Y-5, SCANNER_WIDTH+10, SCANNER_WIDTH+10);
    [self.view addSubview:borderView];
    //扫描线
    self.lineView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line"]];
    self.lineView.frame=CGRectMake(scanner_X, scanner_Y, SCANNER_WIDTH, 2);
    [self.view addSubview:self.lineView];
    self.timer=[NSTimer scheduledTimerWithTimeInterval:0.02f target:self selector:@selector(lineAnimation) userInfo:nil repeats:YES];
    
    
//    //菜单
//    float viewHeight=viewFrame.size.height;
//    float viewWidth=viewFrame.size.width;
//    UIView *menuView=[[UIView alloc]initWithFrame:CGRectMake(0, viewHeight-100, viewWidth, 100)];
//    menuView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f];
//    [self.view addSubview:menuView];
//    
//    self.resultLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, viewWidth-20, 40)];
//    self.resultLabel.backgroundColor=[UIColor grayColor];
//    [menuView addSubview:self.resultLabel];
//    
//    UIButton *clearBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    clearBtn.frame=CGRectMake(10, 50, 100, 40);
//    [clearBtn setTitle:@"重新获取" forState:UIControlStateNormal];
//    [clearBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//    [clearBtn addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
//    [menuView addSubview:clearBtn];
//    
//    UIButton *submitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    submitBtn.frame=CGRectMake(viewWidth-110, 50, 100, 40);
//    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
//    [submitBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//    [submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
//    [menuView addSubview:submitBtn];
    
    //菜单
    float viewHeight=viewFrame.size.height;
    float viewWidth=viewFrame.size.width;
    UIView *menuView=[[UIView alloc]initWithFrame:CGRectMake(0, viewHeight-150, viewWidth, 100)];
    menuView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f];
    [self.view addSubview:menuView];

    self.resultLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 30, viewWidth-20, 40)];
//    self.resultLabel.backgroundColor=[UIColor grayColor];
    [menuView addSubview:self.resultLabel];
    self.resultLabel.hidden = YES;
    self.resultLabel.backgroundColor = [UIColor clearColor];
    self.resultLabel.textColor = [UIColor whiteColor];
    
//    UIButton *submitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    submitBtn.frame=CGRectMake(viewWidth-110, 50, 100, 40);
//    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
//    [submitBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//    [submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
//    [menuView addSubview:submitBtn];

}

/********************************************************/
//- (void)dealloc
//{
//    self.resultLabel=nil;
//    self.capture=nil;
//    [self.timer invalidate];
//    self.timer=nil;
//    self.lineView=nil;
//}

//扫描线动画
-(void)lineAnimation{
    float y=self.lineView.frame.origin.y;
    if (y<=scanner_Y) {
        self.willUp=NO;
    }else if(y>=scanner_Y+SCANNER_WIDTH){
        self.willUp=YES;
    }
    if(self.willUp){
        y-=2;
        self.lineView.frame=CGRectMake(scanner_X, y, SCANNER_WIDTH, 2);
    }else{
        y+=2;
        self.lineView.frame=CGRectMake(scanner_X, y, SCANNER_WIDTH, 2);
    }
}

//-(void)initBackgroundView{
//    CGRect scannerFrame=CGRectMake(scanner_X, scanner_Y,SCANNER_WIDTH, SCANNER_WIDTH);
//    float x=scannerFrame.origin.x;
//    float y=scannerFrame.origin.y;
//    float width=scannerFrame.size.width;
//    float height=scannerFrame.size.height;
//    float mainWidth=viewFrame.size.width;
//    float mainHeight=viewFrame.size.height;
//    
//    UIView *upView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, mainWidth, y)];
//    
//    UIView *leftView=[[UIView alloc]initWithFrame:CGRectMake(0, y, x, height)];
//    UIView *rightView=[[UIView alloc]initWithFrame:CGRectMake(x+width, y, mainWidth-x-width, height)];
//    UIView *downView=[[UIView alloc]initWithFrame:CGRectMake(0, y+height, mainWidth, mainHeight-y-height)];
//    
//    NSArray *viewArray=[NSArray arrayWithObjects:upView,downView,leftView,rightView, nil];
//    for (UIView *view in viewArray) {
//        view.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
//        [self.view addSubview:view];
//    }
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(void)clear{
    self.resultLabel.text=@"";
}


- (void)viewWillAppear:(BOOL)animated {
   
    [super viewWillAppear:animated];
    
    isScaned = NO;
    [self reloadCamera];
    
    self.capture.delegate = self;
    [self.timer setFireDate:[NSDate distantPast]];
    
   
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.capture.delegate = nil;
    [self.timer invalidate];

}

- (void)didReceiveMemoryWarni1ng
{
    [super didReceiveMemoryWarning];
}

-(NSUInteger)supportedInterfaceOrientations {
	
	// iPhone only
	if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
		return UIInterfaceOrientationMaskPortrait;
	
	// iPad only
	return UIInterfaceOrientationMaskLandscape;
}

// Supported orientations. Customize it for your own needs
// Only valid on iOS 4 / 5. NOT VALID for iOS 6.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// iPhone only
	if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
		return UIInterfaceOrientationIsPortrait(interfaceOrientation);
	
	// iPad only
	// iPhone only
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark -ZXCaptureDelegate

-(void)captureResult:(ZXCapture *)capture result:(ZXResult *)result{
    
    
//    [self.resultLabel performSelectorOnMainThread:@selector(setText:) withObject:result.text waitUntilDone:YES];
//    if (!isScaned) {
//        NSString * sku = nil;
//        isScaned = !isScaned;
//        ITTDPRINT(@"%@",result.text);
//        if ([result.text length] == 13) {
//            sku = result.text;
//            [self requestToGetSKUBy13BarCode:sku];
//
//        }else{
//            
//            NSRange range = [result.text rangeOfString:@"+"];
//            if (range.location == NSNotFound && ![result.text hasPrefix:@"http:"]) {
////                产品扫描
//                NSArray * array = [result.text componentsSeparatedByString:@"/"];
//                sku = (NSString *)[array lastObject];
//                [self requestToCheckProductIsExistBySKU:sku];
//            }else if ([result.text hasPrefix:@"http:"]){ //扫描订单
//                ScanDetailWebController *scan = [[ScanDetailWebController alloc] init];
//                scan.url = result.text;
//                [self.navigationController pushViewController:scan animated:YES];
//            }else{
//                //pad登录
//                [self padLogin:result.text];
////
//            }
//            
//        }
//        NSLog(@"sku = %@",sku);
//    }
    
    if (!isScaned) {
        NSString * sku = nil;
        isScaned = !isScaned;
//        ITTDPRINT(@"%@",result.text);
        NSRange range = [result.text rangeOfString:@"+"];
        if (range.location == NSNotFound && ![result.text hasPrefix:@"http:"]) {
            //                产品扫描
            if ([result.text length] == 13) {
                sku = result.text;
                [self requestToGetSKUBy13BarCode:sku];
                
            }else{
                NSArray * array = [result.text componentsSeparatedByString:@"/"];
                sku = (NSString *)[array lastObject];
                [self requestToCheckProductIsExistBySKU:sku];
            }
        }else if ([result.text hasPrefix:@"http:"]){ //扫描订单
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:result.text]];
            isScaned = !isScaned;
//            ScanDetailWebController *scan = [[ScanDetailWebController alloc] init];
//            scan.url = result.text;
//            [self.navigationController pushViewController:scan animated:YES];
        }else{ //扫描登录
            [self padLogin:result.text];
        }
        
    }

}

- (void)padLogin:(NSString *)result
{
    NSArray *array = [result componentsSeparatedByString:@"+"];
    if (![@"only" isEqualToString:array[0]]) {
//        self.resultLabel.text = @"请使用对应的客户端扫描登录";
        [UIAlertView promptTipViewWithTitle:@"提示" message:@"请使用对应的客户端扫描登录" cancelBtnTitle:@"确定" otherButtonTitles:nil onDismiss:^(int buttonIndex) {
        } onCancel:^{
            isScaned = !isScaned;
        }];
        return;
    }
    ScanLoginViewController *vc = [[ScanLoginViewController alloc] init];
    vc.padunion = array[1];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark button Methods
- (IBAction)backToPreviewAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

/**
 *  根据15位的SKU码查询是否存在该商品
 */
-(void)requestToCheckProductIsExistBySKU:(NSString * )SKU
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    
    [parameter setObject:SKU forKey:@"pnumber"];
    //新增系统标签参数 at 20140704 by Pk
    [parameter setObject:AppSystemId forKey:@"brandCode"];
    
    __unsafe_unretained ScanningCodeViewController * scanVc = self;
    [RequestToFindProductBySKU requestWithParameters:parameter
                                                 withIndicatorView:nil
                                                 withCancelSubject:@"RequestToFindProductBySKU"
                                                    onRequestStart:nil
                                                 onRequestFinished:^(ITTBaseDataRequest *request) {
   
                                                     if ([request isSuccess]) {
                                                         if ([request.handleredResult[@"data"] intValue] == 1) {
                                                             [self.lineView removeFromSuperview];
                                                                 self.lineView.frame = CGRectMake(scanner_X, scanner_Y, SCANNER_WIDTH, 2);
                                                             self.detailVc = [[ProductDetailInfoController alloc] init];
                                                             _detailVc.pNumber = SKU;
                                                             _detailVc.isScanPush = YES;
                                                             [scanVc.navigationController pushViewController:_detailVc animated:YES];
                                                             self.resultLabel.hidden = YES;
                                                         }else{
                                                             isScaned = NO;
                                                             self.resultLabel.hidden = NO;
                                                             [self.resultLabel performSelectorOnMainThread:@selector(setText:) withObject:@"未找到符合条件的商品!" waitUntilDone:YES];
                                                             self.resultLabel.textAlignment = UITextAlignmentCenter;
                                                         }
                                                     }else{
                                                         isScaned = NO;
                                                         self.resultLabel.hidden = NO;
                                                      [self.resultLabel performSelectorOnMainThread:@selector(setText:) withObject:@"未找到符合条件的商品!" waitUntilDone:YES];
                                                         self.resultLabel.textAlignment = UITextAlignmentCenter;
                                                     }
                                                     
                                                     
                                                 } onRequestCanceled:nil
                                                   onRequestFailed:^(ITTBaseDataRequest *request) {
                                                       
                                                   }];

}

/**
 *  根据13位的条形码获取SKU
 */
-(void)requestToGetSKUBy13BarCode:(NSString *)barCode_13
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    
    [parameter setObject:barCode_13 forKey:@"barCode"];
    //新增系统标签参数 at 20140704 by Pk
    [parameter setObject:AppSystemId forKey:@"brandCode"];
    
    __unsafe_unretained ScanningCodeViewController * scanVc = self;
    
    [RequestToGetProductSKUByBarCode_13 requestWithParameters:parameter
                                   withIndicatorView:nil
                                   withCancelSubject:@"RequestToGetProductSKUByBarCode_13"
                                      onRequestStart:nil
                                   onRequestFinished:^(ITTBaseDataRequest *request) {
                                       
                                       if ([request isSuccess]) {
                                           
                                           if (![request.handleredResult[@"data"] isEqualToString:@""]) {
                                               [self.lineView removeFromSuperview];
                                               self.lineView.frame = CGRectMake(scanner_X, scanner_Y, SCANNER_WIDTH, 2);
                                               self.detailVc = [[ProductDetailInfoController alloc] init];
                                               _detailVc.isScanPush = YES;
                                               _detailVc.pNumber = request.handleredResult[@"data"];
                                               [scanVc.navigationController pushViewController:_detailVc animated:YES];
                                               self.resultLabel.hidden = YES;
                                           }else{
                                               isScaned = NO;
                                               self.resultLabel.hidden = NO;
                                               [self.resultLabel performSelectorOnMainThread:@selector(setText:) withObject:@"未找到符合条件的商品!" waitUntilDone:YES];
                                               self.resultLabel.textAlignment = UITextAlignmentCenter;
                                           }
                                       }else{
                                           isScaned = NO;
                                           self.resultLabel.hidden = NO;
                                           [self.resultLabel performSelectorOnMainThread:@selector(setText:) withObject:@"未找到符合条件的商品!" waitUntilDone:YES];
                                           self.resultLabel.textAlignment = UITextAlignmentCenter;
                                       }
                                       
                                       
                                   } onRequestCanceled:nil
                                     onRequestFailed:^(ITTBaseDataRequest *request) {
                                         
                                     }];

}


@end
