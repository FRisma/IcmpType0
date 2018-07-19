//
//  ITLandingMainViewController.swift
//  IcmpType0
//
//  Created by Franco Risma on 19/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation
import UIKit

class ITLandingMainViewController: UIViewController, ITLandingMainViewControllerProtocol, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView: UITableView!
    private let presenter: ITLandingMainViewPresenterProtocol!
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.applyContraints()
    }
    
    // MARK: ITLandingMainViewControllerProtocol
    
    // MARK: UITableViewDelegate & UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    // MARK: Internal
    func applyContraints() {
        
    }
}
