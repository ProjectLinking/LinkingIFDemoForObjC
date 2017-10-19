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
 * 「スキャン画面」ボタンをタップし、サーチを開始してください
 */


#import "MainViewController.h"
#import <LinkingLibrary/LinkingLibrary.h>
#import "SearchViewController.h"
#import "SelectDevice.h"
#import "UIViewController+ShowInformMessage.h"

@interface MainViewController () <BLEConnecterDelegate,BLEDelegateModelDelegate>

@property (nonatomic)BLEConnecter *connecter;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // インスタンス生成
    self.connecter = [BLEConnecter sharedInstance];
    // デリゲートの登録
    [self.connecter addListener:self deviceUUID:nil];
    //_/_/_/_/_/ テストコード
//    [self.connecter addListener:self deviceUUID:nil];
//    [self.connecter addListener:self deviceUUID:nil];
//    [self.connecter removeListener:self deviceUUID:nil];
    //_/_/_/_/_/ テストコード
    
}

//検索画面へ遷移
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //Segueの特定
    if ( [[segue identifier] isEqualToString:@"toSearchView"] ) {
        SearchViewController*destinationViewController = [segue destinationViewController];
        
        //スキャンを開始する
        [destinationViewController scanStart];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //未接続の場合はペアリングが必要なボタンは非活性とする
    self.toDeviceInfoButton.enabled = [self conected];
    self.toPairingButtonIDButton.enabled = [self conected];
    self.toRumblingButton.enabled = [self conected];
    self.toPairingSensor.enabled = [self conected];
    
    //ペアリング中、検知しているデバイスがない場合,ビーコンのボタンは非活性とする
    if([SelectDevice sharedInstance].beaconMode){
        self.toBeaconIDButton.enabled = YES;
        self.toBeaconSensorButton.enabled = YES;
    }else{
        self.toBeaconIDButton.enabled = NO;
        self.toBeaconSensorButton.enabled = NO;
    }
    
    //キャリブレーションはペアリング/ビーコン未選択は非活性とする
    if ( [self conected] ||[SelectDevice sharedInstance].beaconMode ) {
        self.toCalibrationButton.enabled = YES;
    }else{
        self.toCalibrationButton.enabled = NO;
    }
}

//接続状態確認
-(BOOL)conected{
    
    return [[SelectDevice sharedInstance].device.connectionStatus isEqualToString:DEV_STAT_CONNECTED];
}


//ビーコン情報の受信
-(void)receivedAdvertisement:(CBPeripheral *)peripheral advertisement:(NSDictionary *)data {
    
    if([[SelectDevice sharedInstance].device.peripheral.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]){
        if (data != nil) {
            //ビーコン情報を追加
            [[SelectDevice sharedInstance] addAdvertisement:data];
        }
    }
    
}

//デバイスと接続した時のデリゲート
- (void)didConnectDevice:(BLEDeviceSetting *)setting {
    
    if (![self.navigationController.topViewController isKindOfClass:[SearchViewController class]]) {
        
        NSString *message = [NSString stringWithFormat:@"%@とペアリングしました",setting.name];
        [self ShowInformMessage_showInformWithMessage:message title:nil okActionName:@"OK" handler:nil cancelActionName:nil handler:nil];
    }
}


/*
 各画面への遷移
 ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓
 */

//センサ情報(ペアリング)画面へ
- (IBAction)toPairingSensorViewButtonTap:(id)sender {
    
    if([[SelectDevice sharedInstance].device.connectionStatus isEqualToString:DEV_STAT_CONNECTED]){
        [self performSegueWithIdentifier:@"toPairingSensorView" sender:nil];
    }
    
}

//LED点灯/バイブ画面へ
- (IBAction)toRumblingViewButtonTap:(id)sender {
    
    if([[SelectDevice sharedInstance].device.connectionStatus isEqualToString:DEV_STAT_CONNECTED]){
        [self performSegueWithIdentifier:@"toRumblingView" sender:nil];
    }
    
}

//デバイス情報取得画面へ
- (IBAction)toDeviceInfoViewButtonTap:(id)sender {
    
    if([[SelectDevice sharedInstance].device.connectionStatus isEqualToString:DEV_STAT_CONNECTED]){
        [self performSegueWithIdentifier:@"toDeviceInfoView" sender:nil];
    }
    
}

//ボタンID画面へ
- (IBAction)toPairingButtonIDButtonTap:(id)sender {
    
    if([[SelectDevice sharedInstance].device.connectionStatus isEqualToString:DEV_STAT_CONNECTED]){
        [self performSegueWithIdentifier:@"toPairingButtonIDDataReceiveView" sender:nil];
    }
    
}

//ビーコンID画面へ
- (IBAction)toBeaconIDViewButtonTap:(id)sender {
    
    if([SelectDevice sharedInstance].beaconMode){
        if(![[SelectDevice sharedInstance].device.connectionStatus isEqualToString:DEV_STAT_CONNECTED]){
            [self performSegueWithIdentifier:@"toBeaconIDView" sender:nil];
        }
    }
    
}

//センサ情報(ビーコン)画面へ
- (IBAction)toBeaconSensorViewButtonTap:(id)sender {
    
    if([SelectDevice sharedInstance].beaconMode){
        if(![[SelectDevice sharedInstance].device.connectionStatus isEqualToString:DEV_STAT_CONNECTED]){
            [self performSegueWithIdentifier:@"toBeaconSensorView" sender:nil];
        }
    }
    
}

//キャリブレーション完了後にメニュー画面に戻る
- (IBAction)backMenuViewFromCalibrationView:(UIStoryboardSegue *)segue {
    
}

/*
 繋がらない、メッセージが送信できていない場合は下記デリゲートを確認
 ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓
 */

//デバイスが切断された
- (void)didDisconnectDevice:(BLEDeviceSetting *)setting{
    
    NSString *message = [NSString stringWithFormat:@"%@が切断されました",setting.name];
    if(![self.navigationController.topViewController isKindOfClass:[SearchViewController class]]){
        [self ShowInformMessage_showInformWithMessage:message title:nil okActionName:@"OK" handler:nil cancelActionName:nil handler:nil];
    }
}

//接続に失敗した
-(void)didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    //NSLog(@"接続に失敗しました(%@)",peripheral.name);
}

////デバイスが切断された
//-(void)didDisconnectPeripheral:(CBPeripheral *)peripheral {
//    //NSLog(@"%@が切断されました",peripheral.name);
//}

////書き込みが失敗した
//-(void)didFailToWrite:(CBPeripheral *)peripheral error:(NSError *)error {
//    //NSLog(@"書き込みが失敗しました:(%@)",error);
//}

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
    for(BLEDeviceSetting *device in [BLEPeripheralDataManager sharedManager].deviceArray){
        if([device.peripheral.identifier.UUIDString isEqualToString:uuidStr]){
            // ローカル名を上書きする
            if (peripheral.name != nil && peripheral.name.length > 0) {
                foundDevice.name = peripheral.name;
            }
            [[BLEPeripheralDataManager sharedManager].deviceArray replaceObjectAtIndex:index withObject:foundDevice];
            break;
        }
        index++;
    }
}

@end
