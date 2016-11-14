//
//  ProfessionOption.swift
//  Assist
//
//  Created by christopher ketant on 11/13/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

class Profession: NSObject {
    var display: String!
    var sort: Int!
    var permalink: String!
    override var description: String{
        return "Profession: \(display!)"
    }
    
    init(dictionary: NSDictionary) {
        self.display  = dictionary["display"] as! String
        self.sort     = dictionary["sort"] as! Int
        self.permalink = dictionary["permalink"] as! String
    }
    
    class func professions(array: [NSDictionary]) -> [Profession]{
        var professions = [Profession]()
        for dictionary in array {
            let profession = Profession(dictionary: dictionary)
            professions.append(profession)
        }
        return professions
    }
}
