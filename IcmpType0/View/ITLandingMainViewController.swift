//
//  ITLandingMainViewController.swift
//  IcmpType0
//
//  Created by Franco Risma on 19/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ITLandingMainViewController: UIViewController, ITLandingMainViewControllerProtocol, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    private var tableView: UITableView!
    private let presenter: ITLandingMainViewPresenterProtocol!
    
    // This will hold the people you are writing to
    var peopleList: [Chat]? {
        didSet {
            peopleListFiltered = peopleList
        }
    }
    
    var peopleListFiltered: [Chat]?{
        didSet {
            self.tableView.reloadData()
        }
    }
    
    // MARK: Initialization
    init(usingPresenter presenter: ITLandingMainViewPresenterProtocol) {
        self.presenter = presenter
        tableView = UITableView(frame: .zero)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.definesPresentationContext = true
        
        self.setupNavBar()
        self.setupSearchController()
        self.setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.applyContraints()
        
        self.presenter.setViewDelegate(delegate: self)
        presenter.fetchConversations()
    }
    
    // MARK: ITLandingMainViewControllerProtocol
    func updateConversations(chats: Chats) {
        peopleList = chats.conversations
    }
    
    func goToConversation() {
        let backItem = UIBarButtonItem()
        backItem.title = "Chats"
        navigationItem.backBarButtonItem = backItem
        let convVC = ITConversationViewController(withPresenter: ITConversationPresenter())
        convVC.title = "Best Friend"
        self.navigationController?.pushViewController(convVC, animated: true)
    }
    
    func createNewConversation() {
        let backItem = UIBarButtonItem()
        backItem.title = "Chats"
        navigationItem.backBarButtonItem = backItem
        let newConvVC = ITConversationViewController(withPresenter: ITConversationPresenter())
        newConvVC.title = "The Bot"
        self.navigationController?.pushViewController(newConvVC, animated: true)
    }
    
    func showError(info: String?) {
        let alert = UIAlertController(title: "Error", message: info, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    // MARK: UITableViewDelegate & UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let currentChats = peopleListFiltered?.count {
            return currentChats
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "People") as! ITLandingMainTableViewCell
        
        if let aConv = peopleListFiltered?[indexPath.row] {
            cell.profileName.text = aConv.memberName
            cell.messageLabel.text = aConv.lastMessage
            let profPictureName = String("profile"+aConv.memberName.replacingOccurrences(of: " ", with: ""))
            let picture = UIImage(named: profPictureName)
            cell.profileImage.image = picture
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
            cell.dateLabel.text = dateFormatter.string(from: aConv.date)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let convVC = ITConversationViewController(withPresenter: ITFakeConversationPresenter())
        self.navigationController?.pushViewController(convVC, animated: true)
    }
    
    // MARK: UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        if searchText.count > 0 {
            peopleListFiltered?.removeAll()
            let array = peopleList?.filter {
                return $0.memberName.lowercased().contains(searchText.lowercased())
            }
            peopleListFiltered = array
        } else { //Reset to the original state
            if searchController.isActive {
                peopleListFiltered = peopleList
            }
        }
    }
    
    // MARK: Internal
    private func setupNavBar() {
        self.navigationItem.title = "Mensajes"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.compose, target: self, action: #selector(composeButtonTapped(_:)))
        navigationItem.rightBarButtonItem = button
    }
    
    private func setupSearchController() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.bounces = true
        tableView.register(ITLandingMainTableViewCell.self, forCellReuseIdentifier: "People")
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        self.view.addSubview(self.tableView)
    }
    
    func applyContraints() {
        self.tableView.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin)
            } else {
                make.top.equalTo(self.view)
            }
            make.left.right.bottom.equalTo(self.view)
        }
    }
    
    @objc func composeButtonTapped(_ sender: Any) {
        presenter.composeButtonTapped()
    }
}
