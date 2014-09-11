#import <Cordova/CDV.h>
#import "TPAACAudioConverter.h"

@enum ConverterState : int
{
    InProgress = 0,
    Complete = 1
}

@interface WavToAacConverter : CDVPlugin<TPAACAudioConverterDelegate>

- (void) convert: (CDVInvokedUrlCommand*) command;

- (void) release: (CDVInvokedUrlCommand*) command;

@end

