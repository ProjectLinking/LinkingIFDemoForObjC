/**
 * Copyright © 2015-2016 NTT DOCOMO, INC. All Rights Reserved.
 * ------説明----------
 * デバイスの情報を表示します
 */

#import "DeviceInfoViewController.h"
#import "SelectDevice.h"
#import <LinkingLibrary/LinkingLibrary.h>
#import "MBProgressHUD.h"

@interface DeviceInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation DeviceInfoCell
@end

@interface DeviceInfoViewController () <BLEConnecterDelegate, BLEDelegateModelDelegate>

@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (nonatomic)BLEConnecter *connecter;

@end

@implementation DeviceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // インスタンス生成
    self.connecter = [BLEConnecter sharedInstance];
    // デリゲートの登録
    [self.connecter addListener:self deviceUUID:nil];
    
    //デバイス情報を取得
    self.device = [SelectDevice sharedInstance].device;
    self.tableView.estimatedRowHeight = 20;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    // Do any additional setup after loading the view.
    
    // 2016/09/01 add start
    // デバイス情報の取得
    [self getDeviceInfo];
    // 2016/09/01 add end
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DeviceInfoCell*cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSString*title;
    NSString*content;
    
    //デバイス情報を表示
    switch (indexPath.row) {
        case 0:
            title = @"デバイス名:";
            content = self.device.name;
            break;
        case 1:
            title = @"デバイスID:";
            content = [NSString stringWithFormat:@"%d",self.device.deviceId];
            break;
        case 2:
            title = @"デバイス固有ID:";
            content = [NSString stringWithFormat:@"%d",self.device.deviceUid];
            break;
        case 3:
            title = @"UUID:";
            content = self.device.peripheral.identifier.UUIDString;
            break;
        case 4:
            title = @"接続状態（0:未接続、1接続）:";
            
            if([self.device.connectionStatus isEqualToString:DEV_STAT_CONNECTED]){
                content = @"1:接続";
            }else{
                content = @"0:未接続";
            }
            
            break;
        case 5:{
            title = @"機器能力:";
            
            NSMutableString *config = [[NSMutableString alloc]init];
            
            if (self.device.hasLED) {
                [config appendString:@"LED\n"];
            }
            if (self.device.hasGyroscope) {
                [config appendString:@"ジャイロセンサー\n"];
            }
            if (self.device.hasAccelerometer) {
                [config appendString:@"加速度センサー\n"];
            }
            if (self.device.hasOrientation) {
                [config appendString:@"方位センサー\n"];
            }
            if (self.device.hasBatteryPower) {
                [config appendString:@"バッテリーセンサー\n"];
            }
            if (self.device.hasTemperature) {
                [config appendString:@"温度センサー\n"];
            }
            if (self.device.hasHumidity) {
                [config appendString:@"湿度センサー\n"];
            }
            if (self.device.hasAtmosphericPressure) {
                [config appendString:@"気圧センサー\n"];
            }
            if (self.device.settingInformationDataVibration) {
                [config appendString:@"バイブレーション\n"];
            }
            if (self.device.settingInformationDataNotifySound) {
                [config appendString:@"通知音\n"];
            }
            if (self.device.hasPeripheralDeviceCapabilityReserved) {
                [config appendString:@"その他センサー\n"];
            }
            
            content = config;
            break;
        }
        case 6:
            title = @"イルミネーション情報:";
            content = [NSString stringWithFormat:@"%@",self.device.settingInformationDataLED];
            break;
        case 7:
            title = @"バイブレーション情報:";
            content = [NSString stringWithFormat:@"%@",self.device.settingInformationDataVibration];
            break;
        case 8:
            title = @"通知音情報:";
            content = [NSString stringWithFormat:@"%@",self.device.settingInformationDataNotifySound];
            break;
        case 9:
            title = @"RSSIPerMeterBeaconMode:";
            content = [NSString stringWithFormat:@"%f",self.device.kRSSIPerMeterBeaconMode];
            break;
        case 10:
            title = @"RSSIPerMeterPairingMode:";
            content = [NSString stringWithFormat:@"%f",self.device.kRSSIPerMeterPairingMode];
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.titleLabel.text = title;
    cell.subTitleLabel.numberOfLines = 0;
    
    if(content.length == 0 || content == nil || content == NULL || [content isEqualToString:@"(null)"]){
        content = @"--";
    }
    
    cell.subTitleLabel.text = content;
    
    return cell;
    
}

// 2016/09/01 add start
#pragma mark - Private method

// デバイス情報の取得
- (void)getDeviceInfo {
    
    CBPeripheral *peripheral;
    
    for(BLEDeviceSetting *device in [[BLEPeripheralDataManager sharedManager].deviceArray reverseObjectEnumerator]){
        //ペアリング中
        if ([device.connectionStatus isEqualToString:DEV_STAT_CONNECTED]) {
            if(device != nil && device.peripheral != nil){
                peripheral = device.peripheral;
            }
            if (!device.notifyDeviceInitial) {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [[BLERequestController sharedInstance] getDeviceInitialSetting:peripheral disconnect:NO];
            }
        }
    }
    
}

//デバイス情報を再取得する
- (IBAction)reloadButtonTap:(id)sender {
    [self getDeviceInfo];
}

#pragma mark - Delegate method

//接続
-(void)didConnectPeripheral:(CBPeripheral *)peripheral{
    [self updateDeviceArrayByPeripheral:peripheral];
}

//切断
-(void)didDisconnectPeripheral:(CBPeripheral *)peripheral{
    [self updateDeviceArrayByPeripheral:peripheral];
}

//デバイス情報取得完了
-(void)didDeviceInitialFinished:(CBPeripheral *)peripheral{
    [self updateDeviceArrayByPeripheral:peripheral];
}

// デバイス情報取得 失敗
- (void)getDeviceInformationRespError:(CBPeripheral *)peripheral result:(char)result {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
// 通知カテゴリ確認 失敗
- (void)confirmNotifyCategoryRespError:(CBPeripheral *)peripheral result:(char)result {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
// 設定情報取得 失敗
- (void)getSettingInformationRespError:(CBPeripheral *)peripheral result:(char)result {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
// 設定名称取得 失敗
- (void)getSettingNameRespError:(CBPeripheral *)peripheral result:(char)result {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)didFailToWrite:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"didFailToWrite error :%@",error);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

//デバイス情報の更新
-(void)updateDeviceArrayByPeripheral:(CBPeripheral *)peripheral{
    BLEDeviceSetting *foundDevice = [self.connecter getDeviceByPeripheral:peripheral];
    NSString *uuidStr = foundDevice.peripheral.identifier.UUIDString;
    int index = 0;
    for(BLEDeviceSetting *device in [BLEPeripheralDataManager sharedManager].deviceArray){
        if([device.peripheral.identifier.UUIDString isEqualToString:uuidStr]){
            [[BLEPeripheralDataManager sharedManager].deviceArray replaceObjectAtIndex:index withObject:foundDevice];
            break;
        }
        index++;
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.tableView reloadData];
}
// 2016/09/01 add end


@end
