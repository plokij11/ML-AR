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
    @State private var isShowingImagePicker: Bool = false
    @State private var isShowingError: Bool = false
    
    let modelController = ModelController()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    VStack {
                        HStack {
                            Text("Object:")
                                .bold()
                                .font(.system(size: 23))
                            TextField("Info", text: .constant(""))
                                .font(.system(size: 23))
                            Button(action: {
                                isShowingImagePicker = true
                            }) {
                                Image(systemName: "camera")
                                    .font(.system(size: 23))
                            }
                            .padding(.leading, 8)
                            .sheet(isPresented: $isShowingImagePicker, onDismiss: loadImage) {
                                ImagePicker(image: $selectedImage)
                            }
                        }
                        .padding()
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    
                    // Виведення обраного зображення
                    if let image = selectedImage {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding()
                    }
                    
                    Spacer()
                }
            }
            .padding(.top, 80) // Збільшений відступ зверху
            
            VStack {
                Spacer()
                
                if isShowingMenu {
                    MenuView(modelController: modelController)
                        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 4) // Вилітає на чверть висоти екрана
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding()
                        .transition(.move(edge: .bottom))
                }
                
                Button(action: {
                    if selectedImage == nil {
                        isShowingError = true
                    } else {
                        isShowingMenu.toggle()
                    }
                }) {
                    Image(systemName: isShowingMenu ? "arrow.down.circle" : "arrow.up.circle")
                        .font(.system(size: 40))
                }
                .padding()
                .zIndex(1)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .alert(isPresented: $isShowingError) {
            Alert(title: Text("Error"), message: Text("You need to choose a photo from the gallery!"), dismissButton: .default(Text("OK")))
        }
    }
    
    func loadImage() {
        // Викликається після вибору фотографії в ImagePicker
        guard let selectedImage = selectedImage else { return }
        // Можна виконати додаткову обробку або зберегти вибрану фотографію
        print("Selected image: \(selectedImage)")
    }
}

struct MenuView: View {
    let modelController: ModelController
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    // Дії для першої кнопки
                    if let uiImage = UIImage(named: "your_image_file_name") {
                        if let ciImage = CIImage(image: uiImage) {
                            modelController.detect(image: ciImage)
                        }
                    }
                }) {
                    Text("Detection")
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

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: Image?
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var presentationMode: PresentationMode
        @Binding var image: Image?
        
        init(presentationMode: Binding<PresentationMode>, image: Binding<Image?>) {
            _presentationMode = presentationMode
            _image = image
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                image = Image(uiImage: uiImage)
            }
            presentationMode.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode, image: $image)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        // Оновлення контролера відображення, якщо необхідно
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

