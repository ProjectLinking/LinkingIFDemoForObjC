/**
 * Copyright © 2015-2016 NTT DOCOMO, INC. All Rights Reserved.
 * ------説明----------
 * センサー情報の通知を設定します。
 */

#import "PairingSensorViewController.h"
#import "SelectDevice.h"
#import "SensorDataReceiveViewController.h"

@interface PairingSensorViewController ()<UIActionSheetDelegate,UITextFieldDelegate>{
}

@property (weak, nonatomic) IBOutlet UIButton *sensorTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton *intervalBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopTimeBtn;

@property(nonatomic) char sensorType;
@property(nonatomic) float sensorInterval;
@property(nonatomic) float sensorStopTime;

@end

@implementation PairingSensorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初期化
    self.sensorType = 0x00;
    self.sensorInterval = 0.0f;
    self.sensorStopTime = 0.0f;
}

//デバイスにセンサーをスタートさせるメッセージを送信する
- (IBAction)sendMessageBtnClick:(id)sender {
    
    BLEDeviceSetting *device = [SelectDevice sharedInstance].device;
    if(device != nil && device.peripheral != nil){
        CBPeripheral *peripheral = device.peripheral;
        
        //メッセージ送信
        [[BLERequestController sharedInstance] setNotifySensorInfoMessage:peripheral sensorType:self.sensorType xThreshold:0
                                                               yThreshold:0
                                                               zThreshold:0
                                                             originalData:nil
                                                              setInterval:self.sensorInterval setAutoStopTime:self.sensorStopTime disconnect:NO];
        
        //受信画面へ遷移
        [self performSegueWithIdentifier:@"toReceiveMessage" sender:nil];
    }
}

//センサータイプを選択
- (IBAction)sensorTypeBtnClicked:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"センサー種別"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"ジャイロセンサー"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {
                                                       [self clickedButtonAtIndex:0 actionSheet:1];
                                                   }];
    [alertController addAction:action1];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"加速度センサー"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {
                                                       [self clickedButtonAtIndex:1 actionSheet:1];
                                                   }];
    [alertController addAction:action2];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"方位センサー"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {
                                                       [self clickedButtonAtIndex:2 actionSheet:1];
                                                   }];
    [alertController addAction:action3];

    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"電池残量"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        [self clickedButtonAtIndex:3 actionSheet:1];
                                                    }];
    [alertController addAction:action4];

    UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"温度センサー"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        [self clickedButtonAtIndex:4 actionSheet:1];
                                                    }];
    [alertController addAction:action5];

    UIAlertAction *action6 = [UIAlertAction actionWithTitle:@"湿度センサー"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        [self clickedButtonAtIndex:5 actionSheet:1];
                                                    }];
    [alertController addAction:action6];

    UIAlertAction *action7 = [UIAlertAction actionWithTitle:@"気圧センサー"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        [self clickedButtonAtIndex:6 actionSheet:1];
                                                    }];
    [alertController addAction:action7];

    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"キャンセル"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action) {
                                                       
                                                   }];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

//通知間隔を選択
- (IBAction)intervalBtnClicked:(id)sender {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"通知間隔"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"デフォルト"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        [self clickedButtonAtIndex:0 actionSheet:2];
                                                    }];
    [alertController addAction:action1];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"1秒"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        [self clickedButtonAtIndex:1 actionSheet:2];
                                                    }];
    [alertController addAction:action2];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"3秒"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        [self clickedButtonAtIndex:2 actionSheet:2];
                                                    }];
    [alertController addAction:action3];
    
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"5秒"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        [self clickedButtonAtIndex:3 actionSheet:2];
                                                    }];
    [alertController addAction:action4];
    
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"10秒"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        [self clickedButtonAtIndex:4 actionSheet:2];
                                                    }];
    [alertController addAction:action5];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"キャンセル"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action) {
                                                       
                                                   }];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

//センサーが停止するまでの時間を選択
- (IBAction)stopTimeBtnClicked:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"停止時間"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"デフォルト"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        [self clickedButtonAtIndex:0 actionSheet:3];
                                                    }];
    [alertController addAction:action1];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"1分"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        [self clickedButtonAtIndex:1 actionSheet:3];
                                                    }];
    [alertController addAction:action2];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"3分"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        [self clickedButtonAtIndex:2 actionSheet:3];
                                                    }];
    [alertController addAction:action3];
    
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"10分"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        [self clickedButtonAtIndex:3 actionSheet:3];
                                                    }];
    [alertController addAction:action4];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"キャンセル"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action) {
                                                       
                                                   }];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

//選択項目を設定
-(void)clickedButtonAtIndex:(NSInteger)buttonIndex actionSheet:(NSInteger)tag {

    if(tag == 1){
        switch (buttonIndex) {
            case 0:
            {
                [self.sensorTypeBtn setTitle:@"ジャイロセンサー" forState:UIControlStateNormal];
                self.sensorType = 0x00;
            }
                break;
            case 1:
            {
                [self.sensorTypeBtn setTitle:@"加速度センサー" forState:UIControlStateNormal];
                self.sensorType = 0x01;
            }
                break;
            case 2:
            {
                [self.sensorTypeBtn setTitle:@"方位センサー" forState:UIControlStateNormal];
                self.sensorType = 0x02;
            }
                break;
            case 3:
            {
                [self.sensorTypeBtn setTitle:@"電池残量" forState:UIControlStateNormal];
                self.sensorType = 0x03;
            }
                break;
            case 4:
            {
                [self.sensorTypeBtn setTitle:@"温度センサー" forState:UIControlStateNormal];
                self.sensorType = 0x04;
            }
                break;
            case 5:
            {
                [self.sensorTypeBtn setTitle:@"湿度センサー" forState:UIControlStateNormal];
                self.sensorType = 0x05;
            }
                break;
            case 6:
            {
                [self.sensorTypeBtn setTitle:@"気圧センサー" forState:UIControlStateNormal];
                self.sensorType = 0x06;
            }
                break;
                
            default:
                break;
        }
    }else if(tag == 2){
        switch (buttonIndex) {
            case 0:
            {
                [self.intervalBtn setTitle:@"デフォルト" forState:UIControlStateNormal];
                self.sensorInterval = 0.0f;
            }
                break;
            case 1:
            {
                [self.intervalBtn setTitle:@"1.0秒" forState:UIControlStateNormal];
                self.sensorInterval = 1.0f;
                
            }
                break;
            case 2:
            {
                [self.intervalBtn setTitle:@"3秒" forState:UIControlStateNormal];
                self.sensorInterval = 3.0f;
            }
                break;
            case 3:
            {
                [self.intervalBtn setTitle:@"5秒" forState:UIControlStateNormal];
                self.sensorInterval = 5.0f;
            }
                break;
                
            case 4:
            {
                [self.intervalBtn setTitle:@"10秒" forState:UIControlStateNormal];
                self.sensorInterval = 10.0f;
            }
                break;
            default:
                break;
        }
        
    } else if(tag == 3){
        switch (buttonIndex) {
            case 0:
            {
                [self.stopTimeBtn setTitle:@"デフォルト" forState:UIControlStateNormal];
                self.sensorStopTime = 0.0f;
                
            }
                break;
            case 1:
            {
                [self.stopTimeBtn setTitle:@"1分" forState:UIControlStateNormal];
                self.sensorStopTime = 60.0f;
            }
                break;
            case 2:
            {
                [self.stopTimeBtn setTitle:@"3分" forState:UIControlStateNormal];
                self.sensorStopTime = 180.0f;
            }
                break;
            case 3:
            {
                [self.stopTimeBtn setTitle:@"10分" forState:UIControlStateNormal];
                self.sensorStopTime = 600.0f;
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
