//
//  HomeViewController.swift
//  AngleBrokingTest
//
//  Created by A1Technology on 2/29/20.
//  Copyright © 2020 vinit.somani. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    var homeViewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeView()
        configureSearchOnNavigation()
    }

    private func configureHomeView() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "User View"
        self.tableView.register(UINib(nibName: HomeCellIdentifier, bundle: nil), forCellReuseIdentifier: HomeCellIdentifier)
        noDataLabel.isHidden = true
        listenToReloadClosure()
        getHomeData()
    }
    
    private func configureSearchOnNavigation() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        searchController.searchBar.showsCancelButton = false
    }
    
    func listenToReloadClosure() {
        homeViewModel.reloadTableView = { [weak self] in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                self.activity.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    
    func getHomeData() {
        activity.startAnimating()
        homeViewModel.callHomeData()
    }
}



extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        noDataLabel.isHidden = (self.navigationItem.searchController?.searchBar.text?.count ?? 0 > 2 && self.homeViewModel.userFilteredtems.count == 0) ? false : true

        return self.homeViewModel.userFilteredtems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: HomeCellIdentifier, for: indexPath) as? HomeTableViewCell else {
            print("error fetching cell")
            return UITableViewCell()
        }
        
        let userModel = self.homeViewModel.userFilteredtems[indexPath.row]
        tableViewCell.populateData(item: userModel)
        return tableViewCell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
      func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItemDelete = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            //delete pressed
        }
        let contextItemAdd = UIContextualAction(style: .normal, title: "Add") {  (contextualAction, view, boolValue) in
            //add pressed
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItemDelete, contextItemAdd])

        swipeActions.performsFirstActionWithFullSwipe = false
        return swipeActions
    }
}


//MARK:- Searchbar Delegate
extension HomeViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            self.homeViewModel.userFilteredtems.removeAll()
            self.tableView.reloadData()
            self.view.endEditing(true)
        }
        if searchText.count > 2 {
            self.homeViewModel.checkBlackList(text: searchText)
        }
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func fetchingFailed(_ shouldRetry: Bool, message: String) {
        DispatchQueue.main.async {
            self.activity.stopAnimating()
        }
    }
}
