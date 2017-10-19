/**
 * Copyright © 2015-2016 NTT DOCOMO, INC. All Rights Reserved.
 * ------説明----------
 * 選択されたデバイスを管理するクラス
 */

#import "SelectDevice.h"

@implementation SelectDevice

+ (SelectDevice *)sharedInstance
{
    static SelectDevice *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

//アドバタイズのデータを保存
-(void)addAdvertisement:(NSDictionary*)advertise {
    
    if(self.advertisementArray.count == 0){
        self.advertisementArray = [[NSMutableArray alloc]init];
        self.advertisementDic = [[NSMutableDictionary alloc]init];
    }
    
    [self.advertisementArray addObject:advertise];
    
    //アドバタイズの受信を通知する
    if ([self.delegate respondsToSelector:@selector(advertisementReceive)]) {
        [self.delegate advertisementReceive];
        
    }
    
}

//アドバタイズのデータを削除
-(void)deleteAdvertise {
    self.advertisementArray = [[NSMutableArray alloc]init];
}
@end
