/**
 * Copyright © 2015-2016 NTT DOCOMO, INC. All Rights Reserved.
 * ------説明----------
 * センサー情報の通知を設定します。
 */

#import "BeaconSensorDataReceiveViewController.h"
#import "SelectDevice.h"

@interface BeaconSensorDataReceiveViewController ()<BLEConnecterDelegate,SelectDeviceDelegate,BLEDelegateModelDelegate>{
    
}

@property (nonatomic)NSMutableArray *receiveMessageArray;
@property (nonatomic)BLEDeviceSetting *device;
@property (nonatomic)BLEConnecter *connector;
@property (nonatomic)NSMutableArray *timeStamps;
@property (nonatomic)NSMutableArray *sensorData;
@property (nonatomic)NSInteger sensorDataCount;

@end

@implementation BeaconSensorDataReceiveViewController

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
    self.sensorData = [[NSMutableArray alloc] init];
    self.sensorDataCount = 0;
    
    if (self.receiveMessageArray.count > 0) {
        
        for (NSDictionary *dic in self.receiveMessageArray) {
            if([[dic objectForKey:@"serviceID"]intValue] == [self.serviceID intValue]){
                self.sensorDataCount ++;
                NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
                [outputFormatter setDateFormat:@"hh:mm:ss:sss"];
                NSString *strNow = [outputFormatter stringFromDate:[dic objectForKey:@"date"]];
                [self.timeStamps addObject:strNow];
                [self.sensorData addObject:[dic objectForKey:self.sensorType]];
            }
        }
    }
}

//アドバタイズ受信時によばれる
-(void)advertisementReceive {
    
    self.receiveMessageArray = [SelectDevice sharedInstance].advertisementArray;
    self.timeStamps = [[NSMutableArray alloc] init];
    self.sensorData = [[NSMutableArray alloc] init];
    self.sensorDataCount = 0;
    for (NSDictionary *dic in self.receiveMessageArray) {
        if([[dic objectForKey:@"serviceID"]intValue] == [self.serviceID intValue]){
            self.sensorDataCount++;
            NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
            [outputFormatter setDateFormat:@"hh:mm:ss:sss"];
            NSString *strNow = [outputFormatter stringFromDate:[dic objectForKey:@"date"]];
            [self.timeStamps addObject:strNow];
            [self.sensorData addObject:[dic objectForKey:self.sensorType]];
        }
    }
    [self.tableView reloadData];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sensorDataCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
    UILabel *titleLabel = [cell viewWithTag:1];
    UITextView *textBox = [cell viewWithTag:2];
    textBox.editable = NO;
    
    titleLabel.text = @"受信";
    NSString *strNow;
    NSString *sensorData;
    
    strNow = [self.timeStamps objectAtIndex:indexPath.row];
    sensorData =  [self.sensorData objectAtIndex:indexPath.row];
    textBox.text = [NSString stringWithFormat:@"受信日時:%@\nデバイスID:%d\n%@:%@",strNow,self.device.deviceId,self.sensorType,sensorData];
    
    return cell;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    //デリゲートの削除
    [self.connector removeListener:self deviceUUID:self.device.peripheral.identifier.UUIDString];
    self.timeStamps = nil;
    self.receiveMessageArray = nil;
    
}

//リストを削除する
- (IBAction)clearButtonTap:(id)sender {
    [[SelectDevice sharedInstance]deleteAdvertise];
    self.receiveMessageArray = nil;
    self.sensorDataCount = 0;
    [self.tableView reloadData];
}

@end
