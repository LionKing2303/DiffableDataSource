//
//  CustomSubscriber.swift
//  DiffableDataSourceApp
//
//  Created by Arie Peretz on 21/06/2021.
//

import Combine
import Foundation

extension Publisher where Failure == Never {
    func perform(task: @escaping ((Output)->Void)) {
        self.subscribe(CustomSubscriber(with: task))
    }
}

class CustomSubscriber<Input>: Subscriber {
    typealias Failure = Never
    
    var closure: ((Input)->Void)
    init(with action: @escaping ((Input)->Void)) {
        self.closure = action
    }
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    func receive(_ input: Input) -> Subscribers.Demand {
        closure(input)
        return .none
    }
    func receive(completion: Subscribers.Completion<Never>) {}
}

