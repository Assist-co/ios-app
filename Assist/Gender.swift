//
//  Gender.swift
//  Assist
//
//  Created by christopher ketant on 11/13/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

class Gender: NSObject {
    var display: String!
    var sort: Int!
    var permalink: String!
    override var description: String{
        return "Gender: \(display!)"
    }
    
    init(dictionary: NSDictionary) {
        self.display  = dictionary["display"] as! String
        self.sort     = dictionary["sort"] as! Int
        self.permalink = dictionary["permalink"] as! String
    }
    
    class func genders(array: [NSDictionary]) -> [Gender]{
        var genders = [Gender]()
        for dictionary in array {
            let gender = Gender(dictionary: dictionary)
            genders.append(gender)
        }
        return genders
    }
}
