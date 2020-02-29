//
//  Service.swift
//  AngleBrokingTest
//
//  Created by A1Technology on 2/29/20.
//  Copyright © 2020 vinit.somani. All rights reserved.
//

import Foundation


enum WebserviceHTTPMethod: String {
    case get  =   "GET"
    case post =   "POST"
}

struct Service {
    var url: String!
    var httpMethod : WebserviceHTTPMethod
    var params : [String: Any]
    var headers : [String: Any]
    
    init(httpMethod :WebserviceHTTPMethod) {
        self.httpMethod = httpMethod
        self.params = [String: Any]()
        self.headers = [HTTPHeaderKey.accept.rawValue:HTTPHeaderValue.applicationJSON.rawValue,HTTPHeaderKey.contentType.rawValue:HTTPHeaderValue.applicationFormURLEncoded.rawValue]
    }
}
