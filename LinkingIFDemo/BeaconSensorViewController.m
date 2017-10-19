/**
 * Copyright © 2015-2016 NTT DOCOMO, INC. All Rights Reserved.
 * ------説明----------
 * センサー情報の通知を設定します。
 */

#import "BeaconSensorViewController.h"
#import "SelectDevice.h"
#import "BeaconSensorDataReceiveViewController.h"

@interface BeaconSensorViewController ()<UIActionSheetDelegate,UITextFieldDelegate>{
}

@property (weak, nonatomic) IBOutlet UIButton *sensorTypeBtn;
@property(nonatomic) NSString *sensorType;
@property(nonatomic) NSNumber *serviceID;

@end

@implementation BeaconSensorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初期化
    self.sensorType = @"temperature";
    self.serviceID = @1;

}

 //受信画面へ
- (IBAction)sendMessageBtnClick:(id)sender {

    //受信画面へ遷移する
    [self performSegueWithIdentifier:@"toBeaconSensorDataReceiveView" sender:nil];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //Segueの特定
    if ( [[segue identifier] isEqualToString:@"toBeaconSensorDataReceiveView"] ) {
        BeaconSensorDataReceiveViewController*destinationViewController=
        [segue destinationViewController];
        
        //センサーの情報を渡す
        destinationViewController.sensorType = self.sensorType;
        destinationViewController.serviceID = self.serviceID;
        
    }
}

//センサータイプを選択
- (IBAction)sensorTypeBtnClicked:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"センサー種別"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    //temperature
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"気温"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        [self clickedButtonAtIndex:0 actionSheet:1];
                                                    }];
    [alertController addAction:action1];
    
    //atmosphericPressure
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"気圧"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        [self clickedButtonAtIndex:1 actionSheet:1];
                                                    }];
    [alertController addAction:action2];
    
    //humidity
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"湿度"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        [self clickedButtonAtIndex:2 actionSheet:1];
                                                    }];
    [alertController addAction:action3];

    //remainingPercentage
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"電池残量"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        [self clickedButtonAtIndex:3 actionSheet:1];
                                                    }];
    [alertController addAction:action4];
    
    //buttonIdentifier
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"ボタン押下情報"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        [self clickedButtonAtIndex:4 actionSheet:1];
                                                    }];
    [alertController addAction:action5];
    
    //isOpen
    UIAlertAction *action6 = [UIAlertAction actionWithTitle:@"開閉"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        [self clickedButtonAtIndex:5 actionSheet:1];
                                                    }];
    [alertController addAction:action6];

    //isHuman
    UIAlertAction *action7 = [UIAlertAction actionWithTitle:@"人感"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        [self clickedButtonAtIndex:6 actionSheet:1];
                                                    }];
    [alertController addAction:action7];

    //isVibration
    UIAlertAction *action8 = [UIAlertAction actionWithTitle:@"振動"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        [self clickedButtonAtIndex:7 actionSheet:1];
                                                    }];
    [alertController addAction:action8];

    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"キャンセル"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action) {
                                                       
                                                   }];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)clickedButtonAtIndex:(NSInteger)buttonIndex actionSheet:(NSInteger)tag {

        switch (buttonIndex) {
            case 0:
            {
                [self.sensorTypeBtn setTitle:@"気温" forState:UIControlStateNormal];
                self.sensorType = @"temperature";
                self.serviceID = @1;
                
            }
                break;
            case 1:
            {
                [self.sensorTypeBtn setTitle:@"気圧" forState:UIControlStateNormal];
                self.sensorType = @"atmosphericPressure";
                self.serviceID = @3;
            }
                break;
            case 2:
            {
                [self.sensorTypeBtn setTitle:@"湿度" forState:UIControlStateNormal];
                self.sensorType = @"humidity";
                self.serviceID = @2;
            }
                break;
            case 3:
            {
                [self.sensorTypeBtn setTitle:@"電池残量" forState:UIControlStateNormal];
                self.sensorType = @"remainingPercentage";
                self.serviceID = @4;
            }
                break;
            case 4:
            {
                [self.sensorTypeBtn setTitle:@"ボタン押下情報" forState:UIControlStateNormal];
                self.sensorType = @"buttonIdentifier";
                self.serviceID = @5;
            }
                break;
            case 5:
            {
                [self.sensorTypeBtn setTitle:@"開閉" forState:UIControlStateNormal];
                self.sensorType = @"isOpen";
                self.serviceID = @6;
            }
                break;
            case 6:
            {
                [self.sensorTypeBtn setTitle:@"人感" forState:UIControlStateNormal];
                self.sensorType = @"isHuman";
                self.serviceID = @7;
            }
                break;
            case 7:
            {
                [self.sensorTypeBtn setTitle:@"振動" forState:UIControlStateNormal];
                self.sensorType = @"isVibration";
                self.serviceID = @8;
            }
                break;
                
            default:
                break;
        }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
