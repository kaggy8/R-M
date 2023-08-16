//
//  MainViewController.swift
//  R&M
//
//  Created by Stanislav Demyanov on 26.01.2023.
//

import UIKit
import MBProgressHUD

class MainViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var characterLabel: UILabel!
    
    // MARK: - Public properties
    
    let searchController = UISearchController(searchResultsController: nil)

    
    // MARK: - Private properties
    
    private var pagesNum = CharactersModel()
    private var searchDataCharacters = [CharacterSet]()
    private var data: [CharacterSet]? = []
    private var pageNumber = 1
    private var service = NetworkManager()
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        initializeSetup()
        applyStyle()
        setupText()
        searchControlSetup()
    }
    
    // MARK: - Private methods
    
    private func loadData() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.service.getResult(page: self.pageNumber) { (searchResponse) in
            switch searchResponse {
            case .success(let data):
                guard let data = data else { return }
                
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.pageNumber += 1
                    self.data?.append(contentsOf: data.results ?? [])
                    self.tableView.reloadData()
                    self.characterLabel.text = "Rick & Morty Characters!"
                    self.pagesNum = data
                }
                
            case .failure(_):
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
    
    private func loadChar(name: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.service.getCharName(name: name) { (searchResponse) in
            switch searchResponse {
            case .success(let data):
                guard let data = data else { return }
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.searchDataCharacters.append(contentsOf: data.results ?? [])
                    self.tableView.reloadData()
                    
                    if data.results == nil {
                        self.characterLabel.text = "Characters not found"
                    } else {
                        self.characterLabel.text = "Rick & Morty Characters!"
                    }
                }
            case .failure(_):
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
    
    private func initializeSetup() {
        tableView.register(UINib(nibName: "MortyTableViewCell", bundle: nil), forCellReuseIdentifier: "MortyTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        searchController.searchResultsUpdater = self
    }
}


extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (searchController.isActive ? searchDataCharacters : data )?.count ?? 0
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if pageNumber == (pagesNum.info?.pages ?? 0) + 1 {
        } else {
            if indexPath.row == (data?.count ?? 18) - 2 {
                loadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MortyTableViewCell", for: indexPath) as! MortyTableViewCell
        
        if self.searchController.isActive, searchController.searchBar.text?.count ?? 0 >= 3 {
            cell.configure(withModel: searchDataCharacters[indexPath.row])
        } else {
            cell.configure(withModel: data?[indexPath.row])
        }
        
        return cell
    }
}

// MARK: - Extension for TableView Delegate

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "CharacterViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CharacterViewController") as! CharacterViewController
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        if searchController.searchBar.text?.count ?? 0 >= 2 {
            vc.characterAttributes = searchDataCharacters[indexPath.row]
            vc.title = searchDataCharacters[indexPath.row].status
        } else {
            vc.characterAttributes = data?[indexPath.row]
            vc.title = data?[indexPath.row].status
        }
        navigationItem.searchController = searchController
        navigationItem.backBarButtonItem = backItem
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Extension for styling

extension MainViewController {
    
    func applyStyle() {
        view.backgroundColor = .systemGreen
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 10
        tableView.showsVerticalScrollIndicator = false
        searchController.searchBar.tintColor = UIColor.red
        searchController.searchBar.barTintColor = UIColor.red
        
    }
}

// MARK: - Extension for setup text

extension MainViewController {
    func setupText() {
        characterLabel.font = .boldSystemFont(ofSize: 24)
        characterLabel.textAlignment = .center
        characterLabel.text = "Rick & Morty characters!"
        characterLabel.backgroundColor = .systemGreen
    }
}

// MARK: - Extension for SearchBar (active if symbols count > 3)

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        if searchController.searchBar.text?.count ?? 0 >= 3 {
            searchDataCharacters = []
            loadChar(name: text ?? "")
        }
        if !searchController.isActive {
            searchDataCharacters = []
            loadData()
        }
    }
}

// MARK: - Extension for SearchBar's visuality

extension MainViewController {
    
    func searchControlSetup() {
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Find a character"
    }
}
