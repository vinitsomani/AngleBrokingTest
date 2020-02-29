//
//  SessionManager.swift
//  AngleBrokingTest
//
//  Created by A1Technology on 2/29/20.
//  Copyright © 2020 vinit.somani. All rights reserved.
//

import UIKit

let message_EmptyData = "Empty Data"

enum JSONError: Error {
    case jsonErrorEmptyData(message:String)
}

enum HTTPHeaderKey: String {
    case accept                = "Accept"
    case contentType           = "Content-Type"
}

enum HTTPHeaderValue: String {
    case applicationJSON               = "application/json"
    case applicationFormURLEncoded     = "application/x-www-form-urlencoded; charset=utf-8"
    }

enum HTTPError: Error {
    case invalidResponse
    case invalidStatusCode
    case requestFailed(statusCode: Int, message: String)
}

enum HTTPStatusCodeMessage: String
{
    case notFound = "Not Found"
    case unKnown = "Unknown"
}

enum HTTPStatusCode: Int
{
    case success = 200
    case notFound = 404
    
    var isSuccessful: Bool {
        return (200..<300).contains(rawValue)
    }
}

class SessionManager: NSObject {
static let sharedInstance = SessionManager()

func processRequest(request: URLRequest,completionHandler:@escaping (Data?, Error?)->Void) {
        URLCache.shared.removeAllCachedResponses()
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
                try self.validate(response)
                guard let data = data else {
                    throw JSONError.jsonErrorEmptyData(message: message_EmptyData)
                }
                completionHandler(data,error)
            }
            catch {
                completionHandler(data,error)
            }
        }
        task.resume()
    }
    
  private func validate(_ response: URLResponse?) throws
    {
        guard let response = response as? HTTPURLResponse else {
            throw HTTPError.invalidResponse
        }
        guard let status = HTTPStatusCode(rawValue: response.statusCode) else {
            throw HTTPError.invalidStatusCode
        }
        if !status.isSuccessful {
            switch status {
            case .notFound:
                 throw HTTPError.requestFailed(statusCode: status.rawValue, message: HTTPStatusCodeMessage.notFound.rawValue)
            default:
                throw HTTPError.requestFailed(statusCode: -1, message: HTTPStatusCodeMessage.unKnown.rawValue)
            }
        }
    }
    
}
