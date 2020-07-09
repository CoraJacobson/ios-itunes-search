//
//  SearchResultsTableViewController.swift
//  iTunesSearch
//
//  Created by Cora Jacobson on 7/8/20.
//  Copyright © 2020 Cora Jacobson. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {
    
    let searchResultController = SearchResultController()
    
    @IBOutlet weak var searchTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var searchTermSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTermSearchBar.delegate = self
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultController.searchResult.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath)
        let searchResult = searchResultController.searchResult[indexPath.row]
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.creator
        return cell
    }

}

extension SearchResultsTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else { return }
        searchBar.resignFirstResponder()
        let resultType: ResultType!
        switch searchTypeSegmentedControl.selectedSegmentIndex {
        case 0:
            resultType = ResultType.software
        case 1:
            resultType = ResultType.musicTrack
        default:
            resultType = ResultType.movie
        }
        searchResultController.performSearch(searchTerm: searchTerm, resultType: resultType) { error in
            if let error = error {
                print("Search error: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}
