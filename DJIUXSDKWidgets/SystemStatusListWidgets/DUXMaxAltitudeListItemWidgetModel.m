//
//  DUXMaxAltitudeListItemWidgetModel.m
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

#import "DUXMaxAltitudeListItemWidgetModel.h"
#import "NSObject+DUXBetaRKVOExtension.h"
@import DJIUXSDKCore;

static const CGFloat maxLegalHeight = 120;

@interface DUXMaxAltitudeListItemWidgetModel ()
@property (nonatomic, strong) DJIFlightControllerKey *maxAltitudeKey;
@property (nonatomic, strong) DJIFlightControllerKey *maxAltitudeRangeKey;
@property (nonatomic, strong) DJIFlightControllerKey *noviceModeKey;
@property (nonatomic, strong) DJIFlightControllerKey *returnHomeHeightKey;

@property (nonatomic, assign) NSUInteger    limitMaxFlightHeight;
@property (nonatomic, assign) float         returnHomeHeight;
@end

@implementation DUXMaxAltitudeListItemWidgetModel

- (void)inSetup {
    self.limitMaxFlightHeight = maxLegalHeight;
    
    self.maxAltitudeKey = [DJIFlightControllerKey keyWithParam:DJIFlightControllerParamMaxFlightHeight];
    self.maxAltitudeRangeKey = [DJIFlightControllerKey keyWithParam:DJIFlightControllerParamMaxFlightHeightRange];
    self.noviceModeKey = [DJIFlightControllerKey keyWithParam:DJIFlightControllerParamNoviceModeEnabled];
    self.returnHomeHeightKey = [DJIFlightControllerKey keyWithParam:DJIFlightControllerParamGoHomeHeightInMeters];
    
    BindSDKKey(self.maxAltitudeRangeKey, rangeValue);
    BindSDKKey(self.noviceModeKey, isNoviceMode);
    BindSDKKey(self.maxAltitudeKey, maxAltitude);
    BindSDKKey(self.returnHomeHeightKey, returnHomeHeight);
}

- (void)inCleanup {
    UnBindSDK;
}

- (DUXMaxAltitudeChange)validateNewHeight:(NSInteger)newHeight {
    if (newHeight < self.rangeValue.min.intValue) {
        return DUXMaxAltitudeChangeBelowMininimumAltitude;
    }
    
    if (newHeight > self.rangeValue.max.intValue) {
        return DUXMaxAltitudeChangeAboveMaximumAltitude;
    }

    if (newHeight > _limitMaxFlightHeight) {
        if (newHeight > _returnHomeHeight) {
            return DUXMaxAltitudeChangeAboveWarningHeightLimitAndReturnHomeAltitude;
        } else {
            return DUXMaxAltitudeChangeAboveWarningHeightLimit;
        }
    }
    
    if (newHeight > _returnHomeHeight) {
        return DUXMaxAltitudeChangeAboveReturnHomeMaxAltitude;
    }
    
    return DUXMaxAltitudeChangeMaxAltitudeValid;
}

- (void)updateMaxHeight:(NSInteger)newHeight onCompletion:(void (^)(DUXMaxAltitudeChange))resultsBlock {
    if (self.isNoviceMode) {
        resultsBlock(DUXMaxAltitudeChangeUnableToChangeMaxAltitudeInBeginnerMode);
        return;
    }
    
    [[DJISDKManager keyManager]  setValue:@(newHeight) forKey:self.maxAltitudeKey withCompletion:^(NSError * _Nullable error) {
        DUXMaxAltitudeChange returnValue = DUXMaxAltitudeChangeUnknownError;
    
        if (error) {
            NSLog(@"error setting DJIFlightControllerParamMaxFlightHeight = %@", error);
        } else {
            [DUXStateChangeBroadcaster send:[MaxAltitudeListItemModelState maxAltitudedChange:newHeight]];
            returnValue = DUXMaxAltitudeChangeMaxAltitudeValid;
        }
        resultsBlock(returnValue);
    }];
    
    // Now we need to see what the current return home height is. If it is higher than the new max altidude, make sure it
    // is set to keep under that maximum
    if (self.returnHomeHeight < newHeight) {
        [[DJISDKManager keyManager]  setValue:@(newHeight) forKey:self.returnHomeHeightKey withCompletion:^(NSError * _Nullable error) {
            DUXMaxAltitudeChange returnValue = DUXMaxAltitudeChangeMaxAltitudeValid;
            if (error) {
                returnValue = DUXMaxAltitudeChangeUnableToChangeReturnHomeAltitude;
                NSLog(@"error setting DJIFlightControllerParamGoHomeHeightInMeters = %@", error);
            }
            resultsBlock(returnValue);
        }];
    }
}

@end

@implementation MaxAltitudeListItemModelState

+ (instancetype)maxAltitudedChange:(NSInteger)maxAltitude {
    return [[self alloc] initWithKey:@"maxAltitudedChange" number:@(maxAltitude)];
}
 
+ (instancetype)setMaxAltitudeSuccess {
    return [[self alloc] initWithKey:@"setMaxAltitudeSuccess" number:@(YES)];
}

+ (instancetype)setMaxAltitudeFailed:(NSInteger)maxAltitude {
    return [[self alloc] initWithKey:@"setMaxAltitudeFailed" number:@(maxAltitude)];
}

@end
