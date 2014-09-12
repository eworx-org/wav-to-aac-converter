#import <Cordova/CDV.h>
#import "TPAACAudioConverter.h"

enum ConverterState : UInt32
{
    InProgress = 0,
    Complete = 1
};

@interface WavToAacConverter : CDVPlugin<TPAACAudioConverterDelegate>

- (void) convert: (CDVInvokedUrlCommand*) command;

- (void) dispose: (CDVInvokedUrlCommand*) command;

@end

