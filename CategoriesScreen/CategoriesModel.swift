//
//  CategoriesModel.swift
//  CategoriesScreen
//
//  Created by Артём Грищенко on 10.12.2022.
//

import Foundation

struct CategoriesModel {
    private(set) var categories = [Category]()
    var isFinished = false
    
    struct Category: Identifiable, Hashable {
        var id: Int
        var label: String
        var iconName: String
        var isSelected: Bool = false
        
        fileprivate init(id: Int, label: String, iconName: String) {
            self.id = id
            self.label = label
            self.iconName = iconName
        }
    }
    
    init() { }
    
    mutating func addCategory(_ id: Int, _ label: String, _ iconName: String) {
        categories.append(Category(id: id, label: label, iconName: iconName))
    }
    
    mutating func toggleCategoryById(_ id: Int) {
        if let index = categories.firstIndex(where: { id == $0.id }) {
            categories[index].isSelected.toggle()
        }
    }
    
    mutating func makeAllCategoriesNotSelected() {
        for i in categories.indices {
            categories[i].isSelected = false
        }
    }
    
    mutating func toggleIsFinished(isLaterButton: Bool = false) {
        if (isFinished || isLaterButton) {
            makeAllCategoriesNotSelected()
        }
        isFinished.toggle()
    }
    
}
