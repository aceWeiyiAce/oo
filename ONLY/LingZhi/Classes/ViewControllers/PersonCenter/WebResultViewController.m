//
//  WebResultViewController.m
//  LingZhi
//
//  Created by xjm on 14-4-29.
//
//

#import "WebResultViewController.h"

@interface WebResultViewController ()
{

    __weak IBOutlet UIWebView *_resultView;
}

@property (nonatomic,strong) UIWebView * web;
@end

@implementation WebResultViewController

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
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    [_resultView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backToPreviewAction:(id)sender {
    
//    if (_delegate && [_delegate respondsToSelector:@selector(reloadCamera)]) {
//        [_delegate reloadCamera];
//    }
    [self.navigationController popViewControllerAnimated:YES];

}

@end
