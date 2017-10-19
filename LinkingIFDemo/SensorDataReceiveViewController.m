/**
 * Copyright © 2015-2016 NTT DOCOMO, INC. All Rights Reserved.
 * ------説明----------
 * センサーの通知を表示します。
 */

#import "SensorDataReceiveViewController.h"
#import "SelectDevice.h"

@interface SensorDataReceiveViewController ()<BLEConnecterDelegate,BLEDelegateModelDelegate>{
}

@property (nonatomic)NSMutableArray *receiveMessageArray;
@property (nonatomic)BLEDeviceSetting *device;
@property (nonatomic)BLEConnecter *connector;
@property (nonatomic)BOOL canAddMessage;
@property (nonatomic)BOOL modeInterval;
@property (nonatomic) NSMutableArray *timeStamps;

@end

@implementation SensorDataReceiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.device = [SelectDevice sharedInstance].device;
    self.connector = [BLEConnecter sharedInstance];
    //デリゲート登録
    [self.connector addListener:self deviceUUID:self.device.peripheral.identifier.UUIDString];
    
    //初期化
    self.modeInterval = NO;
    self.timeStamps = [[NSMutableArray alloc]init];
    self.receiveMessageArray = [[NSMutableArray alloc] init];
    
    self.tableView.estimatedRowHeight = 120.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

//停止ボタンタップ
- (IBAction)stopButtonClicked:(id)sender {
    [self sendStopSensorMessage];
}

//センサーを停止する
-(void)sendStopSensorMessage{
    
    //メッセージ送信
    [[BLERequestController sharedInstance] setNotifySensorInfoMessage:self.device.peripheral sensorType:self.sensorType status:0x00 disconnect:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BLE delegate

//ジャイロスコープの通知
- (void)gyroscopeDidUpDateWithIntervalDelegate:(CBPeripheral *)peripheral sensor:(BLESensorGyroscope *)sensor {
    
    
    self.sensorType = 0x00;
    self.modeInterval = YES;
    // 現在日時を取得
    NSDate *now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"hh:mm:ss:sss"];
    NSString *strNow = [outputFormatter stringFromDate:now];
    [self.timeStamps addObject:strNow];
    [self.receiveMessageArray addObject:sensor];
    [self.tableView reloadData];
}

//加速センサーの通知
- (void)accelerometerDidUpDateWithIntervalDelegate:(CBPeripheral *)peripheral sensor:(BLESensorAccelerometer *)sensor{
    
    // 現在日時を取得
    NSDate *now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"hh:mm:ss:sss"];
    NSString *strNow = [outputFormatter stringFromDate:now];
    [self.timeStamps addObject:strNow];
    self.sensorType = 0x01;
    self.modeInterval = YES;
    [self.receiveMessageArray addObject:sensor];
    [self.tableView reloadData];
    
}

//方位センサーの通知
- (void)orientationDidUpDateWithIntervalDelegate:(CBPeripheral *)peripheral sensor:(BLESensorOrientation *)sensor{
    
    // 現在日時を取得
    NSDate *now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"hh:mm:ss:sss"];
    NSString *strNow = [outputFormatter stringFromDate:now];
    [self.timeStamps addObject:strNow];
    self.sensorType = 0x02;
    self.modeInterval = YES;
    [self.receiveMessageArray addObject:sensor];
    [self.tableView reloadData];
    
}

//電池残量センサーの通知
- (void)batteryPowerDidUpDateWithIntervalDelegate:(CBPeripheral *)peripheral sensor:(BLESensorBatteryPower *)sensor{
    
    // 現在日時を取得
    NSDate *now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"hh:mm:ss:sss"];
    NSString *strNow = [outputFormatter stringFromDate:now];
    [self.timeStamps addObject:strNow];
    self.sensorType = 0x03;
    self.modeInterval = YES;
    [self.receiveMessageArray addObject:sensor];
    [self.tableView reloadData];
    
}

//温度センサーの通知
- (void)temperatureDidUpDateWithIntervalDelegate:(CBPeripheral *)peripheral sensor:(BLESensorTemperature *)sensor{
    
    // 現在日時を取得
    NSDate *now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"hh:mm:ss:sss"];
    NSString *strNow = [outputFormatter stringFromDate:now];
    [self.timeStamps addObject:strNow];
    self.sensorType = 0x04;
    self.modeInterval = YES;
    [self.receiveMessageArray addObject:sensor];
    [self.tableView reloadData];
    
}

//湿度センサーの通知
- (void)humidityDidUpDateWithIntervalDelegate:(CBPeripheral *)peripheral sensor:(BLESensorHumidity *)sensor{
    
    // 現在日時を取得
    NSDate *now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"hh:mm:ss:sss"];
    NSString *strNow = [outputFormatter stringFromDate:now];
    [self.timeStamps addObject:strNow];
    self.sensorType = 0x05;
    self.modeInterval = YES;
    [self.receiveMessageArray addObject:sensor];
    [self.tableView reloadData];
    
}

//気圧センサーの通知
- (void)atmosphericPressureDidUpDateWithIntervalDelegate:(CBPeripheral *)peripheral sensor:(BLESensorAtmosphericPressure *)sensor{
    
    // 現在日時を取得
    NSDate *now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"hh:mm:ss:sss"];
    NSString *strNow = [outputFormatter stringFromDate:now];
    [self.timeStamps addObject:strNow];
    self.sensorType = 0x06;
    self.modeInterval = YES;
    [self.receiveMessageArray addObject:sensor];
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
    
    BLESensorGyroscope *gyroscope = [[BLESensorGyroscope alloc]init];
    BLESensorAccelerometer *accelerometer = [[BLESensorAccelerometer alloc]init];
    BLESensorOrientation *orientation = [[BLESensorOrientation alloc]init];
    BLESensorBatteryPower *batteryPower = [[BLESensorBatteryPower alloc]init];
    BLESensorTemperature *temperature = [[BLESensorTemperature alloc]init];
    BLESensorHumidity *humidity = [[BLESensorHumidity alloc]init];
    BLESensorAtmosphericPressure *atmosphericPressure = [[BLESensorAtmosphericPressure alloc]init];
    
    
    strNow = [self.timeStamps objectAtIndex:indexPath.row];
    
    if([[self.receiveMessageArray objectAtIndex:indexPath.row] isKindOfClass:[gyroscope class]]){
        
        gyroscope = [self.receiveMessageArray objectAtIndex:indexPath.row];
        textBox.text = [NSString stringWithFormat:@"ジャイロスコープ\nxValue:%f\nyValue:%f\nzValue:%f\noriginalData%@\n取得時間:%@",gyroscope.xValue,gyroscope.yValue,gyroscope.zValue,gyroscope.originalData,strNow];
        
    }
    else if([[self.receiveMessageArray objectAtIndex:indexPath.row] isKindOfClass:[accelerometer class]]){
        accelerometer = [self.receiveMessageArray objectAtIndex:indexPath.row];
        textBox.text = [NSString stringWithFormat:@"加速センサー\nxValue:%f\nyValue:%f\nzValue:%f\noriginalData%@\n取得時間:%@",accelerometer.xValue,accelerometer.yValue,accelerometer.zValue,accelerometer.originalData,strNow];
        
    }
    else if([[self.receiveMessageArray objectAtIndex:indexPath.row] isKindOfClass:[orientation class]]){
        orientation = [self.receiveMessageArray objectAtIndex:indexPath.row];
        textBox.text = [NSString stringWithFormat:@"方位センサー\nxValue:%f\nyValue:%f\nzValue:%f\noriginalData%@\n取得時間:%@",orientation.xValue,orientation.yValue,orientation.zValue,orientation.originalData,strNow];
        
    }
    else if([[self.receiveMessageArray objectAtIndex:indexPath.row] isKindOfClass:[batteryPower class]]){
        batteryPower = [self.receiveMessageArray objectAtIndex:indexPath.row];
        textBox.text = [NSString stringWithFormat:@"電池残量\nxValue:%f\nyValue:%f\nzValue:%f\noriginalData%@\n取得時間:%@",batteryPower.xValue,batteryPower.yValue,batteryPower.zValue,batteryPower.originalData,strNow];
        
    }
    else if([[self.receiveMessageArray objectAtIndex:indexPath.row] isKindOfClass:[temperature class]]){
        temperature = [self.receiveMessageArray objectAtIndex:indexPath.row];
        textBox.text = [NSString stringWithFormat:@"温度センサー\nxValue:%f\nyValue:%f\nzValue:%f\noriginalData%@\n取得時間:%@",temperature.xValue,temperature.yValue,temperature.zValue,temperature.originalData,strNow];
        
    }
    else if([[self.receiveMessageArray objectAtIndex:indexPath.row] isKindOfClass:[humidity class]]){
        humidity = [self.receiveMessageArray objectAtIndex:indexPath.row];
        textBox.text = [NSString stringWithFormat:@"湿度センサー\nxValue:%f\nyValue:%f\nzValue:%f\noriginalData%@\n取得時間:%@",humidity.xValue,humidity.yValue,humidity.zValue,humidity.originalData,strNow];
        
    }
    else if([[self.receiveMessageArray objectAtIndex:indexPath.row] isKindOfClass:[atmosphericPressure class]]){
        atmosphericPressure = [self.receiveMessageArray objectAtIndex:indexPath.row];
        textBox.text = [NSString stringWithFormat:@"気圧センサー\nxValue:%f\nyValue:%f\nzValue:%f\noriginalData%@\n取得時間:%@",atmosphericPressure.xValue,atmosphericPressure.yValue,atmosphericPressure.zValue,atmosphericPressure.originalData,strNow];
        
    }
    
    return cell;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    //センサーを停止する
    [self sendStopSensorMessage];
    //デリゲートを削除する
    [self.connector removeListener:self deviceUUID:self.device.peripheral.identifier.UUIDString];
    self.modeInterval = NO;
    self.timeStamps = nil;
    self.receiveMessageArray = nil;
    self.timeStamps = nil;
}

/*
 繋がらない、メッセージが送信できていない場合は下記デリゲートを確認
 ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓
 */

-(void)setNotifySensorInfoRespError:(CBPeripheral *)peripheral result:(char)result {
    NSLog(@"失敗:%hhu",result);
}

/*設定した時間が経過し、センサーの情報通知が完了した通知
 ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓
 */
- (void)gyroscopeObservationEnded:(CBPeripheral *)peripheral {
    NSLog(@"センサー観測完了");
}
-(void)accelerometerObservationEnded:(CBPeripheral *)peripheral {
    NSLog(@"センサー観測完了");
}
-(void)orientationObservationEnded:(CBPeripheral *)peripheral {
    NSLog(@"センサー観測完了");
}
-(void)batteryPowerObservationEnded:(CBPeripheral *)peripheral {
    NSLog(@"センサー観測完了");
}
-(void)temperatureObservationEnded:(CBPeripheral *)peripheral {
    NSLog(@"センサー観測完了");
}
-(void)humidityObservationEnded:(CBPeripheral *)peripheral {
    NSLog(@"センサー観測完了");
}
-(void)atmosphericPressureObservationEnded:(CBPeripheral *)peripheral {
    NSLog(@"センサー観測完了");
}

@end
