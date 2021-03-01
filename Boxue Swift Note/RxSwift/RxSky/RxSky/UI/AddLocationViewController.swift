//
// Created by Bq Lin on 2021/2/27.
// Copyright (c) 2021 Bq. All rights reserved.
//

import UIKit
import CoreLocation

protocol AddLocationViewControllerDelegate {
    func controller(_ controller: AddLocationViewController, didAddLocation location: Location)
}

class AddLocationViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    var delegate: AddLocationViewControllerDelegate?
    
    var viewModel: AddLocationViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add a location"
        
        viewModel = AddLocationViewModel()
        viewModel.locationsDidChange = { [weak self] locations in
            guard let self = self else {
                return
            }
            self.tableView.reloadData()
        }
        viewModel.queryingStatusDidChange = { [weak self] isQuerying in
            guard let self = self else {
                return
            }
            if isQuerying {
                self.title = "Searching..."
            } else {
                self.title = "Add a location"
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Show Keyboard
        searchBar.becomeFirstResponder()
    }
}

extension AddLocationViewController {
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfLocations
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: LocationTableViewCell.reuseIdentifier,
            for: indexPath) as? LocationTableViewCell else {
            fatalError("Unexpected table view cell")
        }
        if let vm = viewModel.locationViewModel(at: indexPath.row) {
            cell.configure(with: vm)
        }
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let location = viewModel.location(at: indexPath.row) else { return }
        
        delegate?.controller(self, didAddLocation: location)
        navigationController?.popViewController(animated: true)
    }
}

extension AddLocationViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(
        _ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        viewModel.queryText = searchBar.text ?? ""
    }
    
    func searchBarCancelButtonClicked(
        _ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        viewModel.queryText = searchBar.text ?? ""
    }
}
