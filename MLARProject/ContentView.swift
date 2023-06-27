//
//  ContentView.swift
//  MLARProject
//
//  Created by Vladislav Kazistov on 27.06.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedImage: Image? = nil
    @State private var isShowingMenu: Bool = false

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    HStack {
                        Text("Object:")
                        TextField("Enter object", text: .constant(""))
                        Button(action: {
                            openImagePicker()
                        }) {
                            Image(systemName: "camera")
                        }
                        .padding(.leading, 8)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)


                    // Виведення обраного зображення
                    if let image = selectedImage {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding()
                    }

                    VStack {
                        ImagePlaceholderView(image: selectedImage)
                        ImagePlaceholderView(image: nil)
                    }
                    .padding()

                    Spacer()
                }
            }
            .padding(.top, 40) // Доданий відступ зверху

            VStack {
                Spacer()

                if isShowingMenu {
                    MenuView()
                        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 4) // Вилітає на чверть висоти екрана
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding()
                        .transition(.move(edge: .bottom))
                }

                Button(action: {
                    isShowingMenu.toggle()
                }) {
                    Image(systemName: isShowingMenu ? "arrow.down.circle" : "arrow.up.circle")
                        .font(.system(size: 40))
                }
                .padding()
                .zIndex(1)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }

    func openImagePicker() {
        // Код для відкриття галереї фотографій та вибору зображення
        // Після вибору зображення, присвоєння його змінній selectedImage
        // Як приклад, тут використано додання фото з файлової системи:
        if let image = UIImage(named: "your_image_name") {
            selectedImage = Image(uiImage: image)
        }
    }
}

struct ImagePlaceholderView: View {
    var image: Image?

    var body: some View {
            ZStack {
                if let image = image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Rectangle()
                        .foregroundColor(.gray)
                }
            }
            .frame(height: 300)
    }
}

struct MenuView: View {
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    // Дії для першої кнопки
                }) {
                    Text("Button 1")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button(action: {
                    // Дії для другої кнопки
                }) {
                    Text("Button 2")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }

            HStack {
                Button(action: {
                    // Дії для третьої кнопки
                }) {
                    Text("Button 3")
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button(action: {
                    // Дії для четвертої кнопки
                }) {
                    Text("Button 4")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

