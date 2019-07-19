//
//  AppStatusBarEvents.m
//
//  Created by dyf on 16/6/30.
//  Copyright © 2016年 dyf. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "AppStatusBarEvents.h"
#import "AppUtils.h"

@implementation AppStatusBarEvents

+ (void)help {
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    
    NSString *title = [NSString stringWithFormat:@"Technical Support"];
    NSString *message = [NSString stringWithFormat:@"@Author: %@", infoDict[@"Author"]];
    message = [message stringByAppendingString:@"\n"];
    message = [message stringByAppendingFormat:@"@Email: %@", infoDict[@"Email"]];
    
    [AppUtils showAlert:nil style:NSWarningAlertStyle title:title message:message buttonTitles:@[@"OK"] completionHandler:nil];
}

@end
