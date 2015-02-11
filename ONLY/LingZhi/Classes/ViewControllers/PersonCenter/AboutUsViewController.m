//
//  AboutUsViewController.m
//  LingZhi
//
//  Created by pk on 3/17/14.
//
//

#import "AboutUsViewController.h"
#import "PKBaseRequest.h"
#import "MRZoomScrollView.h"
#import "AboutUsModel.h"


#define _ContainsViewHeight  131
#define _textViewHeight      100

@interface AboutUsViewController ()<UIScrollViewDelegate>
{
    
    IBOutlet UIScrollView *_scrollView;
    IBOutlet UIView *_containsTxtView;
    IBOutlet UITextView *_textView;
    
    NSArray *_infosArray;
    
    CGPoint startDragOfContentSet;
    CGPoint endDragOfContentSet;
    
    UIView * _containInfoView;
    
    int currentPageIndex;
}
@end

@implementation AboutUsViewController

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
        _textView.textContainerInset = UIEdgeInsetsMake(5, 0, 0, 20);
    }
    _containsTxtView.origin = CGPointMake(0 ,SCREEN_HEIGHT - _textViewHeight);
//     CGFloat top, left, bottom, right;
//     _containInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, 320, 68)];

    [self requestToGetAllAboutInfos];
}

/**
 *  更新界面显示
 */
-(void)updateSubviewShow
{
    NSLog(@"url =  %@",_infosArray[0]);
    
    [_scrollView removeAllSubviews];
    
    NSLog(@"_infosArray =  %@",_infosArray);
    
    [_infosArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UIScrollView * imageView =  [[UIScrollView alloc] initWithFrame:_scrollView.bounds];
        NSLog(@"_scrollView.bounds = %@",NSStringFromCGRect(_scrollView.bounds));

        imageView.origin = CGPointMake(0, _scrollView.height*idx);
        
        AboutUsModel * model = (AboutUsModel *)obj;
        //根据URL 请求图片
        NSLog(@"imageView.bounds = %@",NSStringFromCGRect(imageView.bounds));
        ITTImageView * image = [[ITTImageView alloc]initWithFrame:imageView.bounds];
        NSLog(@"image.currentMode = %d",image.contentMode);
        
        
        [image loadImage:model.imageUrl];
        [imageView addSubview:image];
        [_scrollView addSubview:imageView];
        
    }];
    
    if ([_infosArray count] == 1) {
        [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH,(SCREEN_HEIGHT-63)*[_infosArray count])];
    }else{
        [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH,(SCREEN_HEIGHT-64)*[_infosArray count])];
    }
    
    //delegate
    _scrollView.delegate = self;
    
    
}



//开始拖拽视图
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    
    startDragOfContentSet = scrollView.contentOffset;
    [self letImageViewToPreviewPlace];
}

//第一种方式
//完成拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
{
    endDragOfContentSet = scrollView.contentOffset;
    
    CGFloat value = endDragOfContentSet.y - startDragOfContentSet.y;
    
    int index = fabs(scrollView.contentOffset.y) / scrollView.frame.size.height;   //当前是第几个视图
    
    currentPageIndex = index;
    
    NSLog(@"value = %f",value);
    if (value > 50 && value <120) {
        
        [UIView animateWithDuration:0.4f animations:^{
        
            NSUInteger index = endDragOfContentSet.y/GET_VIEW_HEIGHT(_scrollView);
            UIView * view = [[_scrollView subviews] objectAtIndex:index];
            
            [self showFunctionView];
            CGRect  viewframe = CGRectMake(0,GET_VIEW_HEIGHT(view)*index-_ContainsViewHeight, 320, GET_VIEW_HEIGHT(view));
            
            NSLog(@"viewFrame = %@",NSStringFromCGRect(viewframe));
            
            AboutUsModel * model = _infosArray[index];
            _textView.text = model.content;
            NSLog(@"textView.frame = %@",NSStringFromCGRect(_textView.frame));
            view.frame = viewframe;
        }];
    }
}

/**
 *  还原scrollview 中得图片位置
 */
-(void)letImageViewToPreviewPlace
{
    [UIView animateWithDuration:0.4f animations:^{
        NSUInteger index = endDragOfContentSet.y/GET_VIEW_HEIGHT(_scrollView);
        UIView * view = [[_scrollView subviews] objectAtIndex:index];

        _containsTxtView.frame = CGRectMake(0, GET_VIEW_HEIGHT(self.view), 320, _ContainsViewHeight);
        [self hideFunctionView];

        CGRect  viewframe = CGRectMake(0, GET_VIEW_HEIGHT(view)*index, 320, GET_VIEW_HEIGHT(view));
        view.frame = viewframe;

    }];

}

-(void)showFunctionView
{

    [UIView animateWithDuration:0.2 animations:^{
        _containsTxtView.hidden = NO;
        _containsTxtView.frame = CGRectMake(0, GET_VIEW_HEIGHT(self.view)-_ContainsViewHeight, 320,_ContainsViewHeight);

        
        NSLog(@"_containsTxtView.frame = %@",NSStringFromCGRect(_containsTxtView.frame));
        [self.view bringSubviewToFront:_containsTxtView];
    }];

}

-(void)hideFunctionView
{
    [UIView animateWithDuration:0.2 animations:^{

        _containsTxtView.hidden = YES;

        _containsTxtView.frame = CGRectMake(0, SCREEN_HEIGHT, 320,_ContainsViewHeight);
    }];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToPreviewAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 *  获取关于我们的所有信息
 */
-(void)requestToGetAllAboutInfos
{
    if (!_infosArray) {
        _infosArray = [[NSArray alloc] init];
    }
    [RequestToGetAboutUsInfo requestWithParameters:Nil
                         withIndicatorView:self.view
                         withCancelSubject:@"RequestToGetAboutUsInfo"
                            onRequestStart:nil
                         onRequestFinished:^(ITTBaseDataRequest *request) {
                             if ([request isSuccess]) {
                                 _infosArray = request.handleredResult[@"keyModel"];
                                 [self updateSubviewShow];
                             }
                             
                         } onRequestCanceled:nil
                           onRequestFailed:^(ITTBaseDataRequest *request) {
                           }];

}

@end
