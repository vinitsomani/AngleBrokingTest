//
//  HomeViewController.swift
//  AngleBrokingTest
//
//  Created by A1Technology on 2/29/20.
//  Copyright © 2020 vinit.somani. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var hoderView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headingTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var headingLeadingConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    
    @IBOutlet weak var noDataLabel: UILabel!
    
    
    
    var defaultOffSet: CGPoint?
    var labelMaxTop = 130
    var labelMinTop = 30
    
    var homeViewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHomeView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        defaultOffSet = tableView.contentOffset
    }
    
    
    private func configureHomeView() {
        self.tableView.register(UINib(nibName: HomeCellIdentifier, bundle: nil), forCellReuseIdentifier: HomeCellIdentifier)
        searchBar.delegate = self
        noDataLabel.isHidden = true
        listenToReloadClosure()
        getHomeData()
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

        noDataLabel.isHidden = (self.searchBar.text?.count ?? 0 > 2 && self.homeViewModel.userFilteredtems.count == 0) ? false : true

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
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = tableView.contentOffset

        if let startOffset = self.defaultOffSet {
            if offset.y < startOffset.y {
                // Scrolling down
                let deltaY = abs((startOffset.y - offset.y))
                let maxYDiff = (headingTopConstraint.constant + deltaY) <= 130 ? (headingTopConstraint.constant + deltaY) : 130

                
                headingTopConstraint.constant = maxYDiff

                let scale = min(max(1.0 - deltaY / 100, 0.0), 1.0)
                if headingTopConstraint.constant == 130 {
                    headingLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//                    headingLeadingConstraint.constant = 0
                }
                else {
                    headingLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
//                    headingLeadingConstraint.constant = headingLeadingConstraint.constant + deltaY
                }
                
                
            } else {
                // Scrolling up
                let deltaY = abs((startOffset.y - offset.y))
                let maxDiff = (headingTopConstraint.constant - deltaY) >= 10 ? (headingTopConstraint.constant - deltaY) : 10
                    let scale = min(max(1.0 - deltaY / 100, 0.0), 1.0)

                
                headingTopConstraint.constant = maxDiff
                if headingTopConstraint.constant == 10 {
                    headingLabel.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
//                    headingLeadingConstraint.constant = vScreenWidth/2 - headingLabel.frame.width/2
                }
                else {
                    headingLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
//                    headingLeadingConstraint.constant = headingLeadingConstraint.constant + maxDiff
                }
                
            }

            self.view.layoutIfNeeded()
        }
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
