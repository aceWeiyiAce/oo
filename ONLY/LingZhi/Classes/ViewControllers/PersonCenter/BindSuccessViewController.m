//
//  BindSuccessViewController.m
//  LingZhi
//
//  Created by kping on 14-8-15.
//
//

#import "BindSuccessViewController.h"

@interface BindSuccessViewController ()
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@end

@implementation BindSuccessViewController

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
    _mainView.layer.borderColor = [UIColor blackColor].CGColor;
    _mainView.layer.borderWidth = 1.0;
}

- (IBAction)backRootVcAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
