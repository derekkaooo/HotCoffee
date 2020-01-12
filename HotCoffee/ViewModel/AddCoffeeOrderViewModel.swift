//
//  AddCoffeeOrderViewModel.swift
//  HotCoffee
//
//  Created by Derek on 2020/1/12.
//  Copyright © 2020 Derek. All rights reserved.
//

import Foundation

struct AddCoffeeOrderViewModel {
    var name: String?
    var email: String?
    var selectedType: String?
    var selectedSize: String?
    
    var types: [String] {
        return CoffeeType.allCases.map { $0.rawValue.capitalized }
    }
    
    var sizes: [String] {
        return CoffeeSize.allCases.map { $0.rawValue.capitalized }
    }
}
