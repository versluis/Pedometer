# Pedometer
iOS 9 project demonstrating how to access the step counter on devices with motion coprocessor.

The app has two buttons at the top to start and stop live step tracking. It takes a moment for data to be delivered, so be patient. 

When data is available, it regularly updates 6 labels with the following information:
 * steps walked
 * distance travelled while walking
 * current pace
 * current step cadence
 * flights climbed up
 * and flights climed down
 
If one of those items is not available the label will reflect this. For example, the option for flight tracking is only available on devices with a barometer (iPhone 6 and 6s).
