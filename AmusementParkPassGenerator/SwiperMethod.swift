//
//  SwiperMethod.swift
//  AmusementParkPassGenerator
//
//  Created by XuanWang on 7/3/16.
//  Copyright © 2016 XuanWang. All rights reserved.
//

import Foundation
import AudioToolbox

var sound: SystemSoundID = 0

enum RestrictedAreas {
    case kitchen
    case rideControl
    case maintenance
    case office
}

func areaAcessSwiper(entrantType: Entrant, person: PersonalInfo, toTestArea: RestrictedAreas) {
    if let pass = generatePass(entrantType, person: person) {
        switch toTestArea {
        case .kitchen:
            if pass.areaAccess.kitchen == true {
                print("Kitchen area access allowed.")
            } else {
                print("Kitchen area access not allowed.")
            }
            playSound(pass.areaAccess.kitchen)
        case .rideControl:
            if pass.areaAccess.rideControl == true {
                print("Ride control area access allowed.")
            } else {
                print("Ride control access not allowed.")
            }
            playSound(pass.areaAccess.rideControl)
        case .maintenance:
            if pass.areaAccess.maintenance == true {
                print("Maintenance area access allowed.")
            } else {
                print("Maintenance area access not allowed.")
            }
            playSound(pass.areaAccess.maintenance)
        case .office:
            if pass.areaAccess.office == true {
                print("Office area access allowed.")
            } else {
                print("Office area access not allowed.")
            }
            playSound(pass.areaAccess.office)
        }
        
        if let dateOfBirth = pass.personalInfo.dateOfBirth {
            checkBirthday(dateOfBirth)
        }
    }
}

func playSound(accessAllowed: Bool) {
    let path: String?
    if accessAllowed {
        path = NSBundle.mainBundle().pathForResource("AccessGranted", ofType: "wav")
    } else {
        path = NSBundle.mainBundle().pathForResource("AccessDenied", ofType: "wav")
    }
    let url: NSURL = NSURL(fileURLWithPath: path!)
    AudioServicesCreateSystemSoundID(url, &sound)
    AudioServicesPlaySystemSound(sound)
}




