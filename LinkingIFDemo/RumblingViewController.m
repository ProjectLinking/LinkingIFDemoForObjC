/**
 * Copyright © 2015-2016 NTT DOCOMO, INC. All Rights Reserved.
 * ------説明----------
 * LED/バイブレーションを鳴動させます。
 */


#import "RumblingViewController.h"
#import "SelectDevice.h"

typedef NS_ENUM(NSUInteger, SelectType) {
    SelectTypeColor,
    SelectTypePattern,
    SelectTypeBeep,
    SelectTypeVibration
};

@interface RumblingViewController () <UIActionSheetDelegate,BLEConnecterDelegate,BLEDelegateModelDelegate>

@property (weak, nonatomic) IBOutlet UIButton *selectColorBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectPatternBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectVibrationBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectBeepBtn;
@property (weak, nonatomic) IBOutlet UIButton *startDemoButton;
@property (weak, nonatomic) IBOutlet UIButton *stopDemoButton;

//LEDカラー
@property (nonatomic) NSMutableArray *colorList;
@property (nonatomic)NSString *colorName;
@property (nonatomic)NSInteger selectedColorIndex;

//LEDパターン
@property (nonatomic)NSMutableArray *patternList;
@property (nonatomic)NSInteger selectedPatternIndex;

//バイブレーション
@property (nonatomic)NSMutableArray *vibrationList;
@property (nonatomic)NSInteger selectedVibrationIndex;

//ビープパターン
@property (nonatomic)NSMutableArray *beepList;
//@property (nonatomic)NSDictionary *beepDic;
//@property (nonatomic)NSString *beepName;
//@property (nonatomic)NSData *beepData;
@property (nonatomic)NSInteger selectedBeepIndex;

//APIに設定するデータ
@property (nonatomic)NSMutableDictionary *selectedLED;
@property (nonatomic)NSMutableDictionary *selectedVIB;
@property (nonatomic)NSMutableDictionary *selectedBEP;

//設定するデバイス
@property (nonatomic)BLEDeviceSetting *device;

//デモ実行フラグ
@property (nonatomic)BOOL demoInProgress;

@end

@implementation RumblingViewController{
    
}

#pragma mark - Override Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初期値設定
    self.selectedColorIndex = -1;
    self.selectedPatternIndex = -1;
    self.selectedVibrationIndex = -1;
    self.selectedBeepIndex = -1;
    self.demoInProgress = NO;
    [self updateButtonsState];
    
    self.device = [SelectDevice sharedInstance].device;
    if (!self.device || !self.device.peripheral) {
        return;
    }
    
    BLEConnecter *connector = [BLEConnecter sharedInstance];
    //デリゲート登録
    [connector addListener:self deviceUUID:self.device.peripheral.identifier.UUIDString];
    
    [self setList];
}

//各種リスト取得
-(void)setList{
    
    //設定名称リストを取得
    self.colorList = [[NSMutableArray alloc] init];
    self.colorList = [[[BLERequestController sharedInstance]getSettingName:self.device.peripheral settingNameType:LEDColorName]mutableCopy];
    
    //LEDパターンリストを取得
    self.patternList = [[NSMutableArray alloc] init];
    self.patternList = [[[BLERequestController sharedInstance]getSettingName:self.device.peripheral settingNameType:LEDPatternName]mutableCopy];
    
    //バイブレーションパターンリストを取得
    self.vibrationList = [[NSMutableArray alloc] init];
    self.vibrationList = [[[BLERequestController sharedInstance]getSettingName:self.device.peripheral settingNameType:VibrationPatternName]mutableCopy];
    
    //ビープパターンリストを取得
    self.beepList = [[NSMutableArray alloc] init];
    self.beepList = [[[BLERequestController sharedInstance]getSettingName:self.device.peripheral settingNameType:NotifySoundPatternName]mutableCopy];

    //現在のLED設定値をコピーしてセット
    self.selectedLED = [[NSMutableDictionary alloc]init];
    self.selectedLED = self.device.settingInformationDataLED;
    
    //現在のバイブレーションの設定値をコピーしてセット
    self.selectedVIB = [[NSMutableDictionary alloc]init];
    self.selectedVIB = self.device.settingInformationDataVibration;
    
    //現在のビープの設定値をコピーしてセット
    self.selectedBEP = [[NSMutableDictionary alloc]init];
    self.selectedBEP = self.device.settingInformationDataNotifySound;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate Methods

//LEDカラーを選択
- (IBAction)selectColorBtnClick:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"色選択"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSInteger index = 0;
    
    for (NSString *title in self.colorList) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:title
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action) {
                                                           [self clickedButtonAtIndex:index actionSheet:SelectTypeColor];
                                                       }];
        
        index ++;
        [alertController addAction:action];
        
    }
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"キャンセル"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action) {
                                                       
                                                   }];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

//LEDパターンを選択
- (IBAction)selectPatternBtnClick:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"パターン選択"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSInteger index = 0;
    
    for (NSString *title in self.patternList) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:title
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action) {
                                                           [self clickedButtonAtIndex:index actionSheet:SelectTypePattern];
                                                       }];
        
        index ++;
        [alertController addAction:action];
        
    }
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"キャンセル"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action) {
                                                   }];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

//バイブレーションパターンを選択
- (IBAction)selectVibrationPatternBtnClick:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"バイブレーション選択"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSInteger index = 0;
    
    for (NSString *title in self.vibrationList) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:title
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action) {
                                                           [self clickedButtonAtIndex:index actionSheet:SelectTypeVibration];
                                                       }];
        
        index ++;
        [alertController addAction:action];
    }
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"キャンセル"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action) {
                                                       
                                                   }];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

//ビープパターン選択
- (IBAction)selectBeepPatternBtnClick:(id)sender {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ビープパターン選択"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSInteger index = 0;
    
    for (NSString *title in self.beepList) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:title
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action) {
                                                           [self clickedButtonAtIndex:index actionSheet:SelectTypeBeep];
                                                       }];
        
        index ++;
        [alertController addAction:action];
    }
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"キャンセル"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action) {
                                                       
                                                   }];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];

}


//選択された項目毎に処理を分岐
-(void)clickedButtonAtIndex:(NSInteger)buttonIndex actionSheet:(NSInteger)tag {
    
    switch (tag) {
        case SelectTypeColor:
            [self colorActionSheetDidSelectAtIndex:buttonIndex];
            break;
        case SelectTypePattern:
            [self patternActionSheetDidSelectAtIndex:buttonIndex];
            break;
        case SelectTypeVibration:
            [self vibrationActionSheetDidSelectAtIndex:buttonIndex];
            break;
        case SelectTypeBeep:
            [self beepActionSheetDidSelectAtIndex:buttonIndex];
            break;
        default:
            break;
    }
}

//デモンストレーションを開始する
- (IBAction)startDemoAction:(id)sender {
    
    self.demoInProgress = YES;
    [self updateButtonsState];
    self.device = [SelectDevice sharedInstance].device;
    if (self.device && self.device.peripheral) {
        
        //デモンストレーション開始API
        [[BLERequestController sharedInstance]startDemoSelectSettingInformationWithLED:self.selectedLED
                                                                             vibration:self.selectedVIB
                                                                           notifySound:self.selectedBEP
                                                                            peripheral:self.device.peripheral
                                                                            disconnect:NO];

    }
}

//デモンストレーションを停止する
- (IBAction)stopDemoAction:(id)sender {
    self.demoInProgress = NO;
    [self updateButtonsState];
    self.device = [SelectDevice sharedInstance].device;
    if (self.device && self.device.peripheral) {
        
        //デモンストレーション停止API
        [[BLERequestController sharedInstance] stopDemoSelectSettingInformationWithLED:nil
                                                                             vibration:nil
                                                                           notifySound:nil
                                                                            peripheral:self.device.peripheral
                                                                            disconnect:NO];
    }
}

#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Private Methods
//選択された色を返却
- (UIColor *)getColorFromName:(NSString *)name {
    UIColor *color = nil;
    
    if (name) {
        if ([name compare:@"black\0" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            color = [UIColor blackColor];
        } else if ([name compare:@"darkgray\0" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            color = [UIColor darkGrayColor];
        } else if ([name compare:@"lightgray\0" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            color = [UIColor lightGrayColor];
        } else if ([name compare:@"white\0" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            color = [UIColor whiteColor];
        } else if ([name compare:@"gray\0" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            color = [UIColor grayColor];
        } else if ([name compare:@"red\0" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            color = [UIColor redColor];
        } else if ([name compare:@"green\0" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            color = [UIColor greenColor];
        } else if ([name compare:@"blue\0" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            color = [UIColor blueColor];
        } else if ([name compare:@"cyan\0" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            color = [UIColor cyanColor];
        } else if ([name compare:@"yellow\0" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            color = [UIColor yellowColor];
        } else if ([name compare:@"magenta\0" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            color = [UIColor magentaColor];
        } else if ([name compare:@"orange\0" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            color = [UIColor orangeColor];
        } else if ([name compare:@"purple\0" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            color = [UIColor purpleColor];
        } else if ([name compare:@"brown\0" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            color = [UIColor brownColor];
        } else {
            color = [UIColor clearColor]; // Other color need to update here.
        }
    }
    
    return color;
}

//ボタンを更新
- (void)updateButtonsState {
    [self.startDemoButton setEnabled:!self.demoInProgress];
    [self.stopDemoButton setEnabled:self.demoInProgress];
}

//選択されたLEDカラーに変更する
- (void)colorActionSheetDidSelectAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex >= 0 && self.colorList.count > buttonIndex) {
        [self.selectColorBtn setTitle:[self.colorList objectAtIndex:buttonIndex] forState:UIControlStateNormal];
        
        self.colorName = [self.colorList objectAtIndex:buttonIndex];
        self.selectColorBtn.backgroundColor = [self getColorFromName:self.colorName];
        
        self.device = [SelectDevice sharedInstance].device;
        if (self.device && self.device.settingInformationDataLED) {
            self.selectedColorIndex = buttonIndex + 1; // カラーインデックスは 0x01, 0x02
            
            //APIに設定するデータのLEDカラーを選択された値に変更する
            [self.selectedLED setObject:[NSNumber numberWithInteger:self.selectedColorIndex] forKey:@"settingColorNumber"];
            
        } else {
            self.selectedColorIndex = -1;
        }
    }
    
    [self updateButtonsState];
}

//選択されたLEDパターンに変更する
- (void)patternActionSheetDidSelectAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex >= 0 && self.patternList.count > buttonIndex) {
        [self.selectPatternBtn setTitle:[self.patternList objectAtIndex:buttonIndex] forState:UIControlStateNormal];
        
        self.device = [SelectDevice sharedInstance].device;
        if (self.device && self.device.settingInformationDataLED) {
            self.selectedPatternIndex = buttonIndex + 1; // パターンインデックスは 0x01, 0x02
            
            //APIに設定するデータのLEDパターンを選択された値に変更する
            [self.selectedLED setObject:[NSNumber numberWithInteger:self.selectedPatternIndex] forKey:@"settingPatternNumber"];
        } else {
            self.selectedPatternIndex = -1;
        }
    }
    
    [self updateButtonsState];
}

//選択されたバイブレーションパターンに変更する
- (void)vibrationActionSheetDidSelectAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex >= 0 && self.vibrationList.count > buttonIndex) {
        [self.selectVibrationBtn setTitle:[self.vibrationList objectAtIndex:buttonIndex] forState:UIControlStateNormal];
        
        self.device = [SelectDevice sharedInstance].device;
        if (self.device && self.device.settingInformationDataVibration) {
            self.selectedVibrationIndex = buttonIndex + 1; // パターンインデックスは 0x01, 0x02
            
            //APIに設定するデータのバイブレーションパターンを選択された値に変更する
            [self.selectedVIB setObject:[NSNumber numberWithInteger:self.selectedVibrationIndex] forKey:@"settingPatternNumber"];
        } else {
            self.selectedVibrationIndex = -1;
        }
    }
    
    [self updateButtonsState];
}

//選択されたビープパターンに変更する
- (void)beepActionSheetDidSelectAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex >= 0 && self.beepList.count > buttonIndex) {
        [self.selectBeepBtn setTitle:[self.beepList objectAtIndex:buttonIndex] forState:UIControlStateNormal];
        
        self.device = [SelectDevice sharedInstance].device;
        if (self.device && self.device.settingInformationDataNotifySound) {
            self.selectedBeepIndex = buttonIndex + 1;
            [self.selectedBEP setObject:[NSNumber numberWithInteger:self.selectedBeepIndex] forKey:@"settingPatternNumber"];
        } else {
            self.selectedBeepIndex = -1;
        }
    }
    
    [self updateButtonsState];
}


@end
