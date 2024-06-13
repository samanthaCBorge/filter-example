//
//  ViewModel.swift
//  FilterExample
//
//  Created by Samantha Cruz on 18/4/24.
//

import Combine
import SwiftUI

enum FilterType: String, CaseIterable {
    case name
    case username
    case email
    
    var value: Int {
        switch self {
        case .name:
            return 0
        case .username:
            return 1
        case .email:
            return 2
        }
    }
    
    var nameValue: String {
        switch self {
        case .name:
            return "Fullname"
        case .username:
            return "Username"
        case .email:
            return "E-mail"
        }
    }
}

@Observable 
final class HomeViewModel {
    
    var users = [UserReponse]()
    var searchText = ""
    var type: FilterType = .name
    
    private var cancellables = Set<AnyCancellable>()
    private let store: HomeListStore
    
    init(store: HomeListStore = APIManager()) {
        self.store = store
    }
}

extension HomeViewModel  {
    
    var values: [String] {
        let keyPath: KeyPath<UserReponse, String>
        
        switch type {
        case .name:
            keyPath = \.name
        case .username:
            keyPath = \.username
        case .email:
            keyPath = \.email
        }
        
        return users.map { $0[keyPath: keyPath] }
            .filter { searchText.isEmpty ? true : $0.contains(searchText) }
    }
    
    func loadData() {
        let recieved = { (response: [UserReponse]) -> Void in
            DispatchQueue.main.async { [unowned self] in
                users = response
            }
        }
        
        let completion = { (completion: Subscribers.Completion<Failure>) -> Void in
            switch  completion {
            case .finished:
                break
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
        
        store.readUsersList()
            .sink(receiveCompletion: completion, receiveValue: recieved)
            .store(in: &cancellables)
    }
    
}

