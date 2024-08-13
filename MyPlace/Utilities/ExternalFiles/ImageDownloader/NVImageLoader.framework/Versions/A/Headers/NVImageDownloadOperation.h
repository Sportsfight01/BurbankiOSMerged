//
//  NVImageDownloadOperation.h
//  NVImageLoad
//
//  Created by NARAYANA-IOS on 03/07/15.
//  Copyright (c) 2015 NARAYANA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NVImageOperation.h"
#import "NVImageDownloader.h"


extern NSString *const NVImageLoadDownloadStartNotification;
extern NSString *const NVImageLoadDownloadReceiveResponseNotification;
extern NSString *const NVImageLoadDownloadStopNotification;
extern NSString *const NVImageLoadDownloadFinishNotification;


@interface NVImageDownloadOperation : NSOperation <NVImageOperation>


/**
 * The request used by the operation's connection.
 */
@property (strong, nonatomic, readonly) NSURLRequest *request;


@property (assign, nonatomic) BOOL shouldDecompressImages;

/**
 * Whether the URL connection should consult the credential storage for authenticating the connection. `YES` by default.
 *
 * This is the value that is returned in the `NSURLConnectionDelegate` method `-connectionShouldUseCredentialStorage:`.
 */
@property (nonatomic, assign) BOOL shouldUseCredentialStorage;

/**
 * The credential used for authentication challenges in `-connection:didReceiveAuthenticationChallenge:`.
 *
 * This will be overridden by any shared credentials that exist for the username or password of the request URL, if present.
 */
@property (nonatomic, strong) NSURLCredential *credential;

/**
 * The NVImageLoadDownloaderOptions for the receiver.
 */
@property (assign, nonatomic, readonly) NVImageLoadDownloaderOptions options;

/**
 * The expected size of data.
 */
@property (assign, nonatomic) NSInteger expectedSize;

/**
 * The response returned by the operation's connection.
 */
@property (strong, nonatomic) NSURLResponse *response;

/**
 *  Initializes a `NVImageDownloadOperation` object
 *
 *  @see NVImageDownloadOperation
 *
 *  @param request        the URL request
 *  @param options        downloader options
 *  @param progressBlock  the block executed when a new chunk of data arrives.
 *                        @note the progress block is executed on a background queue
 *  @param completedBlock the block executed when the download is done.
 *                        @note the completed block is executed on the main queue for success. If errors are found, there is a chance the block will be executed on a background queue
 *  @param cancelBlock    the block executed if the download (operation) is cancelled
 *
 *  @return the initialized instance
 */
- (id)initWithRequest:(NSURLRequest *)request
              options:(NVImageLoadDownloaderOptions)options
             progress:(NVImageLoadDownloaderProgressBlock)progressBlock
            completed:(NVImageLoadDownloaderCompletedBlock)completedBlock
            cancelled:(NVImageLoadNoParamsBlock)cancelBlock;


@end
