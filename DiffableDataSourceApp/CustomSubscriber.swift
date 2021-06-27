//
//  CustomSubscriber.swift
//  DiffableDataSourceApp
//
//  Created by Arie Peretz on 21/06/2021.
//

import Combine
import Foundation
import UIKit

extension Publisher where Failure == Never {
    func execute(with closure: @escaping ((Output)->Void)) -> AnyCancellable {
        self.sink(receiveValue: closure)
    }
}

extension Publisher where Output: Sequence, Output.Element: Hashable, Failure == Never {
    func apply<S:Hashable>(to section: S, on datasource: UITableViewDiffableDataSource<S,Output.Element>) -> AnyCancellable {
        self.sink { items in
                var snapshot = NSDiffableDataSourceSnapshot<S,Self.Output.Element>()
                snapshot.appendSections([section])
                snapshot.appendItems(Array(items), toSection: section)
                datasource.apply(snapshot, animatingDifferences: true)
            }
    }
}

//class ApplySnapshotSubscriber<S: Hashable,Model:Hashable>: Subscriber {
//    typealias Input = [Model]
//    typealias Failure = Never
//    
//    var section: S
//    var datasource: UITableViewDiffableDataSource<S,Model>
//    init(to section: S, on datasource: UITableViewDiffableDataSource<S,Model>) {
//        self.section = section
//        self.datasource = datasource
//    }
//    
//    func receive(subscription: Subscription) {
//        subscription.request(.unlimited)
//    }
//    
//    func receive(_ input: Input) -> Subscribers.Demand {
//        var snapshot = NSDiffableDataSourceSnapshot<S,Model>()
//        snapshot.appendSections([section])
//        snapshot.appendItems(input, toSection: section)
//        datasource.apply(snapshot, animatingDifferences: true)
//        return .none
//    }
//    
//    func receive(completion: Subscribers.Completion<Never>) {}
//}
//
//class CustomSubscriber<T>: Subscriber {//, Cancellable {
//    typealias Input = T
//    typealias Failure = Never
//    
//    var closure: ((T)->Void)
////    private var subscription: Subscription?
//    init(with closure: @escaping ((T)->Void)) {
//        self.closure = closure
//    }
//    
//    func receive(subscription: Subscription) {
////        self.subscription = subscription
//        subscription.request(.unlimited)
//    }
//    func receive(_ input: T) -> Subscribers.Demand {
//        closure(input)
//        return .none
//    }
//    func receive(completion: Subscribers.Completion<Never>) {}
//    
////    func cancel() {
////        subscription?.cancel()
////        subscription = nil
////    }
//}

