//
//  ContentView.swift
//  CategoriesScreen
//
//  Created by Артём Грищенко on 10.12.2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model = CategoriesViewModel()
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        VStack {
            topAlert
            if (model.isFinished) { categoriesNumber }
            else { categoriesList }
        }
    }
    
    var topAlert: some View {
        let title = model.isFinished ? "Выбрано категорий: " : "Отметьте то, что вам интересно, чтобы настроить Дзен"
        return HStack {
            Text(title)
            if (!model.isFinished) {
                Spacer()
                Button("Позже")
                    {
                        model.toggleIsFinished(isLaterButton: true)
                    }
                    .foregroundColor(.primary)
                    .padding(EdgeInsets(top: DrawingConstants.alertButtonVerticalPadding, leading: DrawingConstants.alertButtonHorizontalPadding, bottom: DrawingConstants.alertButtonVerticalPadding, trailing: DrawingConstants.alertButtonHorizontalPadding))
                    .background(hexStringToUIColor(hex: colorScheme == .light ? DrawingConstants.alertButtonBackgroundColor : DrawingConstants.alertButtonDarkModeBackgroundColor))
                    .cornerRadius(25)
            }
        }
        .padding(10)
    }
    
    var categoriesNumber: some View {
        VStack {
            Text(String(model.numberOfSelectedCategories))
                .font(.largeTitle)
                .padding(.bottom, 10)
            Button("Выбрать заново")
                {
                    model.toggleIsFinished()
                }
                
        }
        .frame(maxHeight: .infinity)
    }
    
    @State var scrollViewOffset: CGFloat = .zero
    var categoriesList: some View {
        var x: CGFloat = .zero
        var y: CGFloat = .zero
        
        let horizontalPadding: CGFloat = 5
        
        return GeometryReader { geometry in
            if (model.categories.isEmpty) {
                ZStack {
                    ProgressView()
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
            } else {
                ScrollView {
                    ZStack(alignment: .topLeading) {
                        Group {
                            ForEach(model.categories) { category in
                                CategoryButton(category: category) { id in
                                    model.toggleCategory(id)
                                }
                                .alignmentGuide(.leading) { d in
                                    if (abs(x - d.width - 2 * horizontalPadding) > geometry.size.width) {
                                        x = 0
                                        y -= d.height
                                    }
                                    let res = x
                                    if (model.categories.last!.id == category.id) {
                                        x = 0
                                    } else {
                                        x -= d.width
                                    }
                                    return res
                                }
                                .alignmentGuide(.top) { d in
                                    let res = y
                                    if (model.categories.last!.id == category.id) {
                                        y = 0
                                    }
                                    return res
                                }
                            }
                        }
                        .padding(.bottom, model.numberOfSelectedCategories > 0 ? 75 : 0)
                        .zIndex(1)
                        
                        if (model.numberOfSelectedCategories > 0) {
                            continueButton
                                .position(x: geometry.size.width / 2,  y: geometry.size.height - scrollViewOffset - (isIPhoneXOrAbove ? 15 : 45))
                                .zIndex(2)
                        }
                        GeometryReader { geometry in
                            let offset = geometry.frame(in: .named("categoriesScroll")).minY
                            Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self, value: offset)
                        }
                    }
                }
                .padding(.leading, horizontalPadding)
                .coordinateSpace(name: "categoriesScroll")
                .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
                    print(value)
                    scrollViewOffset = value
                }
            }
        }
    }
    
    var continueButton: some View {
        let color = "#fc8d17"
        return Button
            {
                model.toggleIsFinished()
            } label: {
                Text("Продолжить")
                    .frame(maxWidth: .infinity)
                    .padding(22)
                    .foregroundColor(.white)
                    .font(.title2)
            }
            .background(hexStringToUIColor(hex: color))
            .cornerRadius(25)
            .padding(.horizontal, 30)
    }
    
    private struct DrawingConstants {
        static let alertButtonBackgroundColor = "#e3e8e5"
        static let alertButtonDarkModeBackgroundColor = "#10151c"
        static let alertButtonVerticalPadding: CGFloat = 10
        static let alertButtonHorizontalPadding: CGFloat = 20
    }
}

struct CategoryButton: View {
    let category: CategoriesModel.Category
    let onTap: (Int) -> Void
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var backgroundColor: Color {
        if (category.isSelected) {
            return hexStringToUIColor(hex: ButtonConstants.selectedBackgroundColor)
        }
        if (colorScheme == .dark) {
            return hexStringToUIColor(hex: ButtonConstants.darkModeBackgroundColor)
        }
        return hexStringToUIColor(hex: ButtonConstants.backgroundColor)
    }
    
    var body: some View {
        HStack {
            Image(systemName: category.iconName)
            Text(category.label)
        }
        .padding(EdgeInsets(top: 12, leading: 25, bottom: 12, trailing: 25))
        .foregroundColor(category.isSelected ? .white : .primary)
        .background(backgroundColor)
        .cornerRadius(10)
        .padding(4)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                onTap(category.id)
            }
        }
    }
    
    private struct ButtonConstants {
        static let backgroundColor = "#e3e8e5"
        static let darkModeBackgroundColor = "#10151c"
        static let selectedBackgroundColor = "#fc8d17"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
