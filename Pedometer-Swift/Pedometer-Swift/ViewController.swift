//
//  ViewController.swift
//  Pedometer-Swift
//
//  Created by Jay Versluis on 29/07/2016.
//  Copyright © 2016 Pinkstone Pictures LLC. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet var stepsLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var candenceLabel: UILabel!
    @IBOutlet var paceLabel: UILabel!
    @IBOutlet var flightsUpLabel: UILabel!
    @IBOutlet var flightsDownLabel: UILabel!
    
    lazy var pedometer: CMPedometer = {
        let pedometer = CMPedometer.init()
        return pedometer
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.resetLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startTracking(sender: AnyObject) {
        
        self.stepsLabel.text = "Gathering data..."
        
        // start live tracking
        self.pedometer.startPedometerUpdatesFromDate(NSDate()) { (pedometerData: CMPedometerData?, error: NSError?) in
            
            // this block is caleld for each live update
            self.updateLabels(pedometerData!)
        }
    }

    @IBAction func stopTracking(sender: AnyObject) {
        
        self.pedometer.stopPedometerUpdates()
        self.resetLabels()
    }

    func resetLabels() {
        
        self.stepsLabel.text = "Press Start to begin/nPedometer Tracking"
        self.distanceLabel.text = nil
        self.candenceLabel.text = nil
        self.paceLabel.text = nil
        self.flightsUpLabel.text = nil
        self.flightsDownLabel.text = nil
        
    }
    
    func updateLabels(pedometerData: CMPedometerData)  {
        
        // initialise a number formatter
        let formatter = NSNumberFormatter.init()
        formatter.maximumFractionDigits = 2
        
        // step counting
        if CMPedometer.isStepCountingAvailable() {
            self.stepsLabel.text = "Steps walked: \(formatter.stringFromNumber(pedometerData.numberOfSteps))"
        } else {
            self.stepsLabel.text = "Step Counter not available."
        }
        
        // distance
        if CMPedometer.isDistanceAvailable() {
            self.distanceLabel.text = "Distance travelled:\n \(formatter.stringFromNumber(pedometerData.distance!)) meters"
        } else {
            self.distanceLabel.text = "Distance estimate not available."
        }
        
        // pace
        if CMPedometer.isPaceAvailable() {
            self.paceLabel.text = "Current Pace: \n\(formatter.stringFromNumber(pedometerData.currentPace!)) seconds per meter"
        } else {
            self.paceLabel.text = "Pace not available."
        }
        
        // cadence
        if CMPedometer.isCadenceAvailable() {
            self.candenceLabel.text = "Cadence: \n \(formatter.stringFromNumber(pedometerData.currentCadence!)) steps per second"
        } else {
            self.candenceLabel.text = "Cadence not available."
        }
        
        // flights climbed
        if CMPedometer.isFloorCountingAvailable() {
            self.flightsUpLabel.text = "Floors ascended: \(formatter.stringFromNumber(pedometerData.floorsAscended!))"
            self.flightsDownLabel.text = "Floors decended: \(formatter.stringFromNumber(pedometerData.floorsDescended!))"
        } else {
            self.flightsUpLabel.text = "Floor counting not available."
            self.flightsDownLabel.text = nil
        }
    }

}

