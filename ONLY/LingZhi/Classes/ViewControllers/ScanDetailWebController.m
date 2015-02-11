//
//  ScanDetailWebController.m
//  LingZhi
//
//  Created by MJ on 14/12/26.
//
//

#import "ScanDetailWebController.h"


@interface ScanDetailWebController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *freshView;

@end

@implementation ScanDetailWebController

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
    
//    http://m.only.cn:8501/OnlyH5/twoCodeOrder.do?totalOrderId=2343
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [_webView loadRequest:request];
    _webView.delegate = self;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma webView delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.freshView.hidden = NO;
    [self.freshView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.freshView stopAnimating];
    self.freshView.hidden = YES;
}


-(void)swiptToBack:(id)sender
{
//    [self.navigationController popViewControllerAnimated:YES];
}

@end
