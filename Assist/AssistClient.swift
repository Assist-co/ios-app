//
//  AssistClient.swift
//  Assist
//
//  Created by Bryce Aebi on 11/9/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit
import Alamofire

class AssistClient: NSObject {
    
    static let sharedInstance = AssistClient(baseURLString: Constants.devURLString)
    var session: Alamofire.SessionManager!
    private var baseURLString: String!
    
    init(baseURLString: String) {
        super.init()
        self.baseURLString = baseURLString
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        self.session = Alamofire.SessionManager()
    }
    
    func addSessionHeader(_ key: String, value: String){
        if var sessionHeaders = self.session.session.configuration.httpAdditionalHeaders as? Dictionary<String, String>{
            sessionHeaders[key] = value
            self.session.session.configuration.httpAdditionalHeaders = sessionHeaders
        }
    }
    
    func removeSessionHeaderIfExists(_ key: String){
        if var sessionHeaders = self.session.session.configuration.httpAdditionalHeaders as? Dictionary<String, String>{
            sessionHeaders.removeValue(forKey: key)
            self.session.session.configuration.httpAdditionalHeaders = sessionHeaders
        }
    }

}
