//
//  AssistCoClient.swift
//  Assist
//
//  Created by christopher ketant on 11/13/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

class AssistCoClient: NSObject {
    
    static let sharedInstance = AssistClient(baseURLString: Constants.devURLString)
    
    var baseURLString: String!
    
    init(baseURLString: String) {
        super.init()
        self.baseURLString = baseURLString
    }

}
