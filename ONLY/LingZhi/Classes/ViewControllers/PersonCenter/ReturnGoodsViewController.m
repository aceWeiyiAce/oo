//
//  ReturnGoodsViewController.m
//  LingZhi
//
//  Created by pk on 3/17/14.
//
//

#import "ReturnGoodsViewController.h"
#import "RegisterViewController.h"

#import "OnlyRegisterViewController.h"

@interface ReturnGoodsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *_tableView;
    IBOutlet UIImageView *_imageView;
    IBOutlet UIView *_footView;
    
}
@end

@implementation ReturnGoodsViewController

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
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout= UIRectEdgeNone;
    }
    
    _tableView.tableHeaderView = _imageView;
    _tableView.tableFooterView = _footView;
   
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(140, GET_VIEW_HEIGHT(_imageView) - 30, 40, 30);

    [button addTarget:self action:@selector(goTOTopAction:) forControlEvents:UIControlEventTouchUpInside];
    [_imageView addSubview:button];
    [_imageView setUserInteractionEnabled:YES];

}

-(void)goTOTopAction:(id)sender
{
    [UIView animateWithDuration:0.3f animations:^{
        _tableView.contentOffset = CGPointMake(0, 0);
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToPreviewAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)gotoRegisterAction:(id)sender {
//    RegisterViewController * registerVc = [[RegisterViewController alloc] init];
//    [self.navigationController pushViewController:registerVc animated:YES];
    
    OnlyRegisterViewController *only = [[OnlyRegisterViewController alloc] init];
    [self.navigationController pushViewController:only animated:YES];
}




@end
