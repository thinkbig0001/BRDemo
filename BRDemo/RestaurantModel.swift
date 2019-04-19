//
//  RestaurantModel.swift
//  BRDemo
//
//  Created by TAPAN BISWAS on 4/16/19.
//  Copyright © 2019 TAPAN BISWAS. All rights reserved.
//

import Foundation

struct Contact: Decodable {
    let phone: String?
    let formattedPhone: String?
    let twitter: String?
    let facebook: String?
    let facebookUsername: String?
    let facebookName: String?
    
    enum CodingKeys: String, CodingKey {
        case phone
        case formattedPhone
        case twitter
        case facebook
        case facebookUsername
        case facebookName
    }
    
    init(phone: String?, formattedPhone: String?, twitter: String?, facebook: String?, facebookUsername: String?, facebookName: String?) {
        self.phone = phone
        self.formattedPhone = formattedPhone
        self.twitter = twitter
        self.facebook = facebook
        self.facebookUsername = facebookUsername
        self.facebookName = facebookName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let phone = try container.decodeIfPresent(String.self, forKey: .phone)
        let formattedPhone = try container.decodeIfPresent(String.self, forKey: .formattedPhone)
        let twitter = try container.decodeIfPresent(String.self, forKey: .twitter)
        let facebook = try container.decodeIfPresent(String.self, forKey: .facebook)
        let facebookUsername = try container.decodeIfPresent(String.self, forKey: .facebookUsername)
        let facebookName = try container.decodeIfPresent(String.self, forKey: .facebookName)

        self.init(phone: phone, formattedPhone: formattedPhone, twitter: twitter, facebook: facebook, facebookUsername: facebookUsername, facebookName: facebookName)
    }
}

struct ResLocation: Decodable {
    var address: String?
    var crossStreet: String?
    var lat: Double?
    var lng: Double?
    var postalCode: String?
    var cc: String?
    var city: String?
    var state: String?
    var formattedAddress: [String]?
    
    enum CodingKeys: String, CodingKey {
        case address
        case crossStreet
        case lat
        case lng
        case postalCode
        case cc
        case city
        case state
        case formattedAddress
    }

    init(address: String?, crossStreet: String?, lat: Double?, lng: Double?, postalCode: String?, cc: String?, city: String?, state: String?, formattedAddress: [String]?) {
        self.address = address
        self.crossStreet = crossStreet
        self.lat = lat
        self.lng = lng
        self.postalCode = postalCode
        self.cc = cc
        self.city = city
        self.state = state
        self.formattedAddress = formattedAddress
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let address = try container.decodeIfPresent(String.self, forKey: .address)
        let crossStreet = try container.decodeIfPresent(String.self, forKey: .crossStreet)
        let lat = try container.decodeIfPresent(Double.self, forKey: .lat)
        let lng = try container.decodeIfPresent(Double.self, forKey: .lng)
        let postalCode = try container.decodeIfPresent(String.self, forKey: .postalCode)
        let cc = try container.decodeIfPresent(String.self, forKey: .cc)
        let city = try container.decodeIfPresent(String.self, forKey: .city)
        let state = try container.decodeIfPresent(String.self, forKey: .state)
        let formattedAddress = try container.decodeIfPresent([String].self, forKey: .formattedAddress)

        self.init(address: address, crossStreet: crossStreet, lat: lat, lng: lng, postalCode: postalCode, cc: cc, city: city, state: state, formattedAddress: formattedAddress)
    }

}

struct Restaurant: Decodable {
    var name: String?
    var backgroundImageURL: String?
    var category: String?
    var contact: Contact?
    var location: ResLocation?
    
    enum CodingKeys: String, CodingKey {
        case name
        case backgroundImageURL
        case category
        case contact
        case location
    }
    
    init(name: String?, backgroundImageURL: String?, category: String?, contact: Contact?,  location: ResLocation?) {
        self.name = name
        self.backgroundImageURL = backgroundImageURL
        self.category = category
        self.contact = contact
        self.location = location
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decodeIfPresent(String.self, forKey: .name)
        let backgroundImageURL = try container.decodeIfPresent(String.self, forKey: .backgroundImageURL)
        let category = try container.decodeIfPresent(String.self, forKey: .category)
        let contact = try container.decodeIfPresent(Contact.self, forKey: .contact)
        let location = try container.decodeIfPresent(ResLocation.self, forKey: .location)

        self.init(name: name, backgroundImageURL: backgroundImageURL, category: category, contact: contact, location: location)
    }
}

struct Restaurants: Decodable {
    var restaurantList: [Restaurant]
    
    enum CodingKeys: String, CodingKey {
        case restaurants
    }
    
    init(restaurantList: [Restaurant]?) {
        self.restaurantList = restaurantList ?? []
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let list = try container.decodeIfPresent([Restaurant].self, forKey: .restaurants)
        
        self.init(restaurantList: list)
    }
}

