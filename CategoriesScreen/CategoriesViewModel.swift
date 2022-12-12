//
//  CategoriesViewModel.swift
//  CategoriesScreen
//
//  Created by Артём Грищенко on 10.12.2022.
//

import SwiftUI

class CategoriesViewModel : ObservableObject {
    @Published var model: CategoriesModel
    
    private func fillTestCategories() {
        model.addCategory(0, "Юмор", "face.smiling")
        model.addCategory(1, "Еда", "fork.knife")
        model.addCategory(2, "Кино", "film")
        model.addCategory(3, "Автомобили", "car")
        model.addCategory(4, "Прогулки", "figure.walk")
        model.addCategory(5, "Рестораны", "fork.knife")
        model.addCategory(6, "Политика", "case")
        model.addCategory(7, "Новости", "newspaper")
        model.addCategory(8, "Сериалы", "list.and.film")
        model.addCategory(9, "Рецепты", "book.closed")
        model.addCategory(10, "Работа", "briefcase")
        model.addCategory(11, "Отдых", "leaf")
        model.addCategory(12, "Спорт", "sportscourt")
        model.addCategory(13, "Новости", "newspaper")
        model.addCategory(14, "Сериалы", "list.and.film")
        model.addCategory(15, "Рецепты", "book.closed")
        model.addCategory(16, "Работа", "briefcase")
        model.addCategory(17, "Отдых", "leaf")
        model.addCategory(18, "Спорт", "sportscourt")
        model.addCategory(19, "Прогулки", "figure.walk")
        model.addCategory(20, "Рестораны", "fork.knife")
        model.addCategory(21, "Политика", "case")
        model.addCategory(22, "Новости", "newspaper")
        model.addCategory(23, "Сериалы", "list.and.film")
        model.addCategory(24, "Рецепты", "book.closed")
        model.addCategory(25, "Юмор", "face.smiling")
        model.addCategory(26, "Еда", "fork.knife")
        model.addCategory(27, "Кино", "film")
        model.addCategory(28, "Автомобили", "car")
        model.addCategory(29, "Прогулки", "figure.walk")
        model.addCategory(30, "Рестораны", "fork.knife")
        model.addCategory(31, "Политика", "case")
    }
    
    init () {
        model = CategoriesModel()
        fillTestCategories()
    }
    
    var categories: [CategoriesModel.Category] {
        model.categories
    }
    
    var isFinished: Bool {
        model.isFinished
    }
    
    var numberOfSelectedCategories: Int {
        model.categories.filter{ $0.isSelected }.count
    }
    
    // Intents
    
    func toggleCategory(_ id: Int) {
        model.toggleCategoryById(id)
    }
    
    func toggleIsFinished(isLaterButton: Bool = false) {
        model.toggleIsFinished(isLaterButton: isLaterButton)
    }
}
