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
            if (model.isFinished) {
                finishedTopTitle
                categoriesNumber
            }
            else {
                topAlert
                categoriesList
                
            }
        }
    }
    
    var topAlert: some View {
        return HStack {
            Text(Constants.TopAlert.text)
            if (!model.isFinished) {
                Spacer()
                Button(Constants.TopAlert.LaterButton.text)
                    {
                        model.toggleIsFinished(isLaterButton: true)
                    }
                    .foregroundColor(.primary)
                    .padding(.vertical, Constants.TopAlert.LaterButton.verticalPadding)
                    .padding(.horizontal, Constants.TopAlert.LaterButton.horizontalPadding)
                    .background(colorScheme == .light ? Constants.TopAlert.LaterButton.backgroundColor : Constants.TopAlert.LaterButton.darkModeBackgroundColor)
                    .cornerRadius(Constants.TopAlert.LaterButton.cornerRadius)
            }
        }
        .padding(Constants.TopAlert.padding)
    }
    
    var finishedTopTitle: some View {
        return Text(Constants.Finished.topTitleText)
            .padding(Constants.Finished.topTitlePadding)
    }
    
    var categoriesNumber: some View {
        VStack {
            Text(String(model.numberOfSelectedCategories))
                .font(.largeTitle)
                .padding(.bottom, 10)
            Button(Constants.Finished.againButtonText)
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
        return Button
            {
                model.toggleIsFinished()
            } label: {
                Text(Constants.ContinueButton.text)
                    .frame(maxWidth: .infinity)
                    .padding(Constants.ContinueButton.padding)
                    .foregroundColor(.white)
                    .font(.title2)
            }
            .background(Constants.ContinueButton.color)
            .cornerRadius(Constants.ContinueButton.cornerRadius)
            .padding(.horizontal, 30)
    }
    
    private struct Constants {
        struct Finished {
            static let topTitlePadding: CGFloat = 10
            static let topTitleText = "Выбрано категорий: "
            static let againButtonText = "Выбрать заново"
        }
        struct TopAlert {
            static let text = "Отметьте то, что вам интересно, чтобы настроить Дзен"
            static let padding: CGFloat = 10
            struct LaterButton {
                static let text = "Позже"
                static let backgroundColor = hexStringToUIColor(hex: "#e3e8e5")
                static let darkModeBackgroundColor = hexStringToUIColor(hex: "#10151c")
                static let verticalPadding: CGFloat = 10
                static let horizontalPadding: CGFloat = 20
                static let cornerRadius: CGFloat = 25
            }
        }
        struct ContinueButton {
            static let text = "Продолжить"
            static let color = hexStringToUIColor(hex: "#fc8d17")
            static let cornerRadius: CGFloat = 25
            static let padding: CGFloat = 22
        }
    }
}

struct CategoryButton: View {
    let category: CategoriesModel.Category
    let onTap: (Int) -> Void
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var backgroundColor: Color {
        if (category.isSelected) {
            return Constants.selectedBackgroundColor
        }
        if (colorScheme == .dark) {
            return Constants.darkModeBackgroundColor
        }
        return Constants.backgroundColor
    }
    
    var body: some View {
        HStack {
            Image(systemName: category.iconName)
            Text(category.label)
        }
        .padding(.vertical, Constants.verticalPadding)
        .padding(.horizontal, Constants.horizontalPadding)
        .foregroundColor(category.isSelected ? Constants.selectedColor : .primary)
        .background(backgroundColor)
        .cornerRadius(Constants.cornerRadius)
        .padding(4)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                onTap(category.id)
            }
        }
    }
    
    private struct Constants {
        static let backgroundColor = hexStringToUIColor(hex: "#e3e8e5")
        static let selectedColor = Color.white
        static let darkModeBackgroundColor = hexStringToUIColor(hex: "#10151c")
        static let selectedBackgroundColor = hexStringToUIColor(hex: "#fc8d17")
        static let cornerRadius: CGFloat = 10
        static let verticalPadding: CGFloat = 12
        static let horizontalPadding: CGFloat = 25
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
