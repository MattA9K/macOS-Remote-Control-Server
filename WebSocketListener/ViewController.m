//
//  ViewController.m
//  WebSocketListener
//
//  Created by Matt Andrzejczuk on 8/17/20.
//  Copyright © 2020 A9K. All rights reserved.
//

#include <AudioToolbox/AudioToolbox.h>
#import "ViewController.h"
#import "AKInterfaceHTTP.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [AKInterfaceHTTP makeRequest];
    
    self.socketMsgLog = [[NSMutableArray alloc]
                         init];
    [self runTests_Mouse];
    [self setupWebSocket];
//    [self sendToMessageStack:@"HELLO"];
}


-(void) runTests_Mouse {
    /// Todo: Change this so that all commands arent 5 chars long.
    NSRange range_command = NSMakeRange(0, 5);
    NSString* rawMessage1 = @"MOUSE:1920,1080";
    
    NSString *cmdSubstr = [rawMessage1 substringWithRange:range_command];
    
    printf("\nHERE IS THE COMMAND NAME:\n");
    printf([cmdSubstr UTF8String]);
    printf("\n");
    
    NSUInteger i = rawMessage1.length - 6;
    NSRange range_arguments = NSMakeRange(6, i);
    NSString* cmdArgs = [rawMessage1 substringWithRange:range_arguments];
    
    printf("\n\n");
    printf([cmdArgs UTF8String]);
    printf("\n");
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}


- (void)setupWebSocket {
    
    NSString* host = @"ws://127.0.0.1:8888";
    NSString* URI = @"/ws/foobar";
    NSString* getParams = @"?subscribe-broadcast&publish-broadcast&echo";
    NSString* fullURI = [NSString stringWithFormat:@"%@%@%@", host, URI, getParams];
    
    NSURL *socketURL = [[NSURL alloc]
                        initWithString:
                        fullURI];
    NSURLRequest *socketURLRequest = [[NSURLRequest alloc] initWithURL:socketURL];
    self.socketClient = [[SRWebSocket alloc]
                         initWithURLRequest:socketURLRequest];
    self.socketClient.delegate = self;
    [self.socketClient open];
}


- (IBAction)didPressBtnSend:(NSButton *)sender {
    AudioServicesPlaySystemSound (5);
    NSString* msg = self.txtComposeMsg.stringValue;
    self.txtComposeMsg.stringValue = @"";
    [self.socketClient send:msg];
}
/// 1004
/// 1112
/// 1200
/// 1267
/// 1400


- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    NSLog(@"webSocketDidOpen");
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessageWithString:(NSString *)string{
    NSLog(@"didReceiveMessageWithString");
}

-(void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSString *msg = [[NSString alloc] initWithFormat:@"%@", message];
    
    BOOL isAudioCommand = [msg hasPrefix:@"AUDIO:"];
    BOOL isMouseCommand = [msg hasPrefix:@"MOUSE:"];
    BOOL isLeftClickCommand = [msg hasPrefix:@"LCLIK:"];
    BOOL isRightClickCommand = [msg hasPrefix:@"RCLIK:"];
    ///CLICK:Left
    
    if ([msg isEqualToString:@"--heartbeat--"]) {
            // ignore for now.
        self.lblConnectionStatus.stringValue = @"Connected To WebSocket";
        printf(" ❤️ ");
    }
    else if ([msg isEqualToString:@"XXX"]) {
         [self sendToMessageStack:msg];
    }
    else if ([msg isEqualToString:@"SOUND1"]) {
        [self sendToMessageStack:msg];
    }
    else if (isAudioCommand) {
        printf("🔊");
        NSRange range;
        
        if (msg.length == 7)
            range = NSMakeRange(6, 1);
        else if (msg.length == 8)
            range = NSMakeRange(6, 2);
        else if (msg.length == 9)
            range = NSMakeRange(6, 3);
        else if (msg.length == 10)
            range = NSMakeRange(6, 4);
        else if (msg.length == 11)
            range = NSMakeRange(6, 5);
        else if (msg.length == 12)
            range = NSMakeRange(6, 6);
        else
            range = NSMakeRange(6, 7);
        
        int i = [[msg substringWithRange:range] intValue];
        
        AudioServicesPlaySystemSound(i);
        [self sendToMessageStack:[msg substringWithRange:range]];
    }
    else if (isMouseCommand) {
        
        NSUInteger i = msg.length - 6;
        NSRange range_arguments = NSMakeRange(6, i);
        NSString* cmdArgs = [msg substringWithRange:range_arguments];
        
        NSString* args = [NSString stringWithFormat: @"m:%@", cmdArgs];
        
        NSPipe *pipe = [NSPipe pipe];
        NSFileHandle *file = pipe.fileHandleForReading;
        NSTask *task = [[NSTask alloc] init];
        task.launchPath = @"/usr/local/bin/cliclick";
        task.arguments = @[args];
        task.standardOutput = pipe;
        [task launch];
        NSData *data = [file readDataToEndOfFile];
        [file closeFile];
        NSString *grepOutput = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
        [self sendToMessageStack:grepOutput];
    }
    else if (isLeftClickCommand) {
        NSUInteger i = msg.length - 6;
        NSRange range_arguments = NSMakeRange(6, i);
        NSString* cmdArgs = [msg substringWithRange:range_arguments];
        
        NSString* args = [NSString stringWithFormat: @"c:%@", cmdArgs];
        
        NSPipe *pipe = [NSPipe pipe];
        NSFileHandle *file = pipe.fileHandleForReading;
        NSTask *task = [[NSTask alloc] init];
        task.launchPath = @"/usr/local/bin/cliclick";
        task.arguments = @[args];
        task.standardOutput = pipe;
        [task launch];
        NSData *data = [file readDataToEndOfFile];
        [file closeFile];
        NSString *grepOutput = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
        [self sendToMessageStack:grepOutput];
    }
    else if (isRightClickCommand) {
        NSUInteger i = msg.length - 6;
        NSRange range_arguments = NSMakeRange(6, i);
        NSString* cmdArgs = [msg substringWithRange:range_arguments];
        
        NSString* args = [NSString stringWithFormat: @"rc:%@", cmdArgs];
        
        NSPipe *pipe = [NSPipe pipe];
        NSFileHandle *file = pipe.fileHandleForReading;
        NSTask *task = [[NSTask alloc] init];
        task.launchPath = @"/usr/local/bin/cliclick";
        task.arguments = @[args];
        task.standardOutput = pipe;
        [task launch];
        NSData *data = [file readDataToEndOfFile];
        [file closeFile];
        NSString *grepOutput = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
        [self sendToMessageStack:grepOutput];
    }
    else {
        [self sendToMessageStack:msg];
    }
    
}

/// TELEPHONE DIALS:
//1211🔲
//1200🔲

- (void)sendToMessageStack:(NSString *)msg {
    [self.socketMsgLog addObject:msg];
    self.txtSocketMsgs.string = @"";
    NSMutableString* contents = [[NSMutableString alloc] initWithString:@""];
    for (NSString* s in self.socketMsgLog) {
        [contents appendString:
         [NSString stringWithFormat:
          @"%@🔲\n", s]];
    }
    self.txtSocketMsgs.string = [NSString stringWithFormat:@"%@", contents];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessageWithData:(NSData *)data{
    NSLog(@"didReceiveMessageWithData");
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError");
}
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(nullable NSString *)reason wasClean:(BOOL)wasClean{
    NSLog(@"didCloseWithCode");
}

@end
