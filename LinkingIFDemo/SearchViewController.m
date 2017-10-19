/**
 * Copyright © 2015-2016 NTT DOCOMO, INC. All Rights Reserved.
 *
 * ------注意----------
 * 1.Linkingデバイスとの接続後、切断と接続が繰り返される場合はLinkingデバイスの電源を落とし
 *   再度起動させてください.(電池抜き差し)
 *
 * 2.Linkingデバイスとの接続後、メッセージ送受信ができない場合(デリゲートの通知がこない場合等)
 *   端末の設定アプリより、Bluetoothを選択し,記憶しているデバイス情報をリセットすることで改善する場合があります。
 *
 *
 *
 *
 *
 *
 * ------利用方法----------
 * 検知するデバイスのスイッチをONにしてください。
 * ペアリングする場合は「ペアリング」ボタンをタップしてください。
 * ビーコンを検知する場合は「ビーコン」ボタンをタップしてください。
 */

#import "SearchViewController.h"
#import "SelectDevice.h"
#import "UIViewController+ShowInformMessage.h"

@interface SearchViewController ()<UITableViewDelegate, UITableViewDataSource,BLEConnecterDelegate,BLEDelegateModelDelegate>

@property (weak, nonatomic) IBOutlet UIButton *pairingButton;
@property (weak, nonatomic) IBOutlet UIButton *beaconButton;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (nonatomic) BLEConnecter *connecter;
@property (nonatomic) NSMutableArray *deviceArray;
@property (nonatomic) BOOL isPartialScanning;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //ボタン非活性
    self.pairingButton.enabled = NO;
    self.beaconButton.enabled = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //ボタン活性・非活性
    if([SelectDevice sharedInstance].device.peripheral.identifier.UUIDString.length == 0){
        
        //チェックしているデバイスがなければ非活性とする
        self.pairingButton.enabled = NO;
        self.beaconButton.enabled = NO;
        
    }else if([SelectDevice sharedInstance].beaconMode){
        //ビーコン中はビーコンボタンを非活性
        self.pairingButton.enabled = YES;
        self.beaconButton.enabled = NO;
    }else if([[SelectDevice sharedInstance].device.connectionStatus isEqualToString:DEV_STAT_CONNECTED]){
        //ペアリング中はペアリングボタンを非活性
        self.pairingButton.enabled = NO;
        self.beaconButton.enabled = YES;
        
    }else{
        //チェックしているデバイスが有りペアリングしていないのでボタンを活性させる
        self.pairingButton.enabled = YES;
        self.beaconButton.enabled = YES;
    }
    
}

//スキャン準備
-(void)scanStart{
    self.deviceArray = [[NSMutableArray alloc] init];
    self.connecter = [BLEConnecter sharedInstance];
    //デリゲート登録
    [self.connecter addListener:self deviceUUID:nil];
    
    if([SelectDevice sharedInstance].device.peripheral.identifier.UUIDString.length != 0){
        [self.deviceArray addObject:[SelectDevice sharedInstance].device];
    }
    [self showDeviceList];
}

//スキャン開始
-(void)showDeviceList {
    
    [self.connecter scanDevice];
    
}

//接続する
- (IBAction)pairingButtonTap:(id)sender {
    
    [self.connecter connectDevice:[SelectDevice sharedInstance].device.peripheral];
    self.pairingButton.enabled = NO;
    self.beaconButton.enabled = YES;
    [SelectDevice sharedInstance].beaconMode = NO;
    
}

//ビーコンに設定する
- (IBAction)beaconButtonTap:(id)sender {
    
    self.pairingButton.enabled = YES;
    self.beaconButton.enabled = NO;
    [self.connecter disconnectByDeviceUUID:[SelectDevice sharedInstance].device.peripheral.identifier.UUIDString];
    if (!self.isPartialScanning) {
        self.isPartialScanning = YES;
        [self.connecter startPartialScanDevice];
        [SelectDevice sharedInstance].beaconMode = YES;
    } else {
        self.isPartialScanning = NO;
        [self.connecter stopPartialScanDevice];
    }
    
}

//スキャンリストを削除し再スキャンする
- (IBAction)reloadButtonTap:(id)sender {
    self.deviceArray = [[NSMutableArray alloc] init];
    [self.mTableView reloadData];
    [self scanStart];
}

//すでにリストにあるか判定
-(BOOL)hadInDeviceArray:(NSString *)uuidStr{
    
    BOOL existed = NO;
    for(BLEDeviceSetting *device in self.deviceArray){
        if([device.peripheral.identifier.UUIDString isEqualToString:uuidStr]){
            existed = YES;
            break;
        }
    }
    return existed;
}

#pragma mark - BLE delegate

//スキャン結果
-(void)didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    if(![self hadInDeviceArray:peripheral.identifier.UUIDString]){
        BLEDeviceSetting *device = [self.connecter getDeviceByPeripheral:peripheral];
        device.inDistanceThreshold = YES;
        if(device != nil){
            [self.deviceArray addObject:device];
            [self.mTableView reloadData];
        }
    }
}

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

- (void)didFailToWrite:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"didFailToWrite error :%@",error);
}

//デバイス情報の更新
-(void)updateDeviceArrayByPeripheral:(CBPeripheral *)peripheral{
    BLEDeviceSetting *foundDevice = [self.connecter getDeviceByPeripheral:peripheral];
    NSString *uuidStr = foundDevice.peripheral.identifier.UUIDString;
    int index = 0;
    for(BLEDeviceSetting *device in self.deviceArray){
        if([device.peripheral.identifier.UUIDString isEqualToString:uuidStr]){
            // ローカル名を上書きする
            if (peripheral.name != nil && peripheral.name.length > 0) {
                foundDevice.name = peripheral.name;
            }
            [self.deviceArray replaceObjectAtIndex:index withObject:foundDevice];
            [self.mTableView reloadData];
            break;
        }
        index++;
    }
}

//インデックスパスを取得
- (NSIndexPath *)indexPathForCellContainingView:(UIView *)view {
    while (view != nil) {
        if ([view isKindOfClass:[UITableViewCell class]]) {
            return [self.mTableView indexPathForCell:(UITableViewCell *)view];
        } else {
            view = [view superview];
        }
    }
    return nil;
}

//UIスイッチの変更を監視
-(void)switchChanged:(UISwitch *)switchBtn{
    
    NSIndexPath *indexPath = [self indexPathForCellContainingView:switchBtn];
    if(indexPath.row >= 0 && indexPath.row<self.deviceArray.count){
        BLEDeviceSetting *device = [self.deviceArray objectAtIndex:indexPath.row];
        if(switchBtn.on){
            //デバイスを登録
            [SelectDevice sharedInstance].device = device;
            self.pairingButton.enabled = YES;
            self.beaconButton.enabled = YES;
        }else{
            //デバイスを削除
            self.pairingButton.enabled = NO;
            self.beaconButton.enabled = NO;
            [self.connecter disconnectByDeviceUUID:device.peripheral.identifier.UUIDString];
            [SelectDevice sharedInstance].beaconMode = NO;
            [SelectDevice sharedInstance].device = nil;
        }
    }
    
    [self.mTableView reloadData];
}


#pragma mark - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.deviceArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deviceItemcell"];
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:1];
    BLEDeviceSetting *device = [self.deviceArray objectAtIndex:indexPath.row];
    NSString *deviceName = device.name;
    if([deviceName length] == 0){
        deviceName = device.peripheral.identifier.UUIDString;
    }
    nameLabel.text = deviceName;
    UISwitch *switchBtn = [cell viewWithTag:2];
    [switchBtn addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    if([[SelectDevice sharedInstance].device.peripheral.identifier.UUIDString isEqualToString:device.peripheral.identifier.UUIDString]){
        switchBtn.on = YES;
    }else{
        switchBtn.on = NO;
        if ([device.connectionStatus isEqualToString:DEV_STAT_CONNECTED]) {
            [self.connecter disconnectByDeviceUUID:device.peripheral.identifier.UUIDString];
            [SelectDevice sharedInstance].beaconMode = NO;
        }
    }
    
    return cell;
}

#pragma mark - Delegate Methods

//接続
- (void)didConnectDevice:(BLEDeviceSetting *)setting {
    
    NSString *message = [NSString stringWithFormat:@"%@とペアリングしました",setting.name];
    if([self.navigationController.topViewController isKindOfClass:[SearchViewController class]]){
        [self ShowInformMessage_showInformWithMessage:message title:nil okActionName:@"OK" handler:nil cancelActionName:nil handler:nil];
    }
}

//切断
- (void)didDisconnectDevice:(BLEDeviceSetting *)setting{
    
    NSString *message = [NSString stringWithFormat:@"%@が切断されました",setting.name];
    if([self.navigationController.topViewController isKindOfClass:[SearchViewController class]]){
        [self ShowInformMessage_showInformWithMessage:message title:nil okActionName:@"OK" handler:nil cancelActionName:nil handler:nil];
    }
}

@end
