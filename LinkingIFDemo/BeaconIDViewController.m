/**
 * Copyright © 2015-2016 NTT DOCOMO, INC. All Rights Reserved.
 * ------説明----------
 * 受信したビーコンIDとRSSIの値を表示します。
 */

#import "BeaconIDViewController.h"
#import "SelectDevice.h"

@interface BeaconIDViewController ()<BLEConnecterDelegate,SelectDeviceDelegate,BLEDelegateModelDelegate>{
    
}

@property (nonatomic, strong)NSMutableArray *receiveMessageArray;
@property (nonatomic)BLEDeviceSetting *device;
@property (nonatomic)BLEConnecter *connector;
@property (nonatomic)NSMutableArray *timeStamps;
@property (nonatomic)NSMutableArray *rssi;

@end

@implementation BeaconIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.device = [SelectDevice sharedInstance].device;
    self.connector = [BLEConnecter sharedInstance];
    [SelectDevice sharedInstance].delegate = self;
    
    //デリゲートを登録
    [self.connector addListener:self deviceUUID:self.device.peripheral.identifier.UUIDString];
    
    //初期化
    self.timeStamps = [[NSMutableArray alloc]init];
    self.receiveMessageArray = [[NSMutableArray alloc] init];
    
    self.tableView.estimatedRowHeight = 20.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    //受信したアドバタイズデータがあればセットする
    self.receiveMessageArray = [SelectDevice sharedInstance].advertisementArray;
    self.timeStamps = [[NSMutableArray alloc] init];
    self.rssi = [[NSMutableArray alloc] init];
    
    if (self.receiveMessageArray.count > 0) {

        for (NSDictionary *dic in self.receiveMessageArray) {
            NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
            [outputFormatter setDateFormat:@"hh:mm:ss:sss"];
            NSString *strNow = [outputFormatter stringFromDate:[dic objectForKey:@"date"]];
            [self.timeStamps addObject:strNow];
            [self.rssi addObject:[dic objectForKey:@"rssi"]];
        }
        
    }
}

//アドバタイズ受信時によばれる
-(void)advertisementReceive {

    self.receiveMessageArray = [SelectDevice sharedInstance].advertisementArray;
    self.timeStamps = [[NSMutableArray alloc] init];
    self.rssi = [[NSMutableArray alloc] init];
    
    //表示データを更新
    for (NSDictionary *dic in self.receiveMessageArray) {
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"hh:mm:ss:sss"];
        NSString *strNow = [outputFormatter stringFromDate:[dic objectForKey:@"date"]];
        [self.timeStamps addObject:strNow];
        [self.rssi addObject:[dic objectForKey:@"rssi"]];
    }
    
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
    NSString *strRssi;
    
    strNow = [self.timeStamps objectAtIndex:indexPath.row];
    strRssi =  [self.rssi objectAtIndex:indexPath.row];
    textBox.text = [NSString stringWithFormat:@"受信日時:%@\nデバイスID:%d\nRSSI:%@",strNow,self.device.deviceId,strRssi];
    
    return cell;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    //デリゲートを削除
    [self.connector removeListener:self deviceUUID:self.device.peripheral.identifier.UUIDString];
    self.timeStamps = nil;
    self.receiveMessageArray = nil;
    
}

//リストを削除する
- (IBAction)clearButtonTap:(id)sender {
    
    [[SelectDevice sharedInstance]deleteAdvertise];
    self.receiveMessageArray = nil;
    [self.tableView reloadData];
}

@end
