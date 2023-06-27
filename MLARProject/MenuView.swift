//
//  MenuView.swift
//  MLARProject
//
//  Created by Vladislav Kazistov & Petro Yaremenko on 21.06.2023.
//

import SwiftUI


struct MenuView: View {
    @Binding var selectedImage: Image?
    @Binding var resultedImage: Image?
    @Binding var label123: String
    
    let modelController: ModelController
    var body: some View {
        VStack {
            
            HStack {
                Button(action: {
                    let uiImage = selectedImage.asUIImage()
                    if let ciImage = CIImage(image: uiImage) {
                        if let detectionResult = modelController.detect(image: ciImage) {
                            label123 = detectionResult
                        } else {
                            print("Error: Failed to detect image")
                        }
                    } else {
                        print("Error: Failed to create CIImage from UIImage")
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
                        if let transformedImage = modelController.transformToMosaic(image: ciImage) {
                            resultedImage = transformedImage
                        } else {
                            print("Error: Failed to transform image")
                        }
                    } else {
                        print("Error: Failed to create CIImage from UIImage")
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
                    let uiImage = selectedImage.asUIImage()
                    if let ciImage = CIImage(image: uiImage) {
                        if let transformedImage = modelController.transformToCuphead(image: ciImage) {
                            resultedImage = transformedImage
                        } else {
                            print("Error: Failed to transform image")
                        }
                    } else {
                        print("Error: Failed to create CIImage from UIImage")
                    }
                }) {
                    Text("Cuphead")
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    let uiImage = selectedImage.asUIImage()
                    if let ciImage = CIImage(image: uiImage) {
                        if let transformedImage = modelController.transformToStarryNight(image: ciImage) {
                            resultedImage = transformedImage
                        } else {
                            print("Error: Failed to transform image")
                        }
                    } else {
                        print("Error: Failed to create CIImage from UIImage")
                    }
                }) {
                    Text("StarryNight")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            
            HStack {
                Button(action: {
                    let uiImage = selectedImage.asUIImage()
                    if let ciImage = CIImage(image: uiImage) {
                        if let transformedImage = modelController.transformToCartoon(image: ciImage) {
                            resultedImage = transformedImage
                        } else {
                            print("Error: Failed to transform image")
                        }
                    } else {
                        print("Error: Failed to create CIImage from UIImage")
                    }
                }) {
                    Text("Cartoon")
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    let uiImage = selectedImage.asUIImage()
                    if let ciImage = CIImage(image: uiImage) {
                        if let transformedImage = modelController.transformToAnime(image: ciImage) {
                            resultedImage = transformedImage
                        } else {
                            print("Error: Failed to transform image")
                        }
                    } else {
                        print("Error: Failed to create CIImage from UIImage")
                    }
                }) {
                    Text("Anime")
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                
            }
        }
        .padding()
    }
}
