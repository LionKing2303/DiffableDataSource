//
//  ViewController.swift
//  DiffableDataSourceApp
//
//  Created by Arie Peretz on 20/06/2021.
//

import UIKit
import Combine

enum Section: Int {
    case parents = 0
    case children
    
    func title() -> String {
        switch self {
        case .parents:
            return "Parents"
        case .children:
            return "Children"
        }
    }
    
}

struct Parent: Hashable {
    let name: String
}

struct Child: Hashable {
    let nickname: String
    let age: Int
}

enum Item: Hashable {
    case parent(Parent)
    case child(Child)
}

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: UITableViewDiffableDataSource<Section,Item>!
    var viewModel: ViewModel = .init()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        viewModel.$items
            .perform(task: applySnapshot)
    }

    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, model) -> UITableViewCell? in
            switch model {
            case .parent(let parent):
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.textLabel?.text = parent.name
                return cell
            case .child(let child):
                let cell = tableView.dequeueReusableCell(withIdentifier: "red_cell", for: indexPath)
                cell.textLabel?.text = "\(child.nickname) is \(child.age) years old"
                return cell
            }
        })
    }
    
    func applySnapshot(with items: [Item]) {
        print("Applying Snapshot with items:")
        print(items)
        var snapshot = NSDiffableDataSourceSnapshot<Section,Item>()
        snapshot.appendSections([.parents])
        snapshot.appendItems(items, toSection: .parents)
        dataSource.apply(snapshot)
    }    
}
