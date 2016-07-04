//
//  EntrantModel.swift
//  AmusementParkPassGenerator
//
//  Created by XuanWang on 7/1/16.
//  Copyright © 2016 XuanWang. All rights reserved.
//

import Foundation

// MARK: Protocols

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

protocol Entrant: AreaAccess, RideAccess, DiscountAccess {
    
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

// MARK: Entrant types

enum Guest: Entrant {
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


enum Employee: Entrant {
    case hourlyFood
    case hourlyRide
    case hourlyMaintenance
    
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
        }
        return AreaAccessType(amusement: true, kitchen: kitchenAccess, rideControl: rideControlAccess, maintenance: maintenanceAccess, office: officeAccess)
    }
    
    func getRideAccessDetail() -> RideAccessType {
        return RideAccessType(accessAllRides: true, skipAllRideLines: false)
    }
    
    func getDiscountAccessDetail() -> DiscountAccessType {
        return DiscountAccessType(food: 15, merchandise: 25)
    }
}

enum Manager: Entrant {
    case manager
    
    func getAreaAccessDetail() -> AreaAccessType {
        return AreaAccessType(amusement: true, kitchen: true, rideControl: true, maintenance: true, office: true)
    }
    
    func getRideAccessDetail() -> RideAccessType {
        return RideAccessType(accessAllRides: true, skipAllRideLines: false)
    }
    
    func getDiscountAccessDetail() -> DiscountAccessType {
        return DiscountAccessType(food: 25, merchandise: 25)
    }
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

struct Pass {
    let title: String
    let passType: String
    let rideInfo: String
    let foodDiscountInfo: String
    let merchandiseDiscountInfo: String
    let areaAccess: AreaAccessType
    let rideAccess: RideAccessType
    let discountAccess: DiscountAccessType
    let personalInfo: PersonalInfo
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
    let rideAccess: RideAccessType
    let discountAccess: DiscountAccessType
    
    do {
        let infoGathered = try gatherRequiredInfo(entrantType, person: person)
        if let firstName = infoGathered.firstName, lastName = infoGathered.lastName {
            title = "\(firstName) \(lastName)"
        } else {
            title = "Amusement Park Pass"
        }
        
        areaAccess = entrantType.getAreaAccessDetail()
        rideAccess = entrantType.getRideAccessDetail()
        discountAccess = entrantType.getDiscountAccessDetail()
        
        foodDiscountInfo = "\(discountAccess.food)% food discount."
        merchandiseDiscountInfo = "\(discountAccess.merchandise)% merchandise discount."
        
        if rideAccess.accessAllRides == true {
            if rideAccess.skipAllRideLines == true {
                rideInfo = "Unlimited Rides. Priority: VIP."
            } else {
                rideInfo = "Unlimited Rides. Priority: Regular."
            }
        } else {
            rideInfo = "No access to rides."
        }
        
        switch entrantType {
        case is Guest:
            let guestType = entrantType as! Guest
            switch guestType {
            case .classic:
                passType = "Classic Guest Pass"
            case .freeChild:
                passType = "Child Guest Pass"
            case .vip:
                passType = "VIP Guest Pass"
            }
            
        case is Manager:
            passType = "Manager"
            
        default:
            let employeeType = entrantType as! Employee
            switch employeeType {
            case .hourlyFood:
                passType = "Hourly Employee - Food Services"
            case .hourlyRide:
                passType = "Hourly Employee - Ride Services"
            case .hourlyMaintenance:
                passType = "Hourly Employee - Maintenance"
            }
        }
        
        return Pass(title: title, passType: passType, rideInfo: rideInfo, foodDiscountInfo: foodDiscountInfo, merchandiseDiscountInfo: merchandiseDiscountInfo, areaAccess: areaAccess, rideAccess: rideAccess, discountAccess: discountAccess, personalInfo: infoGathered)
        
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
        // Default will be employee or manager type, require all info except date of birth
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





















