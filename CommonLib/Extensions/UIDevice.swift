//
//  UIDevice.swift
//  CommonLib
//
//  Created by RAC IT SOLUTIONS PVT.LTD on 19/07/18.
//  Copyright © 2018 Appino. All rights reserved.
//

import UIKit
import LocalAuthentication

extension UIDevice {
    open func isFingerprintOrFaceAuthenticationAvailable() -> Bool {
        let context = LAContext()
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    open var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }
    
    public enum ScreenType: String {
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhone6Plus
        case iPhoneX
        case iPadMini
        case iPadPro10_5
        case iPadPro12_9
        case Unknown
    }
    
    open var screenType: ScreenType {
//        guard iPhone else { return .Unknown}
        switch UIScreen.main.bounds.size.height {
        case 480:
            return .iPhone4
        case 568:
            return .iPhone5
        case 667:
            return .iPhone6
        case 736:
            return .iPhone6Plus
        case 812:
            return .iPhoneX
        case 1024:
            return .iPadMini
        case 1112:
            return .iPadPro10_5
        case 1366:
            return .iPadPro12_9
        default:
            return .Unknown
        }
    }
    
    open func getModelIdentifier() -> String {
        var modelIdentifier : String = ""
        if ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] != nil {
            modelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]!
        }
        else {
            var sysinfo = utsname()
            uname(&sysinfo) // ignore return value
            modelIdentifier = String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
        }
        
        switch modelIdentifier {
        case "iPhone4,1":                   return "iPhone 4s"
        case "iPhone5,1":                   return "iPhone 5"
        case "iPhone5,2":                   return "iPhone 5"
        case "iPhone5,3":                   return "iPhone 5c"
        case "iPhone5,4":                   return "iPhone 5c"
        case "iPhone6,1":                   return "iPhone 5s"
        case "iPhone6,2":                   return "iPhone 5s"
        case "iPhone7,2":                   return "iPhone 6"
        case "iPhone7,1":                   return "iPhone 6 Plus"
        case "iPhone8,1":                   return "iPhone 6s"
        case "iPhone8,2":                   return "iPhone 6s Plus"
        case "iPhone8,4":                   return "iPhone SE"
        case "iPhone9,1":                   return "iPhone 7"
        case "iPhone9,3":                   return "iPhone 7"
        case "iPhone9,2":                   return "iPhone 7 Plus"
        case "iPhone9,4":                   return "iPhone 7 Plus"
        case "iPhone10,1":                  return "iPhone 8"
        case "iPhone10,4":                  return "iPhone 8"
        case "iPhone10,2":                  return "iPhone 8 Plus"
        case "iPhone10,5":                  return "iPhone 8 Plus"
        case "iPhone10,3":                  return "iPhone X"
        case "iPhone10,6":                  return "iPhone X"
            
        case "iPod5,1":                     return "iPod touch (5th generation)"
        case "iPod7,1":                     return "iPod touch (6th generation)"
            
        case "iPad2,5":                     return "iPad mini"
        case "iPad2,6":                     return "iPad mini"
        case "iPad2,7":                     return "iPad mini"
        case "iPad4,4":                     return "iPad mini 2"
        case "iPad4,5":                     return "iPad mini 2"
        case "iPad4,6":                     return "iPad mini 2"
        case "iPad4,7":                     return "iPad mini 3"
        case "iPad4,8":                     return "iPad mini 3"
        case "iPad4,9":                     return "iPad mini 3"
        case "iPad5,1":                     return "iPad mini 4"
        case "iPad5,2":                     return "iPad mini 4"
            
        case "iPad2,1":                     return "iPad 2"
        case "iPad2,2":                     return "iPad 2"
        case "iPad2,3":                     return "iPad 2"
        case "iPad2,4":                     return "iPad 2"
        case "iPad3,1":                     return "iPad (3rd generation)"
        case "iPad3,2":                     return "iPad (3rd generation)"
        case "iPad3,3":                     return "iPad (3rd generation)"
        case "iPad3,4":                     return "iPad (4th generation)"
        case "iPad3,5":                     return "iPad (4th generation)"
        case "iPad3,6":                     return "iPad (4th generation)"
        case "iPad4,1":                     return "iPad Air"
        case "iPad4,2":                     return "iPad Air"
        case "iPad4,3":                     return "iPad Air"
        case "iPad5,3":                     return "iPad Air 2"
        case "iPad5,4":                     return "iPad Air 2"
        case "iPad6,7":                     return "iPad Pro (12.9-inch)"
        case "iPad6,8":                     return "iPad Pro (12.9-inch)"
        case "iPad6,3":                     return "iPad Pro (9.7-inch)"
        case "iPad6,4":                     return "iPad Pro (9.7-inch)"
        case "iPad6,11":                    return "iPad (5th generation)"
        case "iPad6,12":                    return "iPad (5th generation)"
        case "iPad7,1":                     return "iPad Pro (12.9-inch, 2nd generation)"
        case "iPad7,2":                     return "iPad Pro (12.9-inch, 2nd generation)"
        case "iPad7,3":                     return "iPad Pro (10.5-inch)"
        case "iPad7,4":                     return "iPad Pro (10.5-inch)"
            
        default:                            return modelIdentifier
        }
    }
    
}
