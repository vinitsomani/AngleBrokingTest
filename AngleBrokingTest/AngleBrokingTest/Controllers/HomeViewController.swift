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
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = tableView.contentOffset

        if let startOffset = self.defaultOffSet {
            if offset.y < startOffset.y {
                // Scrolling down
                let deltaY = abs((startOffset.y - offset.y))
                
                
                let maxYDiff = (headingTopConstraint.constant + deltaY) <= 130 ? (headingTopConstraint.constant + deltaY) : 130
                
                headingTopConstraint.constant = maxYDiff
                
                var changes = (30/130) * maxYDiff
                
                let maxXDiff = (headingLeadingConstraint.constant - changes) <= 0 ? 0 : (headingLeadingConstraint.constant - changes)
                headingLeadingConstraint.constant = maxXDiff

            } else {
                // Scrolling up
                let deltaY = abs((startOffset.y - offset.y))
                let maxDiff = (headingTopConstraint.constant - deltaY) >= 30 ? (headingTopConstraint.constant - deltaY) : 30
                headingTopConstraint.constant = maxDiff
                

                var changes = (30/130) * maxDiff
                
                var midScreen = vScreenWidth/2 - headingLabel.bounds.width/2
                
                let maxXDiff = (headingLeadingConstraint.constant + changes) >= midScreen ? midScreen : (headingLeadingConstraint.constant + changes)
                headingLeadingConstraint.constant = maxXDiff
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
