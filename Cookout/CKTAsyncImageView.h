//
//  AsyncImageView.h
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


#import <UIKit/UIKit.h>
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wobjc-missing-property-synthesis"


extern NSString *const CKTAsyncImageLoadDidFinish;
extern NSString *const CKTAsyncImageLoadDidFail;

extern NSString *const CKTAsyncImageImageKey;
extern NSString *const CKTAsyncImageURLKey;
extern NSString *const CKTAsyncImageCacheKey;
extern NSString *const CKTAsyncImageErrorKey;


@interface CKTAsyncImageLoader : NSObject

+ (CKTAsyncImageLoader *)sharedLoader;
+ (NSCache *)defaultCache;

@property (nonatomic, strong) NSCache *cache;
@property (nonatomic, assign) NSUInteger concurrentLoads;
@property (nonatomic, assign) NSTimeInterval loadingTimeout;

- (void)loadImageWithURL:(NSURL *)URL target:(id)target success:(SEL)success failure:(SEL)failure;
- (void)loadImageWithURL:(NSURL *)URL target:(id)target action:(SEL)action;
- (void)loadImageWithURL:(NSURL *)URL;
- (void)cancelLoadingURL:(NSURL *)URL target:(id)target action:(SEL)action;
- (void)cancelLoadingURL:(NSURL *)URL target:(id)target;
- (void)cancelLoadingURL:(NSURL *)URL;
- (void)cancelLoadingImagesForTarget:(id)target action:(SEL)action;
- (void)cancelLoadingImagesForTarget:(id)target;
- (NSURL *)URLForTarget:(id)target action:(SEL)action;
- (NSURL *)URLForTarget:(id)target;

@end


@interface UIImageView(CKTAsyncImageView)

@property (nonatomic, strong) NSURL *imageURL;

@end


@interface CKTAsyncImageView : UIImageView

@property (nonatomic, assign) BOOL showActivityIndicator;
@property (nonatomic, assign) UIActivityIndicatorViewStyle activityIndicatorStyle;
@property (nonatomic, assign) NSTimeInterval crossfadeDuration;

@end


#pragma GCC diagnostic pop
