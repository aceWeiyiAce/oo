//
//  SearchViewController.m
//  LingZhi
//
//  Created by pk on 14-3-17.
//
//

#import "SearchViewController.h"
#import "ITTDataCacheManager.h"

@interface SearchViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UITextField     *_textField;
    NSMutableArray                  *_seachKeys;
}
@end

@implementation SearchViewController

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
    
    if (!_seachKeys) {
        _seachKeys = [[NSMutableArray alloc]init];
    }
    if ([[ITTDataCacheManager sharedManager] hasObjectInCacheByKey:@"history"]) {
        [_seachKeys addObjectsFromArray:[[ITTDataCacheManager sharedManager] getCachedObjectByKey:@"history"]];
    }

}

#pragma mark - Button Methods

- (IBAction)onBackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClearHistoryButton:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"搜索历史已清空" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)onSeachButton:(id)sender
{
    if (_textField.text.length > 0) {
        [_seachKeys addObject:_textField.text];
        [[ITTDataCacheManager sharedManager] addObjectToMemory:_seachKeys forKey:@"history"];
    }
}

- (IBAction)onHistoryButton:(id)sender
{
    
}

- (IBAction)onHotSeachButton:(id)sender
{
    
}


#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
