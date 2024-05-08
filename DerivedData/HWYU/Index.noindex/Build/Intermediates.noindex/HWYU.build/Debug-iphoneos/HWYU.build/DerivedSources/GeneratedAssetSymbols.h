#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The resource bundle ID.
static NSString * const ACBundleID AC_SWIFT_PRIVATE = @"com.iyungui.HYE";

/// The "mainColor" asset catalog color resource.
static NSString * const ACColorNameMainColor AC_SWIFT_PRIVATE = @"mainColor";

/// The "image01" asset catalog image resource.
static NSString * const ACImageNameImage01 AC_SWIFT_PRIVATE = @"image01";

/// The "image02" asset catalog image resource.
static NSString * const ACImageNameImage02 AC_SWIFT_PRIVATE = @"image02";

/// The "image03" asset catalog image resource.
static NSString * const ACImageNameImage03 AC_SWIFT_PRIVATE = @"image03";

/// The "image04" asset catalog image resource.
static NSString * const ACImageNameImage04 AC_SWIFT_PRIVATE = @"image04";

/// The "image05" asset catalog image resource.
static NSString * const ACImageNameImage05 AC_SWIFT_PRIVATE = @"image05";

/// The "image06" asset catalog image resource.
static NSString * const ACImageNameImage06 AC_SWIFT_PRIVATE = @"image06";

/// The "image07" asset catalog image resource.
static NSString * const ACImageNameImage07 AC_SWIFT_PRIVATE = @"image07";

#undef AC_SWIFT_PRIVATE
