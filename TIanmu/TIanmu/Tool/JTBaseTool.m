//
//  JTBaseTool.m
//  ZXJTBaseFramework
//
//  Created by 你猜我是谁啊 on 2018/11/29.
//  Copyright © 2018 你猜我是谁啊. All rights reserved.
//

#import "JTBaseTool.h"
#import "Reachability.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <NetworkExtension/NetworkExtension.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <sys/ioctl.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <sys/utsname.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

CGFloat _jtCurrentBrightness;
CGFloat _jtCurrentVolume;
@implementation JTBaseTool
+ (NSString *)jt_rspWebAction:(NSString *)action param:(id)param{
    NSDictionary *dic = @{@"action":action,@"param":param};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return json;
}
/**
 * 对象转换成json字符串
 **/
+ (NSString *)jt_transformToJsonWithParam:(id)param{
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return json;
}
/**
 * json字符串转化成对象
 **/
+ (id)jt_transformToParamWithJson:(NSString *)json{
    id param = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    return param;
}
/** 判断空串 **/
+ (BOOL)judgeNull:(NSString *)string{
    if (![string isKindOfClass:[NSString class]] || [string isEqualToString:@"(null)"] || [string isEqualToString:@""] || [string isEqual:[NSNull null]] || string.length == 0 || string == nil) {
        return YES;
    }
    return NO;
}
/**
 * 当字符串为空时返回空字符串 @”“
 **/
+ (NSString *)jt_returnNullStringWhenStringIsNull:(NSString *)string{
    return [JTBaseTool judgeNull:string] ? @"" : string;
}
/**
 * 打开url
 **/
+ (void)jt_openUrl:(NSString *)urlStr{
    if([JTBaseTool judgeNull:urlStr]) return;
    NSURL *url = [NSURL URLWithString:urlStr];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![[UIApplication sharedApplication] canOpenURL:url]) return;
        if (@available (iOS 10, *)) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }else{
            [[UIApplication sharedApplication] openURL:url];
        }
    });
}
#pragma mark - 设备调节亮度
/**
 * 亮度调节: value (0~1)
 */
+ (void)jt_deviceBrightness:(CGFloat)value{
    _jtCurrentBrightness = [UIScreen mainScreen].brightness;
    value = value > 1 ? 1 : value;
    value = value < 0 ? 0 : value;
    [[UIScreen mainScreen] setBrightness:value];
}
/**
 * 调节到最高亮度
 */
+ (void)jt_deviceHighestBrightness{
    [JTBaseTool jt_deviceBrightness:1.0];
}
/**
 * 调节亮度后恢复之前的亮度
 */
+ (void)jt_recoverDeviceBrightness{
    [[UIScreen mainScreen] setBrightness:_jtCurrentBrightness];
}
#pragma mark - 设备调节音量
/**
 * 音量调节: value (0~1)
 */
+ (void)jt_deviceVolume:(CGFloat)value{
    // 获取当前音量
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    _jtCurrentVolume = audioSession.outputVolume;
    value = value > 1 ? 1 : value;
    value = value < 0 ? 0 : value;
    if (@available(iOS 13, *)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        // 过期api写在这里不会有警告
        [[MPMusicPlayerController applicationMusicPlayer] setVolume:value];
#pragma clang diagnostic pop
    }else{
        //在IOS13之后不能使用了
        UISlider *volumeSlider = [JTBaseTool jt_getDeviceVolumeSlider];
        [volumeSlider setValue:value animated:YES];
    }
}
/**
 * 调节到最高音量
 */
+ (void)jt_deviceHighestVolume{
    [JTBaseTool jt_deviceVolume:1.0];
}
/**
 * 调节音量后恢复之前的音量
 */
+ (void)jt_recoverDeviceVolume{
    if (@available(iOS 13, *)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[MPMusicPlayerController applicationMusicPlayer] setVolume:_jtCurrentVolume];
#pragma clang diagnostic pop
    }else{
        UISlider *volumeSlider = [JTBaseTool jt_getDeviceVolumeSlider];
        [volumeSlider setValue:_jtCurrentVolume];
    }
}
+ (UISlider *)jt_getDeviceVolumeSlider{
    //在IOS13之后不能使用了
    UISlider *volumeSlider = nil;
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeSlider = (UISlider*)view;
            break;
        }
    }
    return volumeSlider;
}
#pragma mark - 判断有无网络
+ (BOOL)jt_getNetWorkStates{
    Reachability *reachaility = [Reachability reachabilityForInternetConnection];
    return [reachaility isReachable];
}
/** 获取：mac地址、uuid、ip地址、手机型号 **/
+ (NSDictionary *)getIphoneInfo{
    NSString *macId =  [JTBaseTool lj_getMacAddress];
    NSString *UUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *ipAddress = [JTBaseTool lj_getDeviceIPAddresses];
    NSString *iphoneModel = [JTBaseTool getCurrentDeviceModel];
    NSDictionary *info = @{
        @"uuid" : [JTBaseTool jt_returnNullStringWhenStringIsNull:UUID],
        @"macId" : [JTBaseTool jt_returnNullStringWhenStringIsNull:macId],
        @"ipAddress" : [JTBaseTool jt_returnNullStringWhenStringIsNull:ipAddress],
        @"iphoneModel" : [JTBaseTool jt_returnNullStringWhenStringIsNull:iphoneModel]
    };
    return info;
}
/** 获取mac地址 */
+ (NSString *)lj_getMacAddress{
    if([[Reachability reachabilityForInternetConnection] isReachable]){
        if ([[Reachability reachabilityForInternetConnection] isReachableViaWiFi]) {
            
            NSArray *ifs = CFBridgingRelease(CNCopySupportedInterfaces());
            id info = nil;
            for (NSString *ifnam in ifs) {
                info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((CFStringRef)ifnam);
                if (info && [info count]) {
                    break;
                }
            }
            NSDictionary *dic = (NSDictionary *)info;
            NSString *ssid = [[dic objectForKey:@"SSID"] lowercaseString];
            NSString *bssid = [[dic objectForKey:@"BSSID"] lowercaseString];
            NSLog(@"wifi名称：%@--mac地址：%@",ssid,bssid);
            return bssid;
        }else{
            int mib[6];
            size_t len;
            char *buf;
            unsigned char *ptr;
            struct if_msghdr *ifm;
            struct sockaddr_dl *sdl;
            
            mib[0] = CTL_NET;
            mib[1] = AF_ROUTE;
            mib[2] = 0;
            mib[3] = AF_LINK;
            mib[4] = NET_RT_IFLIST;
            
            if ((mib[5] = if_nametoindex("en0")) == 0) {
                return NULL;
            }
            
            if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
                return NULL;
            }
            
            if ((buf = malloc(len)) == NULL) {
                return NULL;
            }
            
            if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
                return NULL;
            }
            
            ifm = (struct if_msghdr *)buf;
            sdl = (struct sockaddr_dl *)(ifm + 1);
            ptr = (unsigned char *)LLADDR(sdl);
            
            NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
            free(buf);
            
            return [outstring uppercaseString];
        }
    }else{
        return @"";
    }
}
/** 获取IP地址 */
+ (NSString *)lj_getDeviceIPAddresses{
    
    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    
    NSMutableArray *ips = [NSMutableArray array];
    
    int BUFFERSIZE = 4096;
    
    struct ifconf ifc;
    
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    
    struct ifreq *ifr, ifrcopy;
    
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) >= 0){
        
        for (ptr = buffer; ptr < buffer + ifc.ifc_len; ){
            
            ifr = (struct ifreq *)ptr;
            int len = sizeof(struct sockaddr);
            
            if (ifr->ifr_addr.sa_len > len) {
                len = ifr->ifr_addr.sa_len;
            }
            
            ptr += sizeof(ifr->ifr_name) + len;
            if (ifr->ifr_addr.sa_family != AF_INET) continue;
            if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL) *cptr = 0;
            if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0) continue;
            
            memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
            ifrcopy = *ifr;
            ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
            
            if ((ifrcopy.ifr_flags & IFF_UP) == 0) continue;
            
            NSString *ip = [NSString  stringWithFormat:@"%s", inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            [ips addObject:ip];
        }
    }
    
    close(sockfd);
    NSString *deviceIP = @"";
    
    for (int i=0; i < ips.count; i++) {
        if (ips.count > 0) {
            deviceIP = [NSString stringWithFormat:@"%@",ips.lastObject];
        }
    }
    return deviceIP;
}
#pragma mark - 获取设备类型
/**
 获取当前设备类型 支持到iPhone 11
 added by xuqinqiang
 @return 设备字符串
 */
+ (NSString *)getCurrentDeviceModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone_4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"iPhone_4";
    if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone_4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone_4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone_5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone_5_(GSM_CDMA)";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone_5c_(GSM)";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone_5c_(GSM_CDMA)";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone_5s_(GSM)";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone_5s_(GSM_CDMA)";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone_6_Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone_6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone_6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone_6s_Plus";
    if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone_SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone_7";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone_7_Plus";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone_7";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone_7_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,1"])   return @"iPhone_8";
    if ([deviceModel isEqualToString:@"iPhone10,4"])   return @"iPhone_8";
    if ([deviceModel isEqualToString:@"iPhone10,2"])   return @"iPhone_8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,5"])   return @"iPhone_8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,3"])   return @"iPhone_X";
    if ([deviceModel isEqualToString:@"iPhone10,6"])   return @"iPhone_X";
    if ([deviceModel isEqualToString:@"iPhone11,8"])   return @"iPhone_XR";
    if ([deviceModel isEqualToString:@"iPhone11,2"])   return @"iPhone_XS";
    if ([deviceModel isEqualToString:@"iPhone11,6"])   return @"iPhone_XS_Max";
    if ([deviceModel isEqualToString:@"iPhone11,4"])   return @"iPhone_XS_Max";
    if ([deviceModel isEqualToString:@"iPhone12,1"])   return @"iPhone_11";
    if ([deviceModel isEqualToString:@"iPhone12,3"])   return @"iPhone_11_Pro";
    if ([deviceModel isEqualToString:@"iPhone12,5"])   return @"iPhone_11_Pro_Max";
    if ([deviceModel isEqualToString:@"iPhone12,8"])   return @"iPhone_SE_(2nd generation)";
    if ([deviceModel isEqualToString:@"iPhone13,1"])   return @"iPhone 12 mini";
    if ([deviceModel isEqualToString:@"iPhone13,2"])   return @"iPhone 12";
    if ([deviceModel isEqualToString:@"iPhone13,3"])   return @"iPhone 12  Pro";
    if ([deviceModel isEqualToString:@"iPhone13,4"])   return @"iPhone 12  Pro Max";
    if ([deviceModel isEqualToString:@"iPhone14,4"])   return @"iPhone 13 mini";
    if ([deviceModel isEqualToString:@"iPhone14,5"])   return @"iPhone 13";
    if ([deviceModel isEqualToString:@"iPhone14,2"])   return @"iPhone 13  Pro";
    if ([deviceModel isEqualToString:@"iPhone14,3"])   return @"iPhone 13  Pro Max";

    //iPad
    if ([deviceModel isEqualToString:@"iPad1,1"])   return @"iPad";
    if ([deviceModel isEqualToString:@"iPad2,1"])   return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,2"])   return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,3"])   return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,4"])   return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad3,1"])   return @"iPad (3rd generation)";
    if ([deviceModel isEqualToString:@"iPad3,2"])   return @"iPad (3rd generation)";
    if ([deviceModel isEqualToString:@"iPad3,3"])   return @"iPad (3rd generation)";
    if ([deviceModel isEqualToString:@"iPad3,4"])   return @"iPad (4th generation)";
    if ([deviceModel isEqualToString:@"iPad3,5"])   return @"iPad (4th generation)";
    if ([deviceModel isEqualToString:@"iPad3,6"])   return @"iPad (4th generation)";
    if ([deviceModel isEqualToString:@"iPad6,11"])  return @"iPad (5th generation)";
    if ([deviceModel isEqualToString:@"iPad6,12"])  return @"iPad (5th generation)";
    if ([deviceModel isEqualToString:@"iPad7,5"])   return @"iPad (6th generation)";
    if ([deviceModel isEqualToString:@"iPad7,6"])   return @"iPad (6th generation)";
    if ([deviceModel isEqualToString:@"iPad7,11"])  return @"iPad (7th generation)";
    if ([deviceModel isEqualToString:@"iPad7,12"])  return @"iPad (7th generation)";
    if ([deviceModel isEqualToString:@"iPad11,6"])  return @"iPad (8th generation)";
    if ([deviceModel isEqualToString:@"iPad11,7"])  return @"iPad (8th generation)";

    //iPad Air
    if ([deviceModel isEqualToString:@"iPad4,1"])   return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,2"])   return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,3"])   return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad5,3"])   return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])   return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad11,3"])  return @"iPad Air (3rd generation)";
    if ([deviceModel isEqualToString:@"iPad11,4"])  return @"iPad Air (3rd generation)";
    if ([deviceModel isEqualToString:@"iPad13,1"])  return @"iPad Air (4th generation)";
    if ([deviceModel isEqualToString:@"iPad13,2"])  return @"iPad Air (4th generation)";

    //iPad mini
    if ([deviceModel isEqualToString:@"iPad2,5"])   return @"iPad mini";
    if ([deviceModel isEqualToString:@"iPad2,6"])   return @"iPad mini";
    if ([deviceModel isEqualToString:@"iPad2,7"])   return @"iPad mini 1";
    if ([deviceModel isEqualToString:@"iPad4,4"])   return @"iPad mini 2";
    if ([deviceModel isEqualToString:@"iPad4,5"])   return @"iPad mini 2";
    if ([deviceModel isEqualToString:@"iPad4,6"])   return @"iPad mini 2";
    if ([deviceModel isEqualToString:@"iPad4,7"])   return @"iPad mini 3";
    if ([deviceModel isEqualToString:@"iPad4,8"])   return @"iPad mini 3";
    if ([deviceModel isEqualToString:@"iPad4,9"])   return @"iPad mini 3";
    if ([deviceModel isEqualToString:@"iPad5,1"])   return @"iPad mini 4";
    if ([deviceModel isEqualToString:@"iPad5,2"])   return @"iPad mini 4";
    if ([deviceModel isEqualToString:@"iPad11,1"])  return @"iPad mini 5";
    if ([deviceModel isEqualToString:@"iPad11,2"])  return @"iPad mini 5";
    
    // iPad Pro
    if ([deviceModel isEqualToString:@"iPad6,3"])    return @"iPad Pro (9.7-inch)";
    if ([deviceModel isEqualToString:@"iPad6,4"])    return @"iPad Pro (9.7-inch)";
    if ([deviceModel isEqualToString:@"iPad6,7"])    return @"iPad Pro (12.9-inch)";
    if ([deviceModel isEqualToString:@"iPad6,8"])    return @"iPad Pro (12.9-inch)";
    if ([deviceModel isEqualToString:@"iPad7,1"])    return @"iPad Pro (12.9-inch) (2nd generation)";
    if ([deviceModel isEqualToString:@"iPad7,2"])    return @"iPad Pro (12.9-inch) (2nd generation)";
    if ([deviceModel isEqualToString:@"iPad7,3"])    return @"iPad Pro (10.5 inch)";
    if ([deviceModel isEqualToString:@"iPad7,4"])    return @"iPad Pro (10.5-inch)";
    if ([deviceModel isEqualToString:@"iPad8,1"])    return @"iPad Pro (11-inch)";
    if ([deviceModel isEqualToString:@"iPad8,2"])    return @"iPad Pro (11-inch)";
    if ([deviceModel isEqualToString:@"iPad8,3"])    return @"iPad Pro (11-inch)";
    if ([deviceModel isEqualToString:@"iPad8,4"])    return @"iPad Pro (11-inch)";
    if ([deviceModel isEqualToString:@"iPad8,5"])    return @"iPad Pro (12.9-inch) (3rd generation)";
    if ([deviceModel isEqualToString:@"iPad8,6"])    return @"iPad Pro (12.9-inch) (3rd generation)";
    if ([deviceModel isEqualToString:@"iPad8,7"])    return @"iPad Pro (12.9-inch) (3rd generation)";
    if ([deviceModel isEqualToString:@"iPad8,8"])    return @"iPad Pro (12.9-inch) (3rd generation)";
    if ([deviceModel isEqualToString:@"iPad8,9"])    return @"iPad Pro (11-inch) (2nd generation)";
    if ([deviceModel isEqualToString:@"iPad8,10"])   return @"iPad Pro (11-inch) (2nd generation)";
    if ([deviceModel isEqualToString:@"iPad8,11"])   return @"iPad Pro (12.9-inch) (4th generation)";
    if ([deviceModel isEqualToString:@"iPad8,12"])   return @"iPad Pro (12.9-inch) (4th generation)";

    if ([deviceModel isEqualToString:@"AppleTV2,1"])      return @"Apple_TV_2";
    if ([deviceModel isEqualToString:@"AppleTV3,1"])      return @"Apple_TV_3";
    if ([deviceModel isEqualToString:@"AppleTV3,2"])      return @"Apple_TV_3";
    if ([deviceModel isEqualToString:@"AppleTV5,3"])      return @"Apple_TV_4";
    
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    return deviceModel;
}
#pragma mark - 网络状态
/** 当前网络状态 */
+ (NSString *)networkStatus{
    Reachability *hostReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [hostReach currentReachabilityStatus];
    NSString *net = @"";
    switch (internetStatus) {
        case ReachableViaWiFi:
            net = @"WIFI";
            break;
        case ReachableViaWWAN:
            net = [self getNetType];   //判断具体类型
            break;
        case NotReachable:
            net = @"unknown";
        default:
            break;
    }
    return net;
}
+ (NSString *)getNetType {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    /// 注意：没有SIM卡，值为空
    NSString *currentStatus;
    NSString *currentNet = @"unknown";
    if (@available(iOS 12.1, *)) {
        if (info && [info respondsToSelector:@selector(serviceCurrentRadioAccessTechnology)]) {
            NSDictionary *radioDic = [info serviceCurrentRadioAccessTechnology];
            if (radioDic.allKeys.count) {
                currentStatus = [radioDic objectForKey:radioDic.allKeys[0]];
            }
        }
    }else{
        currentStatus = info.currentRadioAccessTechnology;
    }
    if ([currentStatus isEqualToString:CTRadioAccessTechnologyGPRS]
        || [currentStatus isEqualToString:CTRadioAccessTechnologyEdge]
        || [currentStatus isEqualToString:CTRadioAccessTechnologyCDMA1x]) {
        currentNet = @"2G";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyWCDMA] ||
              [currentStatus isEqualToString:CTRadioAccessTechnologyHSDPA] ||
              [currentStatus isEqualToString:CTRadioAccessTechnologyHSUPA] ||
              [currentStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0] ||
              [currentStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA] ||
              [currentStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB] ||
              [currentStatus isEqualToString:CTRadioAccessTechnologyeHRPD]){
        currentNet = @"3G";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyLTE]){
        currentNet = @"4G";
    }else if (@available(iOS 14.1, *)) {
        if ([currentStatus isEqualToString:CTRadioAccessTechnologyNRNSA]||
            [currentStatus isEqualToString:CTRadioAccessTechnologyNR]){
            currentNet = @"5G";
        }
    }
    return currentNet;
}
#pragma mark - 设备当前音量和电池电量
/** 获取当前音量 */
+ (NSString *)getCurrentVoiceLevel{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:YES error:nil];
    CGFloat currentVol = audioSession.outputVolume * 100;
    if (currentVol>=0 && currentVol <= 100) {
        return [NSString stringWithFormat:@"%d%%",(int)currentVol];
    }else {
        return @"unknown";
    }
}
/** 当前电池状态 */
+ (NSString *)getCurrentBatteryLevel{
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    double deviceLevel = [UIDevice currentDevice].batteryLevel * 100;
    if (deviceLevel>=0 && deviceLevel <= 100) {
        return [NSString stringWithFormat:@"%d%%",(int)deviceLevel];
    }else {
        return @"unknown";
    }
}

#pragma -mark 佩戴耳机
/** 是否佩戴耳机 */
+ (BOOL)isWearHeadset {
    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription* desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones] ||
            [[desc portType] isEqualToString:AVAudioSessionPortBluetoothA2DP] ||
            [[desc portType] isEqualToString:AVAudioSessionPortBluetoothHFP] ||
            [[desc portType] isEqualToString:@"BluetoothHSP"])
            return YES;
    }
    return NO;
}
/** 当前连接耳机状态
    "N"                未连接耳机
    "B"                连接蓝牙耳机
    "W"               连接有线耳机
    "unknown"    未知
 */
+ (NSString *)getHeadsetStatus{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    AVAudioSessionRouteDescription *routeDescription = [session currentRoute];
    if (routeDescription) {
        NSArray *outputs = [routeDescription outputs];
        if (outputs && [outputs count] > 0) {
            AVAudioSessionPortDescription *portDescription = [outputs objectAtIndex:0];
            NSString *portType = [portDescription portType];
            if (portType && (
                 [portType isEqualToString:AVAudioSessionPortBluetoothA2DP] ||
                 [portType isEqualToString:AVAudioSessionPortBluetoothHFP] ||
                 [portType isEqualToString:@"BluetoothHSP"])) {
                return @"B";
            }else if (portType && [portType isEqualToString:AVAudioSessionPortHeadphones]){
                return @"W";
            }else{
                return @"N";
            }
        }else{
            return @"N";
        }
    }
    return @"unknown";
}
/*
 蓝牙开启未链接耳机:
 Speaker
 
 单向保真音频协议(输出):
 BluetoothA2DPOutput
 ...

 双向保真音频协议(输入 & 输入):
 BluetoothHFP - HFP(Hands-Free Profile)
 BluetoothHSP - HSP(HeadSet Profile)
 
 其它:
 Receiver
 */
@end
