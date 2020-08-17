//
//  AKInterfaceHTTP.m
//  WebSocketListener
//
//  Created by Matt Andrzejczuk on 8/17/20.
//  Copyright © 2020 A9K. All rights reserved.
//

#import "AKInterfaceHTTP.h"

@implementation AKInterfaceHTTP

+ (void)makeRequest {
        // 1
    NSString *dataUrl = @"http://krogoth.one/api/__ExamplesFruit/";
    NSURL *url = [NSURL URLWithString:dataUrl];
    
        // 2
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
                                          dataTaskWithURL:url
                                          completionHandler:
                                          ^
                                          (NSData *data, NSURLResponse *response, NSError *error) {
            // 4 handle response:
        NSString *responseString = [[NSString alloc] initWithData:data
                                                         encoding:NSUTF8StringEncoding];
        NSError *e = nil;
        NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options: NSJSONReadingMutableContainers
                                                               error: &e];
        
        NSLog(@"GOT RESPONSE: ");
        NSLog(@"JSON: %@", JSON);
        
        NSString *jsonAsStr = [NSString stringWithFormat:@"%@", JSON];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            printf("\n\n");
            printf([jsonAsStr UTF8String]);
            printf("\n");
        });
        
        if (error != NULL) {
            NSLog(@"ERROS: %@", error);
        }
    }];
    
        // 3
    [downloadTask resume];
}

@end
