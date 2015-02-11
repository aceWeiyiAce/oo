//
//  UserProtocolView.m
//  LingZhi
//
//  Created by boguoc on 14-5-7.
//
//

#import "UserProtocolView.h"
#import "UserProtocolCell.h"

@interface UserProtocolView ()<UITableViewDataSource,UITableViewDelegate>
{
    UIControl                       *_bgControl;
    float                           _scrollViewHeight;
    __weak IBOutlet UITableView     *_tableView;
    NSArray                         *_userProtocolArr;
}

@end

@implementation UserProtocolView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self creatCellContentString];
    
    _bgControl = [[UIControl alloc] init];
    _bgControl.backgroundColor = [UIColor blackColor];
    _bgControl.alpha = .23f;
    [_bgControl addTarget:self action:@selector(onBgControl) forControlEvents:UIControlEventTouchUpInside];

}

- (void)showUserProtocolViewWithSuperView:(UIView *)superView
{
    
    _bgControl.frame = superView.bounds;
    [superView addSubview:_bgControl];
    self.alpha = .1f;
    self.center = superView.center;
    [superView addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
        [self.layer addAnimation:[UserProtocolView scaleAnimation:YES] forKey:@"VIEWWILLAPPEAR"];
        
    } completion:^(BOOL finished){
        if (finished) {
        }
    }];
}

- (void)onBgControl
{
    [self hideUserProtocolView];
}

- (void)hideUserProtocolView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        [self.layer addAnimation:[UserProtocolView scaleAnimation:NO] forKey:@"VIEWWILLAPPEAR"];
        [_bgControl removeFromSuperview];
    } completion:^(BOOL finished){
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - Button Methods

- (IBAction)onCancelButton:(id)sender
{
    [self hideUserProtocolView];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserProtocolCell *cell = (UserProtocolCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return [cell getUserProtocolCellHeight];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 12;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *identifier = @"UserProtocolCell";
    
//    UserProtocolCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (!cell) {
        UserProtocolCell *cell = [UserProtocolCell loadFromXib];
//    }
    cell.index = indexPath.row;
    [cell layoutUserProtocolCellWithString:_userProtocolArr[indexPath.row]];
    
    return cell;
}

#pragma mark - Animation
+ (CAKeyframeAnimation*)scaleAnimation:(BOOL)show{
    CAKeyframeAnimation *scaleAnimation = nil;
    scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.delegate = self;
    scaleAnimation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    if (show){
        scaleAnimation.duration = 0.5;
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    }else{
        scaleAnimation.duration = 0.3;
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6, 0.6, 1.0)]];
    }
    scaleAnimation.values = values;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimation.removedOnCompletion = TRUE;
    return scaleAnimation;
    
}

- (void)creatCellContentString
{
    _userProtocolArr = [NSArray arrayWithObjects:[NSString stringWithFormat:@"本网站上的各项电子服务的所有权和运作权归ONLY所有，禁止转载或以本网站之相关内容为基础进行任何改编、汇编或编纂等行为。\n\n本协议内容包括您现在所看到的协议正文及所有ONLY官网已经发布的或将来可能发布的各类规则、规定。所有规则、规定将成为本协议不可分割之组成部分，与本协议正文具有同等法律效力，以资约束双方。除另行明确声明外，任何ONLY官网及其关联公司提供的服务（以下称为ONLY网站服务）均受本协议之约束。\n\n我们在此特别声明，ONLY有权根据相关需要不时地制订、修改、删除本协议正文及/或各类规则、规定，并以在本网站公示的方式进行公告，不再单独的通知您。变更后的协议正文和规则、规定一经在本网站公布后，立即自动生效，即时成为约束双方的有效法律文件。如您不同意相关变更，应当立即停止使用ONLY网站服务。如果您继续使用ONLY网站服务的，即表示您无条件接受经修订的协议正文和规则、规定。\n\n如果您对本网站用户服务协议有任何问题，您可以登录我们的网站或通过我们的网络联系方式（400-862-8888）联系我们，我们会竭诚为您服务。"],[NSString stringWithFormat:@"本网站运用自己的操作系统通过国际互联网络为用户提供网络服务。同时，您（即指“用户”）必须：\nA、自行配备上网的所需相关设备，包括个人电脑、调制解调器或其他必备上网装置；\nB、自行负担因个人上网所产生的与此服务有关的包括但不限于电话费用、网络费用等；\nC、您亦须具有享受本网站服务、下单购物等相应的权利能力和行为能力，须能够独立承担相应的法律责任；\nD、如果您在18周岁以下，您只能在父母或监护人的监护参与下才能使用本网站提供之相应服务，且您做出的相关行为将被视为已被监护人进行追认的有效法律行为。\n\n基于本网站所提供的网络服务的重要性，您（即指“用户”）应同意如下内容：\nA、提供详尽、准确的个人资料；\nB、不断更新注册资料，符合及时、详尽、准确的要求。\n\n如果您提供的注册资料或相关信息不合法、不真实、不准确、不详尽的，则您须自行承担因此引起的相应责任及后果，并且ONLY保留终止您使用ONLY网站服务的各项权利，并保留进一步通过司法途径追究您相应责任的权利。\n\n本网站对您的电子邮件、手机号、即时聊天账号信息等隐私资料进行保护，承诺不会在未获得您许可的情况下擅自将您的个人资料信息出租或出售给任何第三方，但以下情况除外：\nA、用户同意让第三方共享该等资料的；\nB、用户同意公开其个人资料的；\nC、本网站发现用户违反了本网站用户服务协议或本网站其它使用\nD、法律、法规规定的其他相关情形。"],@"我们在本网站上提供商品的范围为服装、鞋包、配饰、化妆品或者其他被允许经营的ONLY品牌商品。",@"本网站上的商品款式、商品价格、剩余数量以及是否有货等商品信息将随时都有可能发生变动，本网站将不作任何特别通知。由于网站上商品信息的数量极其庞大，虽然本网站以及ONLY会竭尽全力保证您所浏览的商品信息之准确性，但由于众所周知的互联网技术因素等客观原因的存在，本网站网页显示的信息可能会有一定的滞后性、误差或差错，对此情形您知悉并理解。本网站将不对由此可能导致的任何风险承担任何责任。",[NSString stringWithFormat:@"在您（即指“用户”）即将提交相关购物订单时，请您务必仔细确认所购买商品的名称、价格、数量、型号、规格、尺寸、联系地址、电话、收货人等信息。收货人与用户本人不一致的，收货人的行为和意思表示即视为用户的行为和意思表示，用户应对收货人的行为及意思表示的法律后果承担连带责任，无论您是否告知我们该等不一致情况的存在。\n\n本网站用户服务协议中的信息和本网站上的详情、规则、规定均不构成买卖合同中的要约，而仅仅是要约邀请。在您的订单被我们接受之前，您与我们之间并不存在关于任何商品的任何合同，您无权向我们主张任何法律权利。\n\n本网站购物平台生成的订单信息是计算机信息系统根据您填写的内容自动生成的数据，仅是您向我们发出的合同要约；我们收到您的订单信息后，只有在我们将您在订单中订购的商品从仓库实际直接向您发出时（以商品出库为标志），方视为您与我们之间就实际直接向您发出的该部分商品建立了合同关系；如果您在一份订单里订购了多种商品并且我们只给您发出了部分商品时，您与我们之间仅就实际直接向您发出的该部分商品建立了合同关系；只有在我们实际直接向您发出了订单中订购的其他商品时，您和我们之间就订单中该其他已实际直接向您发出的商品才成立合同关系。您可以随时登陆您在本网站注册的账户，对您的订单状态进行相应查询。\n\n由于市场变化及各种以合理商业努力难以控制的因素存在的情况下，本网站无法保证您提交的订单信息中希望购买的所有商品均都会有货；如您拟购买的商品，发生缺货，您有权取消该等订单；我们对于该等缺货状态虽然会竭尽全力进行改善，但不会对此承担任何责任。"],[NSString stringWithFormat:@"本网站将会把您在订单中所列明的有关商品送达到您所指定的送货地址。所有在本网站上列出的送货时间均为参考时间，参考时间的计算是根据库存状况、正常的处理过程和送货时间、送货地点的基础上估计得出的，我们将不对该等参考时间承担任何责任。\n\n如果因为下述情况导致订单延迟或无法配送等问题之发生，我们不予承担任何延迟配送、合同违约的责任：\n（1）用户提供的信息错误、地址不详细等原因导致无法配送或延迟配送的；\n（2）货物送达后无人签收或相关人员拒绝签收，导致无法配送或延迟配送的；\n（3）情势变更因素导致无法配送或延迟配送的；\n（4）不可抗力因素导致无法配送或延迟配送的，例如：自然灾害、交通戒严、突发战争等；\n（5）法律、法规允许的其他情形。"],@"如果您在收到商品后15天之内对商品不满意，ONLY在不影响产品二次销售的前提下可以为您安排退货。退货的具体标准和政策请参见本网站不时更新的“退换货政策”。“退换货政策”构成本用户服务协议的一部分。",[NSString stringWithFormat:@"我们将尊重用户个人隐私作为本网站的一项最为基本的政策。所以，作为对以上第二条您的相关注册资料分析的补充，本网站一定不会在未经您的合法授权时公开、编辑或透露您的相关注册资料信息及保存在本网站中的非公开内容。\n\nONLY将在本网站上公布并不时修订、删改关于您的隐私安全的有关政策，隐私安全政策（如有）将构成本协议的有效组成部分。"],[NSString stringWithFormat:@"除非本网站另行公布其他的书面声明，本网站、本网站提供之相关服务及其所包含的或以其它任何方式通过本网站提供或展现给您的全部信息、内容、材料、产品（包括但不限于任何软件、硬件、实物）和服务，均是在“按现有状态”和“按实际现有”的基础上提供的。\n\n除非本网站另行公布其他的书面声明，ONLY将不对本网站的运营及其包含在本网站上的任何信息、内容、材料、产品（包括软件、硬件、实物、从本站发出的电子信件、信息）或服务作任何形式的、明示或默示的声明或担保（根据中华人民共和国法律另有规定的以外）。\n\n将在法律允许的最大限度内拒绝做出任何种类的所有其他任何形式之担保。\n\n不论在何种情况下，本网站均不对由于电力、网络、通讯或其他系统的故障（包括但不限于黑客攻击、通过互联网传播的病毒或其他有害成分引致的故障、失灵）、暴乱、起义、骚乱、火灾、洪水、风暴、爆炸、战争、政府行为等不可抗力，以及非ONLY可以控制的任何情况，国际、国内法院的命令或第三方的不作为而造成的不能服务或延迟服务承担责任。但是我们会竭尽全力地在合理范围内协助您处理相关善后事宜，并努力使用户免受经济损失或使相关经济损失尽量降低。"],[NSString stringWithFormat:@"本网站所展示的任何资料信息（包括但不限于任何文字、图表、标志、按钮图标、图像视频资料、声音文件片段、广告宣传图样等），均是ONLY或其关联方或其指定服务方的专有财产。所有这些内容均受到包括但不限于版权、商标权、专利权、著作权和其它财产所有权相关之法律法规的保护。所以，您（即指“用户”）只能在本网站之有效授权之下方能使用这些内容。\n\n您不得擅自复制、再造本网站上展示之任何内容、或创造与该等内容有关的任何派生产品，无论该等复制、再造内容或有关派生产品是否用于商业用途。一经发现，本网站即有权追究您的侵权责任。"],[NSString stringWithFormat:@"您通过本网站订购相关商品而产生之合同，如发生任何争议或纠纷，均应当无条件适用中华人民共和国的有关法律法规。\n\n因上述合同引起的或与上述合同相关的任何争议或纠纷均应当提交至ONLY所在地有管辖权的中国人民法院诉讼解决。\n\n如果您（即指“用户”）系作为消费者而与我们达成相关合同的，本条款将不会影响您作为消费者所应享有的任何法定权利。"],[NSString stringWithFormat:@"您点击本协议上方的“同意该协议，并提交”按钮，即视为您已经充分阅读本协议并理解协议内所述之任何内容，且将被视为您系在完全自愿之情况下接受本协议，本协议及本协议内相关内容将不构成任何格式条款、格式合同。\n\n点击之前请您再次确认已知悉并完全理解本协议的全部内容。"],nil];
}


@end
