//
//  HistoricViewController.m
//  Pedometer
//
//  Created by Jay Versluis on 31/10/2015.
//  Copyright © 2015 Pinkstone Pictures LLC. All rights reserved.
//

#import "HistoricViewController.h"
#import "DatePickerViewController.h"

@interface HistoricViewController ()
@property (strong, nonatomic) IBOutlet UILabel *startDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *endDateLabel;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (strong, nonatomic) NSDate *tempDate;
@end

@implementation HistoricViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)showDatePickerWithType: (NSString *)dateType {
    
    // instantiate our date picker
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"DatePicker"];
    DatePickerViewController *dateController = navController.viewControllers.lastObject;
    dateController.dateType = dateType;
    
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


@end
