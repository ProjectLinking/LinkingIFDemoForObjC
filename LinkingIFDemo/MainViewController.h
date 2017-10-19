/**
 * Copyright © 2015-2016 NTT DOCOMO, INC. All Rights Reserved.
 */

#import <UIKit/UIKit.h>
#import <LinkingLibrary/LinkingLibrary.h>

@interface MainViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *toDeviceInfoButton;
@property (weak, nonatomic) IBOutlet UIButton *toPairingButtonIDButton;
@property (weak, nonatomic) IBOutlet UIButton *toRumblingButton;
@property (weak, nonatomic) IBOutlet UIButton *toPairingSensor;
@property (weak, nonatomic) IBOutlet UIButton *toBeaconIDButton;
@property (weak, nonatomic) IBOutlet UIButton *toBeaconSensorButton;
@property (weak, nonatomic) IBOutlet UIButton *toCalibrationButton;
@end
