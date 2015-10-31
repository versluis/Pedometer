//
//  DatePickerViewController.h
//  Pedometer
//
//  Created by Jay Versluis on 31/10/2015.
//  Copyright © 2015 Pinkstone Pictures LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickerViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) NSString *dateType;
@property (strong, nonatomic) NSDate *date;

@end
