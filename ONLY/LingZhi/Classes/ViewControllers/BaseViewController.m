//
//  BaseViewController.m
//  LingZhi
//
//  Created by kping on 14-6-19.
//
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

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
    // Do any additional setup after loading the view.
    
    UISwipeGestureRecognizer * gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiptToBack:)];
    gesture.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:gesture];
    
}


-(void)swiptToBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 画边框
- (void)drawLinesForLabel:(UIView *)view
{
    view.layer.borderWidth = 0.8f;
    view.layer.borderColor = [[UIColor colorWithRed:0.78f green:0.78f blue:0.78f alpha:1.00f] CGColor];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
