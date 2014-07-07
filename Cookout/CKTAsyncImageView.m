//
//  AsyncImageView.m
//
//  Version 1.5.1
//
//  Created by Nick Lockwood on 03/04/2011.
//  Copyright (c) 2011 Charcoal Design
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/nicklockwood/AsyncImageView
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

#import "CKTAsyncImageView.h"
#import <objc/message.h>
#import <QuartzCore/QuartzCore.h>


#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif


NSString *const CKTAsyncImageLoadDidFinish = @"CKTAsyncImageLoadDidFinish";
NSString *const CKTAsyncImageLoadDidFail = @"CKTAsyncImageLoadDidFail";

NSString *const CKTAsyncImageImageKey = @"image";
NSString *const CKTAsyncImageURLKey = @"URL";
NSString *const CKTAsyncImageCacheKey = @"cache";
NSString *const CKTAsyncImageErrorKey = @"error";


@interface CKTAsyncImageConnection : NSObject

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) NSCache *cache;
@property (nonatomic, strong) id target;
@property (nonatomic, assign) SEL success;
@property (nonatomic, assign) SEL failure;
@property (nonatomic, getter = isLoading) BOOL loading;
@property (nonatomic, getter = isCancelled) BOOL cancelled;

- (CKTAsyncImageConnection *)initWithURL:(NSURL *)URL
                                cache:(NSCache *)cache
							   target:(id)target
							  success:(SEL)success
							  failure:(SEL)failure;

- (void)start;
- (void)cancel;
- (BOOL)isInCache;

@end


@implementation CKTAsyncImageConnection

- (CKTAsyncImageConnection *)initWithURL:(NSURL *)URL
                                cache:(NSCache *)cache
							   target:(id)target
							  success:(SEL)success
							  failure:(SEL)failure
{
    if ((self = [self init])) {
        self.URL = URL;
        self.cache = cache;
        self.target = target;
        self.success = success;
        self.failure = failure;
    }
    return self;
}

- (UIImage *)cachedImage
{
    if ([self.URL isFileURL]) {
		NSString *path = [[self.URL absoluteURL] path];
        NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
		if ([path hasPrefix:resourcePath]) {
			return [UIImage imageNamed:[path substringFromIndex:[resourcePath length]]];
		}
	}
    return [self.cache objectForKey:self.URL];
}

- (BOOL)isInCache
{
    return [self cachedImage] != nil;
}

- (void)loadFailedWithError:(NSError *)error
{
	self.loading = NO;
	self.cancelled = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:CKTAsyncImageLoadDidFail
                                                        object:self.target
                                                      userInfo:@{CKTAsyncImageURLKey:self.URL,
                                                                 CKTAsyncImageErrorKey:error}];
}

- (void)cacheImage:(UIImage *)image
{
	if (!self.cancelled) {
        if (image && self.URL) {
            BOOL storeInCache = YES;
            if ([self.URL isFileURL]) {
                if ([[[self.URL absoluteURL] path] hasPrefix:[[NSBundle mainBundle] resourcePath]]) {
                    // Do not store in cache.
                    storeInCache = NO;
                }
            }
            if (storeInCache) {
                [self.cache setObject:image forKey:self.URL];
            }
        }
        
		NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
										 image, CKTAsyncImageImageKey,
										 self.URL, CKTAsyncImageURLKey,
										 nil];
		if (self.cache) {
			userInfo[CKTAsyncImageCacheKey] = self.cache;
		}
        
		self.loading = NO;
		[[NSNotificationCenter defaultCenter] postNotificationName:CKTAsyncImageLoadDidFinish
															object:self.target
														  userInfo:[userInfo copy]];
	} else {
		self.loading = NO;
		self.cancelled = NO;
	}
}

- (void)processDataInBackground:(NSData *)data
{
	@synchronized ([self class]) {
		if (!self.cancelled) {
            UIImage *image = [[UIImage alloc] initWithData:data];
			if (image) {
                // Redraw to prevent deferred decompression.
                UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
                [image drawAtPoint:CGPointZero];
                image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
				// Add to cache (may be cached already but it doesn't matter).
                [self performSelectorOnMainThread:@selector(cacheImage:)
                                       withObject:image
                                    waitUntilDone:YES];
			} else {
                @autoreleasepool {
                    NSError *error = [NSError errorWithDomain:@"AsyncImageLoader"
                                                         code:0
                                                     userInfo:@{NSLocalizedDescriptionKey:@"Invalid image data"}];
                    [self performSelectorOnMainThread:@selector(loadFailedWithError:)
                                           withObject:error waitUntilDone:YES];
				}
			}
		} else {
			// Clean up.
			[self performSelectorOnMainThread:@selector(cacheImage:)
								   withObject:nil
								waitUntilDone:YES];
		}
	}
}

- (void)connection:(__unused NSURLConnection *)connection didReceiveResponse:(__unused NSURLResponse *)response
{
    self.data = [NSMutableData data];
}

- (void)connection:(__unused NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Add data.
    [self.data appendData:data];
}

- (void)connectionDidFinishLoading:(__unused NSURLConnection *)connection
{
    [self performSelectorInBackground:@selector(processDataInBackground:) withObject:self.data];
    self.connection = nil;
    self.data = nil;
}

- (void)connection:(__unused NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.connection = nil;
    self.data = nil;
    [self loadFailedWithError:error];
}

- (void)start
{
    if (self.loading && !self.cancelled) {
        return;
    }
    
	// Begin loading.
	self.loading = YES;
	self.cancelled = NO;
    
    // Check for nil URL.
    if (self.URL == nil) {
        [self cacheImage:nil];
        return;
    }
    
    // Check for cached image.
	UIImage *image = [self cachedImage];
    if (image) {
        // Add to cache (cached already but it doesn't matter).
        [self performSelectorOnMainThread:@selector(cacheImage:)
                               withObject:image
                            waitUntilDone:NO];
        return;
    }
    
    // Begin load.
    NSURLRequest *request = [NSURLRequest requestWithURL:self.URL
                                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                         timeoutInterval:[CKTAsyncImageLoader sharedLoader].loadingTimeout];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [self.connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [self.connection start];
}

- (void)cancel
{
	self.cancelled = YES;
    [self.connection cancel];
    self.connection = nil;
    self.data = nil;
}

@end


@interface CKTAsyncImageLoader ()

@property (nonatomic, strong) NSMutableArray *connections;

@end


@implementation CKTAsyncImageLoader

+ (CKTAsyncImageLoader *)sharedLoader
{
	static CKTAsyncImageLoader *sharedInstance = nil;
	if (sharedInstance == nil) {
		sharedInstance = [(CKTAsyncImageLoader *)[self alloc] init];
	}
	return sharedInstance;
}

+ (NSCache *)defaultCache
{
    static NSCache *sharedCache = nil;
	if (sharedCache == nil) {
		sharedCache = [[NSCache alloc] init];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(__unused NSNotification *note) {
            
            [sharedCache removeAllObjects];
        }];
	}
	return sharedCache;
}

- (CKTAsyncImageLoader *)init
{
	if ((self = [super init])) {
        self.cache = [[self class] defaultCache];
        _concurrentLoads = 2;
        _loadingTimeout = 60.0;
		_connections = [[NSMutableArray alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(imageLoaded:)
													 name:CKTAsyncImageLoadDidFinish
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(imageFailed:)
													 name:CKTAsyncImageLoadDidFail
												   object:nil];
	}
	return self;
}

- (void)updateQueue
{
    //start connections
    NSUInteger count = 0;
    for (CKTAsyncImageConnection *connection in self.connections) {
        if (![connection isLoading]) {
            if ([connection isInCache]) {
                [connection start];
            } else if (count < self.concurrentLoads) {
                count ++;
                [connection start];
            }
        }
    }
}

- (void)imageLoaded:(NSNotification *)notification
{
    // Complete connections for URL.
    NSURL *URL = (notification.userInfo)[CKTAsyncImageURLKey];
    for (NSInteger i = (NSInteger)[self.connections count] - 1; i >= 0; i--) {
        CKTAsyncImageConnection *connection = self.connections[(NSUInteger)i];
        if (connection.URL == URL || [connection.URL isEqual:URL]) {
            // Cancel earlier connections for same target/action.
            for (NSInteger j = i - 1; j >= 0; j--) {
                CKTAsyncImageConnection *earlier = self.connections[(NSUInteger)j];
                if (earlier.target == connection.target &&
                    earlier.success == connection.success) {
                    [earlier cancel];
                    [self.connections removeObjectAtIndex:(NSUInteger)j];
                    i--;
                }
            }
            
            // Cancel connection (in case it's a duplicate).
            [connection cancel];
            
            // Perform action.
			UIImage *image = (notification.userInfo)[CKTAsyncImageImageKey];
            ((void (*)(id, SEL, id, id))objc_msgSend)(connection.target, connection.success, image, connection.URL);
        
            // Remove from queue.
            [self.connections removeObjectAtIndex:(NSUInteger)i];
        }
    }
    
    // Update the queue.
    [self updateQueue];
}

- (void)imageFailed:(NSNotification *)notification
{
    // Remove connections for URL.
    NSURL *URL = (notification.userInfo)[CKTAsyncImageURLKey];
    for (NSInteger i = (NSInteger)[self.connections count] - 1; i >= 0; i--) {
        CKTAsyncImageConnection *connection = self.connections[(NSUInteger)i];
        if ([connection.URL isEqual:URL]) {
            // Cancel connection (in case it's a duplicate).
            [connection cancel];
            
            // Perform failure action.
            if (connection.failure) {
                NSError *error = (notification.userInfo)[CKTAsyncImageErrorKey];
                ((void (*)(id, SEL, id, id))objc_msgSend)(connection.target, connection.failure, error, URL);
            }
            
            // Remove from queue.
            [self.connections removeObjectAtIndex:(NSUInteger)i];
        }
    }
    
    // Update the queue.
    [self updateQueue];
}

- (void)loadImageWithURL:(NSURL *)URL target:(id)target success:(SEL)success failure:(SEL)failure
{
    // Check cache.
    UIImage *image = [self.cache objectForKey:URL];
    if (image) {
        [self cancelLoadingImagesForTarget:self action:success];
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                ((void (*)(id, SEL, id, id))objc_msgSend)(target, success, image, URL);
            });
        }
        return;
    }
    
    // Create new connection.
    CKTAsyncImageConnection *connection =
        [[CKTAsyncImageConnection alloc] initWithURL:URL
                                               cache:self.cache
                                              target:target
                                             success:success
                                             failure:failure];
    BOOL added = NO;
    for (NSUInteger i = 0; i < [self.connections count]; i++) {
        CKTAsyncImageConnection *existingConnection = self.connections[i];
        if (!existingConnection.loading) {
            [self.connections insertObject:connection atIndex:i];
            added = YES;
            break;
        }
    }
    if (!added) {
        [self.connections addObject:connection];
    }
    
    [self updateQueue];
}

- (void)loadImageWithURL:(NSURL *)URL target:(id)target action:(SEL)action
{
    [self loadImageWithURL:URL target:target success:action failure:NULL];
}

- (void)loadImageWithURL:(NSURL *)URL
{
    [self loadImageWithURL:URL target:nil success:NULL failure:NULL];
}

- (void)cancelLoadingURL:(NSURL *)URL target:(id)target action:(SEL)action
{
    for (NSInteger i = (NSInteger)[self.connections count] - 1; i >= 0; i--) {
        CKTAsyncImageConnection *connection = self.connections[(NSUInteger)i];
        if ([connection.URL isEqual:URL]
                && connection.target == target
                && connection.success == action) {
            [connection cancel];
            [self.connections removeObjectAtIndex:(NSUInteger)i];
        }
    }
}

- (void)cancelLoadingURL:(NSURL *)URL target:(id)target
{
    for (NSInteger i = (NSInteger)[self.connections count] - 1; i >= 0; i--) {
        CKTAsyncImageConnection *connection = self.connections[(NSUInteger)i];
        if ([connection.URL isEqual:URL] && connection.target == target) {
            [connection cancel];
            [self.connections removeObjectAtIndex:(NSUInteger)i];
        }
    }
}

- (void)cancelLoadingURL:(NSURL *)URL
{
    for (NSInteger i = (NSInteger)[self.connections count] - 1; i >= 0; i--) {
        CKTAsyncImageConnection *connection = self.connections[(NSUInteger)i];
        if ([connection.URL isEqual:URL]) {
            [connection cancel];
            [self.connections removeObjectAtIndex:(NSUInteger)i];
        }
    }
}

- (void)cancelLoadingImagesForTarget:(id)target action:(SEL)action
{
    for (NSInteger i = (NSInteger)[self.connections count] - 1; i >= 0; i--) {
        CKTAsyncImageConnection *connection = self.connections[(NSUInteger)i];
        if (connection.target == target && connection.success == action) {
            [connection cancel];
        }
    }
}

- (void)cancelLoadingImagesForTarget:(id)target
{
    for (NSInteger i = (NSInteger)[self.connections count] - 1; i >= 0; i--) {
        CKTAsyncImageConnection *connection = self.connections[(NSUInteger)i];
        if (connection.target == target) {
            [connection cancel];
        }
    }
}

- (NSURL *)URLForTarget:(id)target action:(SEL)action
{
    //return the most recent image URL assigned to the target for the given action
    //this is not neccesarily the next image that will be assigned
    for (NSInteger i = (NSInteger)[self.connections count] - 1; i >= 0; i--) {
        CKTAsyncImageConnection *connection = self.connections[(NSUInteger)i];
        if (connection.target == target && connection.success == action) {
            return connection.URL;
        }
    }
    return nil;
}

- (NSURL *)URLForTarget:(id)target
{
    //return the most recent image URL assigned to the target
    //this is not neccesarily the next image that will be assigned
    for (NSInteger i = (NSInteger)[self.connections count] - 1; i >= 0; i--) {
        CKTAsyncImageConnection *connection = self.connections[(NSUInteger)i];
        if (connection.target == target) {
            return connection.URL;
        }
    }
    return nil;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end


@implementation UIImageView(CKTAsyncImageView)

- (void)setImageURL:(NSURL *)imageURL
{
	[[CKTAsyncImageLoader sharedLoader] loadImageWithURL:imageURL
                                                  target:self
                                                  action:@selector(setImage:)];
}

- (NSURL *)imageURL
{
	return [[CKTAsyncImageLoader sharedLoader] URLForTarget:self action:@selector(setImage:)];
}

@end


@interface CKTAsyncImageView ()

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end


@implementation CKTAsyncImageView

- (void)setUp
{
	self.showActivityIndicator = (self.image == nil);
	self.activityIndicatorStyle = UIActivityIndicatorViewStyleGray;
	self.crossfadeDuration = 0.4;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [self setUp];
    }
    return self;
}

- (void)setImageURL:(NSURL *)imageURL
{
    UIImage *image = [[CKTAsyncImageLoader sharedLoader].cache objectForKey:imageURL];
    if (image) {
        self.image = image;
        return;
    }
    super.imageURL = imageURL;
    if (self.image) {
        self.image = nil;
    }
    if (self.showActivityIndicator && imageURL) {
        if (self.activityView == nil) {
            self.activityView = [[UIActivityIndicatorView alloc]
                                 initWithActivityIndicatorStyle:self.activityIndicatorStyle];
            self.activityView.hidesWhenStopped = YES;
            self.activityView.center =
                    CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f);
            self.activityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
            [self addSubview:self.activityView];
        }
        [self.activityView startAnimating];
    }
}

- (void)setActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style
{
	_activityIndicatorStyle = style;
	[self.activityView removeFromSuperview];
	self.activityView = nil;
}

- (void)setImage:(UIImage *)image
{
    if (!super.image && image && self.crossfadeDuration) {
        // Jump through a few hoops to avoid QuartzCore framework dependency.
        CAAnimation *animation = [NSClassFromString(@"CATransition") animation];
        [animation setValue:@"kCATransitionFade" forKey:@"type"];
        animation.duration = self.crossfadeDuration;
        [self.layer addAnimation:animation forKey:nil];
    }
    super.image = image;
    [self.activityView stopAnimating];
}

- (void)dealloc
{
    [[CKTAsyncImageLoader sharedLoader] cancelLoadingURL:self.imageURL target:self];
}

@end