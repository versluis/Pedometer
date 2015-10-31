//
//  HistoricViewController.m
//  Pedometer
//
//  Created by Jay Versluis on 31/10/2015.
//  Copyright © 2015 Pinkstone Pictures LLC. All rights reserved.
//

#import "HistoricViewController.h"
#import "DatePickerViewController.h"
@import CoreMotion;

@interface HistoricViewController ()
@property (strong, nonatomic) IBOutlet UILabel *startDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *endDateLabel;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (strong, nonatomic) NSDate *tempDate;
@property (strong, nonatomic) CMPedometer *pedometer;
@end

@implementation HistoricViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startDate];
    [self endDate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CMPedometer *)pedometer {
    
    if ((!_pedometer)) {
        _pedometer = [[CMPedometer alloc]init];
    }
    return _pedometer;
}

- (NSDate *)startDate {
    
    // set the start date to yesterday
    if (!_startDate) {
        NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [[NSDateComponents alloc]init];
        [components setDay:-1];
        NSDate *today = [NSDate date];
        NSDate *yesterday = [calendar dateByAddingComponents:components toDate:today options:0];
        _startDate = yesterday;
        
        // reflect this fact on our label too
        self.startDateLabel.text = [self turnDateIntoString:_startDate];
    }
    return _startDate;
}

- (NSDate *)endDate {
    
    if (!_endDate) {
        
        // make sure the end date is today
        _endDate = [NSDate date];
        
        // reflect this fact on our label too
        self.endDateLabel.text = [self turnDateIntoString:_endDate];
    }
    return _endDate;
}

- (IBAction)startDateEntered:(id)sender {
    
    [self showDatePickerWithType:@"startDate"];
    
}

- (IBAction)endDateEnterted:(id)sender {
    
    [self showDatePickerWithType:@"endDate"];
}

- (NSString *)turnDateIntoString:(NSDate *)date {
    
    // create a number formatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    
    return [formatter stringFromDate:date];
}

- (IBAction)queryPedometer:(id)sender {
    
    // retrieve data between dates
    [self.pedometer queryPedometerDataFromDate:self.startDate toDate:self.endDate withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
        
        // historic pedometer data is provided here
        [self presentPedometerData:pedometerData];
        
    }];
}

- (IBAction)dateReceived:(UIStoryboardSegue *)segue {
    
    // grab the date from the date picker
    DatePickerViewController *controller = segue.sourceViewController;
    
    // update date properties
    if ([controller.dateType isEqualToString:@"startDate"]) {
        self.startDate = controller.datePicker.date;
    } else {
        self.endDate = controller.datePicker.date;
    }
    
    // update labels
    [self updateLabelWithDate:controller.datePicker.date forType:controller.dateType];
}

- (IBAction)dateCancelled:(UIStoryboardSegue *)sender {
    
    // we do nothing here
}

- (void)showDatePickerWithType:(NSString *)dateType {
    
    // instantiate our date picker (rather tedious nav controller hierarchy)
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"DatePicker"];
    DatePickerViewController *dateController = navController.viewControllers.lastObject;
    dateController.dateType = dateType;

    // give it a date
    if ([dateType isEqualToString:@"startDate"]) {
        dateController.date = self.startDate;
    } else {
        dateController.date = self.endDate;
    }
    
    // and present it
    [self presentViewController:navController animated:YES completion:^{
        
        // do something on completion if necessary
        
    }];
}

- (void)updateLabelWithDate:(NSDate *)date forType:(NSString *)dateType {

    // update start or end date labels
    if ([dateType isEqualToString:@"startDate"]) {
        self.startDateLabel.text = [self turnDateIntoString:date];
    } else {
        self.endDateLabel.text = [self turnDateIntoString:date];
    }
}

- (void)presentPedometerData:(CMPedometerData *)data {
    
    // make those decimals look handsome
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.maximumFractionDigits = 2;
    formatter.minimumIntegerDigits = 1;
    
    // setup some strings
    NSString *steps;
    NSString *distance;
    NSString *floorsUp;
    NSString *floorsDown;

    // format our data
    if ([CMPedometer isStepCountingAvailable]) {
        steps = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:data.numberOfSteps]];
    } else {
        steps = @"not available";
    }
    
    if ([CMPedometer isDistanceAvailable]) {
        distance = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:data.distance]];
    } else {
        distance = @"not available";
    }
    
    if ([CMPedometer isFloorCountingAvailable]) {
        floorsUp = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:data.floorsAscended]];
        floorsDown = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:data.floorsDescended]];
    } else {
        floorsUp = @"not available";
        floorsDown = @"not available";
    }
    
    NSString *message = [NSString stringWithFormat:@"Total steps: %@\nTotal Distance: %@\nFloors climbed up: %@\nFloors climbed down: %@", steps, distance, floorsUp, floorsDown];
    
    // create an alert view
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Results" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Excellent!" style:UIAlertActionStyleDefault handler:nil];
    [controller addAction:action];
    
    [self presentViewController:controller animated:YES completion:nil];
    
    
}


@end
