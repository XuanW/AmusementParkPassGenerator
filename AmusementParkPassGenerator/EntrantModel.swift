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

struct RequiredInfo {
    var firstName: String?
    var lastName: String?
    var dateOfBirth: NSDate?
    var street: String?
    var city: String?
    var state: String?
    var zip: String?
}

struct Person {
    let entrantType: Entrant
    let info: RequiredInfo
}

struct Pass {
    let title: String
    let passType: String
    let rideInfo: String
    let foodDiscountInfo: String
    let merchandiseDiscountInfo: String
    let areaAccess: AreaAccessType
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
}


// MARK: Generate Pass

func printPass(person: Person) {
    if let pass = generatePass(person) {
        print(pass.title + "\n" + pass.passType + "\n" + pass.rideInfo + "\n" + pass.foodDiscountInfo + "\n" + pass.merchandiseDiscountInfo)
    }
}

func generatePass(person: Person) -> Pass? {
    let title: String
    let passType: String
    let rideInfo: String
    let foodDiscountInfo: String
    let merchandiseDiscountInfo: String
    let areaAccess: AreaAccessType
    
    do {
        let infoGathered = try gatherRequiredInfo(person)
        if let firstName = infoGathered.firstName, lastName = infoGathered.lastName {
            title = "\(firstName) \(lastName)"
        } else {
            title = "Amusement Park Pass"
        }
        
        switch person.entrantType {
        case is Guest:
            let guestType = person.entrantType as! Guest
            
            rideInfo = "Unlimited Rides. Priority: \(guestType.getRideAccessDetail().skipAllRideLines)"
            foodDiscountInfo = "\(guestType.getDiscountAccessDetail().food)% Food Discount"
            merchandiseDiscountInfo = "\(guestType.getDiscountAccessDetail().merchandise)% Merchandise Discount"
            areaAccess = guestType.getAreaAccessDetail()
            
            switch guestType {
            case .classic:
                passType = "Classic Guest Pass"
            case .freeChild:
                passType = "Child Guest Pass"
            case .vip:
                passType = "VIP Guest Pass"
                
            }
        default:
            let employeeType = person.entrantType as! Employee
            
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
        
        return Pass(title: title, passType: passType, rideInfo: rideInfo, foodDiscountInfo: foodDiscountInfo, merchandiseDiscountInfo: merchandiseDiscountInfo, areaAccess: areaAccess)
        
    } catch let error {
        print("Error: \(error)")
        return nil
    }
}

func gatherRequiredInfo(person:Person) throws -> RequiredInfo {
    
    var infoGathered = RequiredInfo()
    
    switch person.entrantType {
    case is Guest:
        let guestType = person.entrantType as! Guest
        switch guestType {
        case .freeChild:
            if let dateOfBirth = person.info.dateOfBirth {
                infoGathered.dateOfBirth = dateOfBirth
            } else {
                throw RequiredInfoError.MissingDateOfBirth
            }
            // TODO: Calculate age and throw errors accordingly
        default:
            break
        }
        return infoGathered
    default:
        // Default will be employee type, require all info except date of birth
        if let firstName = person.info.firstName {
            infoGathered.firstName = firstName
        } else {
            throw RequiredInfoError.MissingFirstName
        }
        if let lastName = person.info.lastName {
            infoGathered.lastName = lastName
        } else {
            throw RequiredInfoError.MissingLastName
        }
        if let street = person.info.street {
            infoGathered.street = street
        } else {
            throw RequiredInfoError.MissingStreetAddress
        }
        if let city = person.info.city {
            infoGathered.city = city
        } else {
            throw RequiredInfoError.MissingCity
        }
        if let state = person.info.state {
            infoGathered.state = state
        } else {
            throw RequiredInfoError.MissingState
        }
        if let zip = person.info.zip {
            infoGathered.zip = zip
        } else {
            throw RequiredInfoError.MissingZipCode
        }
        
        return infoGathered
    }
}



























