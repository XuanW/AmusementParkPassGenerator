//
//  EntrantModel.swift
//  AmusementParkPassGenerator
//
//  Created by XuanWang on 7/1/16.
//  Copyright © 2016 XuanWang. All rights reserved.
//

import Foundation

// MARK: Protocols

protocol Entrant {

}

protocol AreaAccess {
    //var areaAccess: AreaAccessType  { get }
    func getAreaAccessDetail() -> AreaAccessType
}

protocol RideAccess {
    //var rideAccess: RideAccessType { get }
    func getRideAccessDetail() -> RideAccessType
}

protocol DiscountAccess {
    //var discountAccess: DiscountAccessType  { get }
    func getDiscountAccessDetail() -> DiscountAccessType
}

// MARK: Access types

struct AreaAccessType {
    var amusement: Bool
    var kitchen: Bool
    var rideControl: Bool
    var maintenance: Bool
    var office: Bool
}

struct RideAccessType {
    var accessAllRides: Bool
    var skipAllRideLines: Bool
}

struct DiscountAccessType {
    var food: Int
    var merchandise: Int
}

// MARK: Other objects

struct PersonalInfo {
    var firstName: String?
    var lastName: String?
    var dateOfBirth: String?
    var street: String?
    var city: String?
    var state: String?
    var zip: String?

}

//struct Person {
//    let entrantType: Entrant
//    let info: PersonalInfo
//}

struct Pass {
    let title: String
    let passType: String
    let rideInfo: String
    let foodDiscountInfo: String
    let merchandiseDiscountInfo: String
    let areaAccess: AreaAccessType
    let personalInfo: PersonalInfo
}


// MARK: Entrant types

enum Guest: Entrant, AreaAccess, RideAccess, DiscountAccess {
    case classic
    case vip
    case freeChild
    
    func getAreaAccessDetail() -> AreaAccessType {
        return AreaAccessType(amusement: true, kitchen: false, rideControl: false, maintenance: false, office: false)
    }
    
    func getRideAccessDetail() -> RideAccessType {
        var skipAllRideLines: Bool
        switch self {
        case .classic, .freeChild:
            skipAllRideLines = false
        case .vip:
            skipAllRideLines =  true
        }
        return RideAccessType(accessAllRides: true, skipAllRideLines: skipAllRideLines)
    }
    
    func getDiscountAccessDetail() -> DiscountAccessType {
        var foodDiscount: Int
        var merchandiseDiscount: Int
        switch self {
        case .vip:
            foodDiscount = 10
            merchandiseDiscount = 20
        default:
            foodDiscount = 0
            merchandiseDiscount = 0
        }
        return DiscountAccessType(food: foodDiscount, merchandise: merchandiseDiscount)
    }
}


enum Employee: Entrant, AreaAccess, RideAccess, DiscountAccess {
    case hourlyFood
    case hourlyRide
    case hourlyMaintenance
    case manager
    
    func getAreaAccessDetail() -> AreaAccessType {
        var kitchenAccess: Bool, rideControlAccess: Bool, maintenanceAccess: Bool, officeAccess: Bool
        switch self {
        case .hourlyFood:
            kitchenAccess = true
            rideControlAccess = false
            maintenanceAccess = false
            officeAccess = false
        case .hourlyRide:
            kitchenAccess = false
            rideControlAccess = true
            maintenanceAccess = false
            officeAccess = false
        case .hourlyMaintenance:
            kitchenAccess = true
            rideControlAccess = true
            maintenanceAccess = true
            officeAccess = false
        case .manager:
            kitchenAccess = true
            rideControlAccess = true
            maintenanceAccess = true
            officeAccess = true
        }
        return AreaAccessType(amusement: true, kitchen: kitchenAccess, rideControl: rideControlAccess, maintenance: maintenanceAccess, office: officeAccess)
    }
    
    func getRideAccessDetail() -> RideAccessType {
        return RideAccessType(accessAllRides: true, skipAllRideLines: false)
    }
    
    func getDiscountAccessDetail() -> DiscountAccessType {
        var foodDiscount: Int, merchandiseDiscount: Int
        switch self {
        case .manager:
            foodDiscount = 25
            merchandiseDiscount = 25
        default:
            foodDiscount = 15
            merchandiseDiscount = 25
        }
        return DiscountAccessType(food: foodDiscount, merchandise: merchandiseDiscount)
    }
}

// MARK: Error Types

enum RequiredInfoError: ErrorType {
    case MissingFirstName
    case MissingLastName
    case MissingStreetAddress
    case MissingCity
    case MissingState
    case MissingZipCode
    case MissingDateOfBirth
    case AgeRequirementNotMet
    case DateFormatNotCorrect
}


// MARK: Generate Pass

func printPass(entrantType: Entrant, person: PersonalInfo) {
    if let pass = generatePass(entrantType, person: person) {
        print(pass.title + "\n" + pass.passType + "\n" + pass.rideInfo + "\n" + pass.foodDiscountInfo + "\n" + pass.merchandiseDiscountInfo)
    }
}

func generatePass(entrantType: Entrant, person: PersonalInfo) -> Pass? {
    let title: String
    let passType: String
    let rideInfo: String
    let foodDiscountInfo: String
    let merchandiseDiscountInfo: String
    let areaAccess: AreaAccessType
    
    do {
        let infoGathered = try gatherRequiredInfo(entrantType, person: person)
        if let firstName = infoGathered.firstName, lastName = infoGathered.lastName {
            title = "\(firstName) \(lastName)"
        } else {
            title = "Amusement Park Pass"
        }
        
        switch entrantType {
        case is Guest:
            let guestType = entrantType as! Guest
            foodDiscountInfo = "\(guestType.getDiscountAccessDetail().food)% Food Discount"
            merchandiseDiscountInfo = "\(guestType.getDiscountAccessDetail().merchandise)% Merchandise Discount"
            areaAccess = guestType.getAreaAccessDetail()
            
            switch guestType {
            case .classic:
                passType = "Classic Guest Pass"
                rideInfo = "Unlimited Rides. Priority: Regular."
            case .freeChild:
                passType = "Child Guest Pass"
                rideInfo = "Unlimited Rides. Priority: Regular."
            case .vip:
                passType = "VIP Guest Pass"
                rideInfo = "Unlimited Rides. Priority: VIP."
                
            }
        default:
            let employeeType = entrantType as! Employee
            
            rideInfo = "Unlimited Rides"
            foodDiscountInfo = "\(employeeType.getDiscountAccessDetail().food)% Food Discount"
            merchandiseDiscountInfo = "\(employeeType.getDiscountAccessDetail().merchandise)% Merchandise Discount"
            areaAccess = employeeType.getAreaAccessDetail()
            
            switch employeeType {
            case .hourlyFood:
                passType = "Hourly Employee - Food Services"
            case .hourlyRide:
                passType = "Hourly Employee - Ride Services"
            case .hourlyMaintenance:
                passType = "Hourly Employee - Maintenance"
            case .manager:
                passType = "Manager"
            }
        }
        
        return Pass(title: title, passType: passType, rideInfo: rideInfo, foodDiscountInfo: foodDiscountInfo, merchandiseDiscountInfo: merchandiseDiscountInfo, areaAccess: areaAccess, personalInfo: infoGathered)
        
    } catch let error {
        print("Error: \(error)")
        return nil
    }
}

func gatherRequiredInfo(entrantType: Entrant, person: PersonalInfo) throws -> PersonalInfo {
    switch entrantType {
    case is Guest:
        let guestType = entrantType as! Guest
        switch guestType {
        case .freeChild:
            if let dateOfBirth = person.dateOfBirth {
                if satisfyAgeRequirement(dateOfBirth) {
                    return person
                } else {
                    throw RequiredInfoError.AgeRequirementNotMet
                }
            } else {
                throw RequiredInfoError.MissingDateOfBirth
            }
        default:
            return person
        }
    default:
        // Default will be employee type, require all info except date of birth
        guard person.firstName != nil else {
            throw RequiredInfoError.MissingFirstName
        }
        guard person.lastName != nil else {
            throw RequiredInfoError.MissingLastName
        }
        guard person.street != nil else {
            throw RequiredInfoError.MissingStreetAddress
        }
        guard person.city != nil else {
            throw RequiredInfoError.MissingCity
        }
        guard person.state != nil else {
            throw RequiredInfoError.MissingState
        }
        guard person.zip != nil else {
            throw RequiredInfoError.MissingZipCode
        }
        return person
    }
}



// Helper Methods

func convertStringToNSDate(dateOfBirthAsString: String) throws -> NSDate? {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    if let dateOfBirthAsNSDate: NSDate = dateFormatter.dateFromString(dateOfBirthAsString){
        return dateOfBirthAsNSDate
    } else {
        throw RequiredInfoError.DateFormatNotCorrect
    }
}

func satisfyAgeRequirement(dateOfBirthAsString: String) -> Bool {
    do {
        let currentDate = NSDate()
        if let dateOfBirth = try convertStringToNSDate(dateOfBirthAsString) {
            let diffDateComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.Year, fromDate: dateOfBirth, toDate: currentDate, options: NSCalendarOptions.init(rawValue: 0))
            if diffDateComponents.year < 5 {
                return true
            } else {
                return false
            }
        }
    }
    catch let error {
        print("Error: \(error)")
    }
    return false
}

func checkBirthday(dateOfBirthAsString: String) {
    do {
        let currentDate = NSDate()
        if let dateOfBirth = try convertStringToNSDate(dateOfBirthAsString) {
            let birthdayDateComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: dateOfBirth)
            let currentDayDateComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: currentDate)
            if birthdayDateComponents.month == currentDayDateComponents.month && birthdayDateComponents.day == currentDayDateComponents.day {
                print("Happy birthday! Hope you enjoy your time here!")
            }
        }
    }
    catch let error {
        print("Error: \(error)")
    }
}





















