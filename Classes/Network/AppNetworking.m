//
//  AppNetworking.m
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

#import "AppNetworking.h"
#import "AFNetworking.h"

static NSString *const ANGetConstString = @"GET";
static NSString *const ANPostConstString = @"POST";

@implementation AppNetworking

+ (void)allowInvalidCertificates:(BOOL)allowed {
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
	manager.securityPolicy.allowInvalidCertificates = allowed; //not recommended for production
}

- (NSMutableURLRequest *)requestWithMethod:(ANMethod)method URLString:(NSString *)URLString parameters:(id)parameters {
	return [self requestWithMethod:method URLString:URLString parameters:parameters timeoutInterval:0];
}

- (NSMutableURLRequest *)requestWithMethod:(ANMethod)method URLString:(NSString *)URLString parameters:(id)parameters timeoutInterval:(NSTimeInterval)timeoutInterval {
    NSString *ANMethodString = nil;
    switch (method) {
        case ANMethodGET:
            ANMethodString = ANGetConstString;
            break;
        case ANMethodPOST:
            ANMethodString = ANPostConstString;
            break;
        default:
            ANMethodString = ANGetConstString;
            break;
    }
    NSError *error = nil;
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    if (timeoutInterval > 0) {
        serializer.timeoutInterval = timeoutInterval;
    }
    NSMutableURLRequest *request = [serializer requestWithMethod:ANMethodString URLString:URLString parameters:parameters error:&error];
    if (!error) {
        return request;
    }
    return nil;
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(ANCallbackHandler)completionHandler {
	return [self dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:completionHandler];
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request uploadProgress:(ANUploadProgressBlock)uploadProgressBlock downloadProgress:(ANDownloadProgressBlock)downloadProgressBlock completionHandler:(ANCallbackHandler)completionHandler {
	NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
	AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
	NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
		if (uploadProgressBlock) {
			uploadProgressBlock(uploadProgress);
		}
	} downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
		if (downloadProgressBlock) {
			downloadProgressBlock(downloadProgress);
		}
	} completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
		if (completionHandler) {
			completionHandler(response, responseObject, error);
		}
	}];
	[dataTask resume];
	return dataTask;
}

- (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request fromFile:(NSURL *)fileURL progress:(ANUploadProgressBlock)uploadProgressBlock completionHandler:(ANCallbackHandler)completionHandler {
	NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
	AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
	NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:fileURL progress:^(NSProgress * _Nonnull uploadProgress) {
		if (uploadProgressBlock) {
			uploadProgressBlock(uploadProgress);
		}
	} completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
		if (completionHandler) {
			completionHandler(response, responseObject, error);
		}
	}];
	[uploadTask resume];
	return uploadTask;
}

- (NSURLSessionDownloadTask *)downloadTaskWithRequest:(NSURLRequest *)request progress:(ANDownloadProgressBlock)downloadProgressBlock destination:(ANDestinationBlock)destination completionHandler:(ANCallbackHandler)completionHandler {
	NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
	AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
	NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
		if (downloadProgressBlock) {
			downloadProgressBlock(downloadProgress);
		}
	} destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
		if (destination) {
			return destination(targetPath, response);
		}
		return nil;
	} completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
		if (completionHandler) {
			completionHandler(response, filePath, error);
		}
	}];
	[downloadTask resume];
	return downloadTask;
}

@end
