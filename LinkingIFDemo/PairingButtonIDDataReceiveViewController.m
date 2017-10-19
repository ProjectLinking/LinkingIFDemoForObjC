/**
 * Copyright © 2015-2016 NTT DOCOMO, INC. All Rights Reserved.
 * ------説明----------
 * デバイスのボタンタップを検知し、表示します。
 */

#import "PairingButtonIDDataReceiveViewController.h"
#import "SelectDevice.h"

@interface PairingButtonIDDataReceiveViewController ()<BLEConnecterDelegate,BLEDelegateModelDelegate>{
    
}

@property (nonatomic, strong)NSMutableArray *receiveMessageArray;
@property (nonatomic)BLEDeviceSetting *device;
@property (nonatomic)BLEConnecter *connector;
@property (nonatomic)NSMutableArray *timeStamps;

@end

@implementation PairingButtonIDDataReceiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.device = [SelectDevice sharedInstance].device;
    self.connector = [BLEConnecter sharedInstance];
    
    //デリゲートを登録
    [self.connector addListener:self deviceUUID:self.device.peripheral.identifier.UUIDString];

    self.timeStamps = [[NSMutableArray alloc]init];
    self.receiveMessageArray = [[NSMutableArray alloc] init];
    self.tableView.estimatedRowHeight = 20.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

//デバイスからの通知
- (void)deviceButtonPushed:(CBPeripheral *)peripheral buttonID:(char)buttonID{
    // 現在日時を取得
    NSDate *now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"hh:mm:ss:sss"];
    NSString *strNow = [outputFormatter stringFromDate:now];
    [self.timeStamps addObject:strNow];

    NSString *stringButton = [NSString stringWithFormat:@"%@",[NSNumber numberWithChar:buttonID]];
    [self.receiveMessageArray addObject:stringButton];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.receiveMessageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
    UILabel *titleLabel = [cell viewWithTag:1];
    UITextView *textBox = [cell viewWithTag:2];
    textBox.editable = NO;
    
    titleLabel.text = @"受信";
    NSString *strNow;
    NSString *buttonID;

    strNow = [self.timeStamps objectAtIndex:indexPath.row];
    buttonID =  [self.receiveMessageArray objectAtIndex:indexPath.row];
    textBox.text = [NSString stringWithFormat:@"受信日時:%@\nボタンID:%@",strNow,buttonID];

    return cell;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    //デリゲートを削除
    [self.connector removeListener:self deviceUUID:self.device.peripheral.identifier.UUIDString];
    self.timeStamps = nil;
    self.receiveMessageArray = nil;
}

@end
