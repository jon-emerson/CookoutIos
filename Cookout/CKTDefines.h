//
//  CKTDefines.h
//  Cookout
//
//  Created by Jonathan Emerson on 6/26/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#define UIColorFromRGB(rgbValue) \
        [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                        green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                         blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

