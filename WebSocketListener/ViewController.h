//
//  ViewController.h
//  WebSocketListener
//
//  Created by Matt Andrzejczuk on 8/17/20.
//  Copyright © 2020 A9K. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SocketRocket/SRWebSocket.h>

@interface ViewController : NSViewController<SRWebSocketDelegate>

@property (strong) IBOutlet NSTextField *lblConnectionStatus;
@property (strong) IBOutlet NSButtonCell *btnConnect;
@property(nonatomic, retain) SRWebSocket *socketClient;
@property (strong) IBOutlet NSTextView *txtSocketMsgs;
@property (strong) IBOutlet NSTextField *txtComposeMsg;

@property(nonatomic, retain) NSMutableArray *socketMsgLog;

@end

