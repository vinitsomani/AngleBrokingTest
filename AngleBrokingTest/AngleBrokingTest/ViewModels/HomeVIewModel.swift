//
//  HomeVIewModel.swift
//  AngleBrokingTest
//
//  Created by A1Technology on 2/29/20.
//  Copyright © 2020 vinit.somani. All rights reserved.
//

import Foundation

protocol HomeViewModelDelegate: NSObjectProtocol {
    func fetchingFailed(_ shouldRetry: Bool, message: String)
}

class HomeViewModel: Any {
    
    weak var delegate: HomeViewModelDelegate?
    var reloadTableView : (() -> Void)? = nil
    var userItems: [User] = []
    {
        didSet {
            if let reload = self.reloadTableView {
                reload()
            }
        }
    }
    
    func callHomeData() {
        var service = Service.init(httpMethod: WebserviceHTTPMethod.get)
        service.url = homeServiceUrl
        ServiceManager.processDataFromServer(service: service, model: HomeDataModel.self) { [weak self] (response, error) in
            
            guard let self = self else {
                return
            }
            
            if(error != nil)
            {
                print(error.debugDescription)
                self.delegate?.fetchingFailed(false, message: "")
                return
            }
            
            if let res = response {
                if let users = res.users {
                    self.userItems.append(contentsOf: users)
                }
            } else {
                self.delegate?.fetchingFailed(false, message: "")
            }
        }
    }
}

