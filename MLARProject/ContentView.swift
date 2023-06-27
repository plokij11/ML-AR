//
//  ContentView.swift
//  MLARProject
//
//  Created by Vladislav Kazistov on 27.06.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedImage: Image? = nil
    @State private var resultedImage: Image? = nil
    
    @State private var isShowingMenu: Bool = false
    @State private var isShowingImagePicker: Bool = false
    @State private var isShowingError: Bool = false
    @State private var label123: String = ""
    
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
                            TextField("not detected yet", text: $label123)
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
                    
                    
                    if let image = resultedImage {
                        VStack {
                            HStack {
                                Text("RESULT:")
                                    .bold()
                                    .font(.system(size: 23))
                                
                                .padding(.leading, 8)
                            }
                            .padding()
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
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
                    MenuView(selectedImage: $selectedImage, resultedImage: $resultedImage, label123: $label123, modelController: modelController)
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
    @Binding var selectedImage: Image?
    @Binding var resultedImage: Image?
    @Binding var label123: String // Add binding parameter for label123
    
    let modelController: ModelController
    var body: some View {
        VStack {
            HStack {
                Button(action: {

                    let uiImage = selectedImage.asUIImage()
                        if let ciImage = CIImage(image: uiImage) {
                            label123 = modelController.detect(image: ciImage)
                        }
                
                }) {
                    Text("Detection")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    let uiImage = selectedImage.asUIImage()
                        if let ciImage = CIImage(image: uiImage) {
                            resultedImage = modelController.transformToMosaic(image: ciImage)
                        }
                }) {
                    Text("Mosaic")
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


extension View {
// This function changes our View to UIView, then calls another function
// to convert the newly-made UIView to a UIImage.
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
 // Set the background to be transparent incase the image is a PNG, WebP or (Static) GIF
        controller.view.backgroundColor = .clear
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
// here is the call to the function that converts UIView to UIImage: `.asUIImage()`
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
// This is the function to convert UIView to UIImage
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
