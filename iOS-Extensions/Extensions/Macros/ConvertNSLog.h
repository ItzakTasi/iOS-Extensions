//
//  ConvertNSLog.h
//  iOS-Extensions
//
//  Created by Itzak Tasi on 12/3/5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef __OPTIMIZE__
# define NSLog(format, ...) NSLog((@"%s [Line %d]\n " format), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
# define SHOW_CLASS_METHOD NSLog(@"%s", __func__)
# define SHOW_CLASS NSLog(@"%@", NSStringFromClass([self class]))
# define SHOW_METHOD NSLog(@"%@", NSStringFromSelector(_cmd))
# define SHOW_LINE NSLog(@"%d", __LINE__)
# define SHOW_RETAIN_COUNT(object) NSLog(@"%d", [object retainCount])
# define SHOW_FUNCTION_LINE NSLog(@"%s[%d]", __PRETTY_FUNCTION__, __LINE__);
#else
# define NSLog(format, ...)
# define SHOW_CLASS_METHOD
# define SHOW_CLASS
# define SHOW_METHOD
# define SHOW_LINE NSLog(@"%d", __LINE__)
# define SHOW_RETAIN_COUNT(object)
# define SHOW_FUNCTION_LINE
#endif