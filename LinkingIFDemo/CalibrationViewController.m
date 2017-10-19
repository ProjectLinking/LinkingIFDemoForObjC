/**
 * Copyright © 2015-2016 NTT DOCOMO, INC. All Rights Reserved.
 * ------説明----------
 * 距離測定のための電波強度(RSSI)の平均値を算出します
 */


#import <LinkingLibrary/LinkingLibrary.h>
#import "UIViewController+ShowInformMessage.h"
#import "CalibrationViewController.h"
#import "SelectDevice.h"


@interface CalibrationViewController() <BLEDelegateModelDelegate,UIAlertViewDelegate,BLEDeviceSettingDelegate>
{
    BLEDeviceSetting *device;
    BLEConnecter     *bleConnector;
    NSMutableArray   *receiveMessageArrayDistance;
}

@end

@implementation CalibrationViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    device                            = [SelectDevice sharedInstance].device;
    bleConnector.device               = [SelectDevice sharedInstance].device;
    bleConnector                      = [BLEConnecter sharedInstance];
    device.delegateDeviceSetting      = self;

    //測定中ダイアログのデザイン変更と非表示化します
    self.viewAlert.hidden             = true;
    self.viewAlert.layer.cornerRadius = 10.0f;
    self.viewAlert.layer.borderColor  = [[UIColor grayColor]CGColor];
    self.viewAlert.layer.borderWidth  = 1;
    self.viewAlert.clipsToBounds      = true;

#ifdef CALC_DISTANCE
    
    receiveMessageArrayDistance       = [[NSMutableArray alloc]init];
    
#else
    
    if ( [self isSelfClassViewController] ) {
        
        //注意アラートを表示します
        [self ShowInformMessage_showInformWithMessage:@"選択したデバイスを端末から１ｍ離れた場所に置き、「開始」を押してください"
                                                title:@"距離の調整"
                                         okActionName:@"OK" handler:^{
                                             
                                             [bleConnector stopCalibration];
                                             
                                             //測定中ダイアログを表示
                                             self.viewAlert.hidden = false;
                                             [self.indicator startAnimating];
                                             
                                             //キャリブレーション開始
                                             if([device.connectionStatus isEqualToString:DEV_STAT_CONNECTED]) {
                                                 [bleConnector startCalibration:0 device:device];
                                             } else {
                                                 [bleConnector startCalibration:1 device:device];
                                             }
                                             
                                         } cancelActionName:nil handler:nil];
    }
#endif
}

//キャリブレーション終了時に呼ばれます
- (void)startCalibrationSuccessDelegate:(NSNumber *)average {
    
    if ( [self isSelfClassViewController] ) {
        
        [self ShowInformMessage_showInformWithMessage:nil   //[NSString stringWithFormat:@"%f",[average floatValue]]
                                                title:@"距離調整完了"
                                         okActionName:@"OK" handler:^{
                                             [self performSegueWithIdentifier:@"backMenuView" sender:nil];
                                         } cancelActionName:nil handler:nil];
        
        self.viewAlert.hidden = true;
        [self.indicator stopAnimating];
    }
}


//キャリブレーション中エラー発生で呼ばれます
- (void)startCalibrationError:(NSError *)error {
    
    if ( [self isSelfClassViewController] ) {
        
        [self ShowInformMessage_showInformWithMessage:[NSString stringWithFormat:@"%@",error.localizedDescription]
                                                title:@"Error"
                                         okActionName:@"OK" handler:nil cancelActionName:nil handler:nil];
    
        self.viewAlert.hidden = true;
        [self.indicator stopAnimating];
    }
}


//画面終了前にキャリブレーションを終了します
- (void)viewWillDisappear:(BOOL)animated {
    
    [bleConnector stopCalibration];
}

//ダイアログ表示前にクラスを判断
-(bool)isSelfClassViewController {
    
    return [self.navigationController.topViewController isKindOfClass:[CalibrationViewController class]];
}


#ifdef CALC_DISTANCE

//概算距離の計算に成功したときに呼ばれます
- (void)calculatedDistanceSuccessDelegate:(NSNumber *)distanceInformation {

    [receiveMessageArrayDistance insertObject:distanceInformation atIndex:receiveMessageArrayDistance.count];
    [self.tableView reloadData];
}

//テーブルに距離を表示します
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CalibrationResultCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[receiveMessageArrayDistance objectAtIndex:indexPath.row]];
    
    return cell;
}

#endif

//受信済の距離の個数を設定します
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return receiveMessageArrayDistance.count;
}


@end
