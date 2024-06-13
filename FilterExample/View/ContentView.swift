//
//  ContentView.swift
//  FilterExample
//
//  Created by Samantha Cruz on 10/4/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            Picker("", selection: $viewModel.type) {
                ForEach(FilterType.allCases, id: \.rawValue) { segment in
                    Text(segment.nameValue)
                        .tag(segment)
                }
            }
            .padding()
            .pickerStyle(.segmented)
            
            List(viewModel.values, id: \.self) { item in
                Text(item)
            }
            .onAppear {
                viewModel.loadData()
            }
        }
        .searchable(text: $viewModel.searchText)
        .onAppear {
            viewModel.loadData()
        }
    }
}

#Preview {
    ContentView()
}
