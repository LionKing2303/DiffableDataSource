//
//  ContentView.swift
//  DiffableDataSourceApp
//
//  Created by Arie Peretz on 21/06/2021.
//

import SwiftUI

struct CellView: View {
    var item: Item

    var body: some View {
        switch item {
        case .parent(let parent):
            return Text(parent.name)
        case .child(let child):
            return Text("\(child.nickname) is \(child.age) years old")
        }
    }
}

struct ContentView: View {
    @ObservedObject var viewModel: ViewController.ViewModel = .init()
    var body: some View {
        VStack {
            List(viewModel.items, id: \.self) { item in
                CellView(item: item)
            }
            .animation(.default)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
