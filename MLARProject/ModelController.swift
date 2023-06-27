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
    
    func transformToCuphead(image: CIImage) -> Image{
        var res = UIImage()
        guard let model = try? VNCoreMLModel(for: fast_neural_style_transfer_cuphead().model) else {
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
    
    func transformToStarryNight(image: CIImage) -> Image{
        var res = UIImage()
        guard let model = try? VNCoreMLModel(for: fast_neural_style_transfer_starry_night().model) else {
            fatalError("FATALERROR: Loading CoreMl Model Failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNPixelBufferObservation] else {
                fatalError("FATALERROR: Model failed to precess image.")
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

