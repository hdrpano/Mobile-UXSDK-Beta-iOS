//
//  DUXBetaRemainingFlightTimeData.h
//  DJIUXSDKWidgets
//
//  Copyright © 2018-2020 DJI
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DUXBetaRemainingFlightTimeData : NSObject

/**
 *  Create a new DUXRemainingFlightTimeData object.
 *
 *  @param charge  Battery charge remaining in percent.
 *  @param batteryToLand  Battery charge required to land.
 *  @param batteryToGoHome  Battery charge needed to go home.
 *  @param seriousThreshold  Serious low battery level threshold.
 *  @param lowBatteryThreshold  Low battery level threshold.
 *  @param flightTime  Flight time in seconds.
 */

- (instancetype)initWithCharge:(float)charge
           batteryNeededToLand:(float)batteryToLand
         batteryNeededToGoHome:(float)batteryToGoHome
    seriousLowBatteryThreshold:(float)seriousThreshold
           lowBatteryThreshold:(float)lowBatteryThreshold
                 andFlightTime:(NSTimeInterval)flightTime;

/**
 *  Remaining battery charge in percent
 */
@property (nonatomic, readonly) float remainingCharge;

/**
 * Battery charge required to land.
 */
@property (nonatomic, readonly) float batteryNeededToLand;

/**
 * Battery charge needed to go home.
 */
@property (nonatomic, readonly) float batteryNeededToGoHome;

/**
 * Serious low battery level threshold.
 */
@property (nonatomic, readonly) float seriousLowBatteryThreshold;

/**
 * Low battery level threshold.
 */
@property (nonatomic, readonly) float lowBatteryThreshold;

/**
 * Flight time in seconds.
 */
@property (nonatomic, readonly) NSTimeInterval flightTime;

@end

NS_ASSUME_NONNULL_END
