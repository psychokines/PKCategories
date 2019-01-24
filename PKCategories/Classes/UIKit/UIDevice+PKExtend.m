//
//  UIDevice+PKExtend.m
//  PKCategories
//
//  Created by jiaohong on 2018/10/29.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import "UIDevice+PKExtend.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <sys/sysctl.h>
#import <mach/mach_host.h>

typedef NS_ENUM(NSUInteger, PKScreenType) {
    PKScreenTypeUndefined   = 0,
    PKScreenTypeIpadClassic = 1, // iPad 1/2/mini
    PKScreenTypeIpadRetina  = 2, // iPad 3以上/mini2以上
    PKScreenTypeIpadPro     = 3, // iPad Pro
    PKScreenTypeIphone4     = 4, // iphone 4/4s
    PKScreenTypeIphone5     = 5, // iphone 5/5c/5s/SE
    PKScreenTypeIphone6     = 6, // iphone 6/6s/7/8
    PKScreenTypeIphone6Plus = 7, // iphone 6p/6sp/7p/8p
    PKScreenTypeIphoneX     = 8, // iphone X/XS
    PKScreenTypeIphoneXR    = 9, // iPhone XR
    PKScreenTypeIphoneXSMax = 10 // iPhone XS Max
};

@implementation UIDevice (PKExtend)

- (PKScreenType)pk_screenType {
    static PKScreenType screenType = PKScreenTypeUndefined;
    
    int scale = [UIScreen mainScreen].scale;
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        if (CGSizeEqualToSize(size, CGSizeMake(1024, 768))) {
            if (scale == 1) {
                screenType = PKScreenTypeIpadClassic;
            } else if (scale == 2) {
                screenType = PKScreenTypeIpadRetina;
            }
        } else if (CGSizeEqualToSize(size, CGSizeMake(1112, 834)) ||
                   CGSizeEqualToSize(size, CGSizeMake(1366, 1024))) {
            screenType = PKScreenTypeIpadPro;
        }
        
        return screenType;
    }
        
    if (CGSizeEqualToSize(size, CGSizeMake(320, 480))) {
        screenType = PKScreenTypeIphone4;
    }
    else if (CGSizeEqualToSize(size, CGSizeMake(320, 568))) {
        screenType = PKScreenTypeIphone5;
    }
    else if (CGSizeEqualToSize(size, CGSizeMake(375, 667))) {
        screenType = PKScreenTypeIphone6;
    }
    else if (CGSizeEqualToSize(size, CGSizeMake(414, 736))) {
        screenType = PKScreenTypeIphone6Plus;
    }
    else if (CGSizeEqualToSize(size, CGSizeMake(375, 812))) {
        screenType = PKScreenTypeIphoneX;
    }
    else if (CGSizeEqualToSize(size, CGSizeMake(414, 896))) {
        
        if ([UIScreen instancesRespondToSelector:@selector(currentMode)]) {
            if (CGSizeEqualToSize(CGSizeMake(828, 1792),
                                  [[UIScreen mainScreen] currentMode].size)) {
                screenType = PKScreenTypeIphoneXR;
            } else if (CGSizeEqualToSize(CGSizeMake(1242, 2688),
                                         [[UIScreen mainScreen] currentMode].size)) {
                screenType = PKScreenTypeIphoneXSMax;
            }
        }
        
    }
    
    return screenType;
}

- (BOOL)pk_isIPhone4 {
    return [self pk_screenType] == PKScreenTypeIphone4;
}

- (BOOL)pk_isIPhone5 {
    return [self pk_screenType] == PKScreenTypeIphone5;
}

- (BOOL)pk_isIPhone6 {
    return [self pk_screenType] == PKScreenTypeIphone6;
}

- (BOOL)pk_isIPhone6p {
    return [self pk_screenType] == PKScreenTypeIphone6Plus;
}

- (BOOL)pk_isIPhoneX {
    return [self pk_screenType] == PKScreenTypeIphoneX;
}

- (BOOL)pk_isIPhoneXR {
    return [self pk_screenType] == PKScreenTypeIphoneXR;
}

- (BOOL)pk_isIPhoneXsMax {
    return [self pk_screenType] == PKScreenTypeIphoneXSMax;
}

+ (double)pk_systemVersion {
    static double version;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        version = [UIDevice currentDevice].systemVersion.doubleValue;
    });
    return version;
}

+ (NSString *)pk_deviceName {
    return [UIDevice currentDevice].name;
}

- (BOOL)pk_isSimulator {
#if TARGET_OS_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

- (BOOL)pk_isPad {
    static dispatch_once_t one;
    static BOOL pad;
    dispatch_once(&one, ^{
        pad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    });
    return pad;
}

- (NSString *)pk_ipAddressWIFI {
    return [self pk_ipAddressWithIfaName:@"en0"];
}

- (NSString *)pk_ipAddressCell {
    return [self pk_ipAddressWithIfaName:@"pdp_ip0"];
}

- (NSString *)pk_ipAddressWithIfaName:(NSString *)name {
    if (name.length == 0) return nil;
    NSString *address = nil;
    struct ifaddrs *addrs = NULL;
    if (getifaddrs(&addrs) == 0) {
        struct ifaddrs *addr = addrs;
        while (addr) {
            if ([[NSString stringWithUTF8String:addr->ifa_name] isEqualToString:name]) {
                sa_family_t family = addr->ifa_addr->sa_family;
                switch (family) {
                    case AF_INET: { // IPv4
                        char str[INET_ADDRSTRLEN] = {0};
                        inet_ntop(family, &(((struct sockaddr_in *)addr->ifa_addr)->sin_addr), str, sizeof(str));
                        if (strlen(str) > 0) {
                            address = [NSString stringWithUTF8String:str];
                        }
                    } break;
                        
                    case AF_INET6: { // IPv6
                        char str[INET6_ADDRSTRLEN] = {0};
                        inet_ntop(family, &(((struct sockaddr_in6 *)addr->ifa_addr)->sin6_addr), str, sizeof(str));
                        if (strlen(str) > 0) {
                            address = [NSString stringWithUTF8String:str];
                        }
                    }
                        
                    default: break;
                }
                if (address) break;
            }
            addr = addr->ifa_next;
        }
    }
    freeifaddrs(addrs);
    return address;
}

+ (BOOL)pk_hasCamera {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

+ (NSUInteger)pk_getSysInfo:(uint)typeSpecifier {
    size_t size = sizeof(int);
    int result;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &result, &size, NULL, 0);
    return (NSUInteger)result;
}

+ (NSUInteger)pk_totalMemoryBytes {
    return [self pk_getSysInfo:HW_PHYSMEM];
}

+ (NSUInteger)pk_freeMemoryBytes {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t pagesize;
    vm_statistics_data_t vm_stat;
    host_page_size(host_port, &pagesize);
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        return 0;
    }
    NSUInteger mem_free = vm_stat.free_count * pagesize;
    return mem_free;
}

@end
