//
//  ViewModel.swift
//  DiffableDataSourceApp
//
//  Created by Arie Peretz on 21/06/2021.
//

import Foundation
import Combine

extension ViewController {
    final class ViewModel: ObservableObject {
        @Published var items: [Item] = []
        
        init() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                self?.items = [
                    .parent(Parent(name: "Father")),
                    .child(Child(nickname: "Little Bird", age: 18))
                    ]
            }
        }
    }
}
