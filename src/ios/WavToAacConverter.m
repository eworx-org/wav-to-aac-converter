#import "WavToAacConverter.h"

@implementation WavToAacConverter
{
    TPAACAudioConverter* _audioConverter;
    NSString* _currentCommandCallbackId;
}

- (void) convert: (CDVInvokedUrlCommand*) command
{    
    if (_currentCommandCallbackId != nil)
    {
        NSString* errorMessage = @"Audio conversion ongoing, request is rejected.";
        [self sendErrorResult:command.callbackId withMessage:errorMessage];
        return;
    }
    
    if ( ![TPAACAudioConverter AACConverterAvailable] ) 
    {
        NSString* errorMessage = @"Audio conversion is not supported on this device.";
        [self sendErrorResult:command.callbackId withMessage:errorMessage];
        return;
    }
    
    NSString* sourcePath = (NSString*)[command.arguments objectAtIndex:0];
    NSString* destinationPath = (NSString*)[command.arguments objectAtIndex:1];
    _currentCommandCallbackId = command.callbackId;
    _audioConverter = [[TPAACAudioConverter alloc] initWithDelegate:self source:sourcePath destination:destinationPath];
    [_audioConverter start];
}

- (void) dispose: (CDVInvokedUrlCommand*) command
{
    [self clearEncodingState];
}

- (void) AACAudioConverterDidFinishConversion: (TPAACAudioConverter*) converter
{
    @try
    {
        enum ConverterState state = Complete;
        NSDictionary* result = @{
            @"state" : [NSNumber numberWithInt:(UInt32)state]
        };
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:_currentCommandCallbackId];
    }
    @finally
    {
        [self clearEncodingState];
    }
}

- (void) AACAudioConverter: (TPAACAudioConverter*) converter didFailWithError: (NSError*) error
{
    @try
    {
        [self sendErrorResult:_currentCommandCallbackId withMessage:[error localizedDescription]];
    }
    @finally
    {
        [self clearEncodingState];
    }
}

- (void) AACAudioConverter: (TPAACAudioConverter*) converter didMakeProgress: (double) progress
{
    enum ConverterState state = InProgress;
    double progressPercent = (int)(progress * 10000) / 100.0;
    NSDictionary* result = @{
        @"state" : [NSNumber numberWithInt:(UInt32)state],
        @"progress" : [NSNumber numberWithDouble:progressPercent]
    };
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:_currentCommandCallbackId];
}

- (void) sendErrorResult: (NSString*) cmdCallbackId withMessage: (NSString*) errorMessage
{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:errorMessage];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:cmdCallbackId];
}
    
- (void) clearEncodingState
{
    _audioConverter = nil;
    _currentCommandCallbackId = nil;
}
    
@end

