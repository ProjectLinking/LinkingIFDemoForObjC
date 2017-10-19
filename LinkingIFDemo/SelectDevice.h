/**
 * Copyright © 2015-2016 NTT DOCOMO, INC. All Rights Reserved.
 */

#import <Foundation/Foundation.h>
#import <LinkingLibrary/LinkingLibrary.h>

@protocol SelectDeviceDelegate <NSObject>

@optional
//アドバタイズの受信を通知する
-(void)advertisementReceive;
@end

@interface SelectDevice : NSObject<BLEConnecterDelegate>

@property (nonatomic)BLEDeviceSetting *device;
@property (nonatomic,)CBPeripheral *peripheral;
@property (nonatomic) BOOL beaconMode;
@property (nonatomic) NSMutableArray *advertisementArray;
@property (nonatomic) NSMutableDictionary *advertisementDic;
@property (nonatomic, weak) id<SelectDeviceDelegate> delegate;

+ (SelectDevice *)sharedInstance;
-(void)deleteAdvertise;
-(void)addAdvertisement:(NSDictionary*)advertise;

@end
