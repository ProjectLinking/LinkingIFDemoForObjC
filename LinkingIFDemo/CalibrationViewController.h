/**
 * Copyright © 2015-2016 NTT DOCOMO, INC. All Rights Reserved.
 */

#import <UIKit/UIKit.h>

//コメント有：キャリブレーション(距離調整)
//コメント無：実際に距離の測定
//#define CALC_DISTANCE

@interface CalibrationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *viewAlert;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end
