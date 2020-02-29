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
    
    var userFilteredtems: [User] = []
    {
        didSet {
            if let reload = self.reloadTableView {
                reload()
            }
        }
    }
    
    var userItems: [User] = []
    {
        didSet {
            if let reload = self.reloadTableView {
                reload()
            }
        }
    }
    
    var blackList: [String] = []
    
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
    
    func checkBlackList(text: String) {
        
        if text.count == 3 {
            let isBlocked = blackList.contains { (string) -> Bool in
                string.lowercased().contains(text.lowercased())
            }
            if isBlocked {
                userFilteredtems = []
                return
            }
        }
        self.getFilterList(text: text)
    }
    
    func getFilterList(text: String) {
        let filteredArray = userItems.filter { (user) -> Bool in
            (user.username?.lowercased().contains(text.lowercased()) ?? false)
        }
        self.userFilteredtems = filteredArray
        if filteredArray.count == 3 {
            blackList.append(text)
        }
    }
    
}

