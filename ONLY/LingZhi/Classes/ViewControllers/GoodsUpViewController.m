//
//  GoodsUpViewController.m
//  JiuBa
//
//  Created by iFangSoft on 15/1/29.
//
//

#import "GoodsUpViewController.h"

@interface GoodsUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *NameTextField;
@property (weak, nonatomic) IBOutlet UITextField *NumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *PayTextField;
@property (weak, nonatomic) IBOutlet UITextView *aboutTextView;
@property (weak, nonatomic) IBOutlet UITextField *AddressTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *GoodsUpScrollView;

@end

@implementation GoodsUpViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    self.GoodsUpScrollView.contentSize = CGSizeMake(320, 1000);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor = [UIColor greenColor];
    self.title = @"商品发布";
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(DidClickTapGestureAction)];
    [self.view addGestureRecognizer:tapGesture];
    
    // Do any additional setup after loading the view from its nib.
}

-(void) DidClickTapGestureAction
{
    [self.NameTextField resignFirstResponder];
    [self.NumberTextField resignFirstResponder];
    [self.PayTextField resignFirstResponder];
    [self.aboutTextView resignFirstResponder];
    [self.AddressTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
