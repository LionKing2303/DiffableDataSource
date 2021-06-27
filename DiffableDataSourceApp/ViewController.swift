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

struct MyResponse: Codable {
    let info: String?
}

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: UITableViewDiffableDataSource<Section,Item>!
    var viewModel: ViewModel = .init()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
//        let x = ApplySnapshotSubscriber(to: Section.parents, on: dataSource)
        
        viewModel.$items
            .apply(to: Section.parents, on: dataSource)
            .store(in: &cancellables)
//            .execute(with: applySnapshot)
//            .store(in: &cancellables)
//            .store(in: &cancellables)
//        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
//
//        var request: URLRequest = URLRequest(url: URL(string: "http://localhost:3000/redirect-put")!)
//        request.httpMethod = "PUT"
//        session.dataTaskPublisher(for: request)
//            .print()
//            .map(\.data)
//            .replaceError(with: Data())
//            .decode(type: MyResponse.self, decoder: JSONDecoder())
//            .replaceError(with: MyResponse.init(info: nil))
//            .sink(receiveValue: { (response) in
//                print(response)
//            })
//            .store(in: &cancellables)
//            .execute { (data) in
//                print(data)
//            }
//            .store(in: &cancellables)
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
        var snapshot = NSDiffableDataSourceSnapshot<Section,Item>()
        snapshot.appendSections([.parents])
        snapshot.appendItems(items, toSection: .parents)
        dataSource.apply(snapshot)
    }    
}

extension ViewController: URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        print("REDIRECT")
        print("RESPONSE:")
        print(response.debugDescription)
        print("NEW REQUEST:")
        print(request.debugDescription)
//        print(request.httpMethod)
        var newRequest = URLRequest(url: request.url!)
        newRequest.httpMethod = "GET"
        completionHandler(newRequest)
        
    }
}
