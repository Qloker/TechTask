//
//  ViewController.swift
//  VkTask
//
//  Created by Ilia Zakharov on 14.07.2022.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    // MARK: - Views and properties
    private var getDataForTable = TechAPI()
    private var service: [Service] = []
    
    private let vkTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let vkCell = "vkCell"
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Сервисы VK"
        
        getDataForTable.getData { result in
            self.service = result
            
            DispatchQueue.main.async {
                self.vkTable.reloadData()
            }
        }
        
        vkTable.register(CustomCell.self, forCellReuseIdentifier: vkCell)
        view.addSubview(vkTable)
        setDelegates()
        setConstraints()
    }
    
    // MARK: - Actions
    private func setConstraints() {
        NSLayoutConstraint.activate([
            vkTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            vkTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vkTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vkTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    private func setDelegates() {
        vkTable.delegate = self
        vkTable.dataSource = self
    }
}


// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        service.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = vkTable.dequeueReusableCell(withIdentifier: vkCell, for: indexPath) as? CustomCell else  { return UITableViewCell() }
        
        let model: Service = service[indexPath.row]
        cell.config(result: model)
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model: Service = service[indexPath.row]
        
        guard let url = URL(string: model.link) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            print("Smth went wrong")
            return
        }
    }
}
