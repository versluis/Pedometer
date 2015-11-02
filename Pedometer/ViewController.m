//
//  ViewController.m
//  Pedometer
//
//  Created by Jay Versluis on 29/10/2015.
//  Copyright © 2015 Pinkstone Pictures LLC. All rights reserved.
//

#import "ViewController.h"
@import CoreMotion;

@interface ViewController ()
@property (strong, nonatomic) CMPedometer *pedometer;
@property (strong, nonatomic) IBOutlet UILabel *stepsLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *cadenceLabel;
@property (strong, nonatomic) IBOutlet UILabel *paceLabel;
@property (strong, nonatomic) IBOutlet UILabel *flightsUpLabel;
@property (strong, nonatomic) IBOutlet UILabel *flightsDownLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetLabels];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CMPedometer *)pedometer {
    
    if (!_pedometer) {
        _pedometer = [[CMPedometer alloc]init];
    }
    return _pedometer;
}

- (IBAction)startTracking:(id)sender {
    
    self.stepsLabel.text = @"Gathering data...";
    
    // start live tracking
    [self.pedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
        
        // this block is called for each live update
        [self updateLabels:pedometerData];
        
    }];
}

- (IBAction)stopTracking:(id)sender {
    
    // stop live tracking
    [self.pedometer stopPedometerUpdates];
    [self resetLabels];
}

- (void)resetLabels {
    
    // reset labels
    self.stepsLabel.text = @"Press Start to begin\nPedometer Tracking";
    self.distanceLabel.text = nil;
    self.cadenceLabel.text = nil;
    self.paceLabel.text = nil;
    self.flightsUpLabel.text = nil;
    self.flightsDownLabel.text = nil;
}

- (void)updateLabels:(CMPedometerData *)pedometerData {
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.maximumFractionDigits = 2;
    
    // step counting
    if ([CMPedometer isStepCountingAvailable]) {
        self.stepsLabel.text = [NSString stringWithFormat:@"Steps walked: %@", [formatter stringFromNumber:pedometerData.numberOfSteps]];
    } else {
        self.stepsLabel.text = @"Step Counter not available.";
    }
    
    // distance
    if ([CMPedometer isDistanceAvailable]) {
        self.distanceLabel.text = [NSString stringWithFormat:@"Distance travelled: \n%@ meters", [formatter stringFromNumber:pedometerData.distance]];
    } else {
        self.distanceLabel.text = @"Distance estimate not available.";
    }
    
    // pace
    if ([CMPedometer isPaceAvailable] && pedometerData.currentPace) {
        self.paceLabel.text = [NSString stringWithFormat:@"Current Pace: \n%@ seconds per meter", [formatter stringFromNumber:pedometerData.currentPace]];
    } else {
        self.paceLabel.text = @"Pace not available.";
    }
    
    // cadence
    if ([CMPedometer isCadenceAvailable] && pedometerData.currentCadence) {
        self.cadenceLabel.text = [NSString stringWithFormat:@"Cadence: \n%@ steps per second", [formatter stringFromNumber: pedometerData.currentCadence]];
    } else {
        self.cadenceLabel.text = @"Cadence not available.";
    }
    
    // flights climbed
    if ([CMPedometer isFloorCountingAvailable] && pedometerData.floorsAscended) {
        self.flightsUpLabel.text = [NSString stringWithFormat:@"Floors ascended: %@", pedometerData.floorsAscended];
    } else {
        self.flightsUpLabel.text = @"Floors ascended\nnot available.";
    }
    
    if ([CMPedometer isFloorCountingAvailable] && pedometerData.floorsDescended) {
        self.flightsDownLabel.text =[NSString stringWithFormat:@"Floors descended: %@", pedometerData.floorsDescended];
    } else {
        self.flightsDownLabel.text = @"Floors descended\nnot available.";
    }

}












@end
