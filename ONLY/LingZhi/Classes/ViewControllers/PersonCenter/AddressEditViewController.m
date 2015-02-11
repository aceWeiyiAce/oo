//
//  AddressEditViewController.m
//  LingZhi
//
//  Created by boguoc on 14-5-16.
//
//

#import "AddressEditViewController.h"
#import "AddressViewController.h"
#import "AddressCell.h"
#import "AddressModel.h"

@interface AddressEditViewController ()<UITableViewDataSource,UITableViewDelegate,AddressViewControllerDelegate>
{
    __weak IBOutlet UIButton        *_editButton;
    __weak IBOutlet UITableView     *_tableView;
    __weak IBOutlet UIView          *_listView;
    __weak IBOutlet UIView          *_newView;
    
    NSMutableArray                  *_addressArray;
}
@end

@implementation AddressEditViewController

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
    [self getAddressListRequest];
}

#pragma mark - Button methods

- (IBAction)onBackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onEditButton:(id)sender
{
    AddressViewController *address = [[AddressViewController alloc]init];
    address.addresses = _addressArray;
    address.isAddressEdit = YES;
    address.delegate = self;
    [self.navigationController pushViewController:address animated:YES];
}

- (IBAction)onAddAddressButton:(id)sender
{
    AddressViewController *address = [[AddressViewController alloc]init];
    address.addresses = _addressArray;
    address.isAddAddress = YES;
    address.isAddressEdit = YES;
    address.delegate = self;
    address.addressClass = self;
    [self.navigationController pushViewController:address animated:NO];
}

#pragma mark - Reqeust methods

- (void)getAddressListRequest
{
    if (!_addressArray) {
        _addressArray = [[NSMutableArray alloc]init];
    }
    
    NSDictionary *paramter = [NSDictionary dictionaryWithObjectsAndKeys:DATA_ENV.userInfo.userId,@"loginName", nil];
    [getAddressListRequest requestWithParameters:paramter
                               withIndicatorView:self.view
                               withCancelSubject:@"getAddressListRequest"
                                  onRequestStart:nil
                               onRequestFinished:^(ITTBaseDataRequest *request) {
                                   if ([request isSuccess]) {
                                       [_addressArray addObjectsFromArray:request.handleredResult[@"keyModel"]];
                                       [self dataCacheDefaultAddress]; //设置默认地址
                                   }
                                   [self layoutAddressEditViewController];
                               }
                               onRequestCanceled:nil
                                 onRequestFailed:^(ITTBaseDataRequest *request) {
                                     [self layoutAddressEditViewController];
                                 }];
}

- (void)dataCacheDefaultAddress     //设置默认地址
{
    for (AddressModel *model in _addressArray) {
        if ([model.isDefault isEqualToString:@"1"]) {
            AddressModel *address = DATA_ENV.address;
            address = model;
            DATA_ENV.address = address;
        }
    }
}

- (void)layoutAddressEditViewController
{
    if (_addressArray.count<1) {
        _listView.hidden = YES;
        _newView.hidden = NO;
        _editButton.hidden = YES;
    } else {
        _listView.hidden = NO;
        _newView.hidden = YES;
        _editButton.hidden = NO;
        [_tableView reloadData];
    }
    
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _addressArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"AddressCell";
    
    AddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!addressCell) {
        addressCell = [AddressCell loadFromXib];
    }
    addressCell.index = indexPath.row;
    [addressCell layoutAddressCellWithModel:[_addressArray objectAtIndex:indexPath.row]];
    
    return addressCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChooseAddress:)]) {
        [self.delegate didChooseAddress:_addressArray[indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - AddressViewControllerDelegate

- (void)didFinishAddressEditReturnAddress:(NSArray *)address
{
    [_addressArray removeAllObjects];
    [_addressArray addObjectsFromArray:address];
    [_tableView reloadData];
    [self layoutAddressEditViewController];
}

- (void)didBackAddressEditReturnAddress:(NSArray *)address
{
    [_addressArray removeAllObjects];
    [_addressArray addObjectsFromArray:address];
    [_tableView reloadData];
}

@end
