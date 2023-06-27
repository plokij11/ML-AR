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
import VideoToolbox




class ModelController {
    func detect(image: CIImage) -> String{
        var res = "empty"
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("FATAL ERROR: Loading CoreML Model Failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("FATAL ERROR: Model failed to process image.")
            }
            
            if let firstResult = results.first {
                res = firstResult.identifier
            }
        }

        
        let handler = VNImageRequestHandler(ciImage: image, options: [:])
        do {
            try handler.perform([request])
            
        } catch {
            print(error)
        }
        return res
    }
    
    func transformToMosaic(image: CIImage) -> Image{
        var res = UIImage()
        guard let model = try? VNCoreMLModel(for: fast_neural_style_transfer_mosaic().model) else {
            fatalError("FATAL ERROR: Loading CoreML Model Failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNPixelBufferObservation] else {
                fatalError("FATAL ERROR: Model failed to process image.")
            }
            
            if let firstResult = results.first {
                res = UIImage(pixelBuffer: firstResult.pixelBuffer)!
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
        return Image(uiImage: res)
        
        
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


extension UIImage {
    public convenience init?(pixelBuffer: CVPixelBuffer) {
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(pixelBuffer, options: nil, imageOut: &cgImage)
        guard let cgImage = cgImage else {
            return nil
        }

        self.init(cgImage: cgImage)
    }
}

