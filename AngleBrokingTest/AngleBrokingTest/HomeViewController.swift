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
    @IBOutlet weak var searchView: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headingTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var headingCenterXConstraint: NSLayoutConstraint!
    
    
    var defaultOffSet: CGPoint?
    var labelMaxTop = 130
    var labelMinTop = 30
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        defaultOffSet = tableView.contentOffset
    }
    
    
    private func configureTableView() {
        self.tableView.register(UINib(nibName: HomeCellIdentifier, bundle: nil), forCellReuseIdentifier: HomeCellIdentifier)
        self.tableView.reloadData()
    }


}



extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: HomeCellIdentifier, for: indexPath) as? HomeTableViewCell else {
            print("error fetching cell")
            return UITableViewCell()
        }
        
        tableViewCell.textLabel?.text = "\(indexPath.row)"
        return tableViewCell
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = tableView.contentOffset

        if let startOffset = self.defaultOffSet {
            if offset.y < startOffset.y {
                // Scrolling down
                // check if your collection view height is less than normal height, do your logic.


                let deltaY = abs((startOffset.y - offset.y))
                
                
                let maxDiff = (headingTopConstraint.constant + deltaY) <= 130 ? (headingTopConstraint.constant + deltaY) : 130
                
                headingTopConstraint.constant = maxDiff
                

            } else {
                // Scrolling up
                let deltaY = abs((startOffset.y - offset.y))
                let maxDiff = (headingTopConstraint.constant - deltaY) >= 30 ? (headingTopConstraint.constant - deltaY) : 30
                headingTopConstraint.constant = maxDiff
            }

            self.view.layoutIfNeeded()
        }
    }
}

