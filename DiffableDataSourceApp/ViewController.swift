//
//  ViewController.swift
//  DiffableDataSourceApp
//
//  Created by Arie Peretz on 20/06/2021.
//

import UIKit

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
    
    var items: [Item] = [
        Item.parent(Parent(name: "Father")),
        Item.child(Child(nickname: "Fun Son", age: 16))
    ]
    var subitems: [Item] = [
        Item.parent(Parent(name: "Test")),
        Item.child(Child(nickname: "Tester", age: 21))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        applySnapshot(with: items)
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
        let parents = items.filter { (item) -> Bool in
            switch item {
            case .parent: return true
            case .child: return false
            }
        }
        let children = items.filter { (item) -> Bool in
            switch item {
            case .parent: return false
            case .child: return true
            }
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section,Item>()
        snapshot.appendSections([.parents, .children])
        snapshot.appendItems(items, toSection: .parents)
        snapshot.appendItems(subitems, toSection: .children)
        dataSource.apply(snapshot)
    }
    
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel()
        label.text = Section(rawValue: section)?.title()
        return label
    }
}
