//
//  ModelController.swift
//  MLARProject
//
//  Created by Vladislav Kazistov on 27.06.2023.
//

import Foundation
import CoreML
import UIKit
import Vision
import SwiftUI

class ModelController {
    func detect(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("FATAL ERROR: Loading CoreML Model Failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNRecognizedObjectObservation] else {
                fatalError("FATAL ERROR: Model failed to process image.")
            }
            
            if let firstResult = results.first {
                DispatchQueue.main.async {
                    if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
                       let textField = window.rootViewController?.view.viewWithTag(1) as? UITextField {
                        textField.text = firstResult.labels.first?.identifier
                    }
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
    
    func transformToMosaic(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: fast_neural_style_transfer_mosaic().model) else {
            fatalError("FATAL ERROR: Loading CoreML Model Failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNPixelBufferObservation] else {
                fatalError("FATAL ERROR: Model failed to process image.")
            }
            
            if let firstResult = results.first {
                let ciimage: CIImage = CIImage(cvPixelBuffer: firstResult.pixelBuffer)
                let context: CIContext = CIContext(options: nil)
                
                if let cgImage: CGImage = context.createCGImage(ciimage, from: ciimage.extent) {
                    let myImage: UIImage = UIImage(cgImage: cgImage)
                    DispatchQueue.main.async {
                        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
                           let imageView = window.rootViewController?.view.viewWithTag(2) as? UIImageView {
                            imageView.image = myImage
                        }
                    }
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
    
    func transformToCuphead(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: fast_neural_style_transfer_cuphead().model) else {
            fatalError("FATAL ERROR: Loading CoreML Model Failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNPixelBufferObservation] else {
                fatalError("FATAL ERROR: Model failed to process image.")
            }
            
            if let firstResult = results.first {
                let ciimage: CIImage = CIImage(cvPixelBuffer: firstResult.pixelBuffer)
                let context: CIContext = CIContext(options: nil)
                
                if let cgImage: CGImage = context.createCGImage(ciimage, from: ciimage.extent) {
                    let myImage: UIImage = UIImage(cgImage: cgImage)
                    DispatchQueue.main.async {
                        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
                           let imageView = window.rootViewController?.view.viewWithTag(2) as? UIImageView {
                            imageView.image = myImage
                        }
                    }
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
}

