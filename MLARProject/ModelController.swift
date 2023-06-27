//
//  ModelController.swift
//  MLARProject
//
//  Created by Vladislav Kazistov & Petro Yaremenko on 21.06.2023.
//
import CoreML
import UIKit
import Vision
import VideoToolbox
import CoreImage
import SwiftUI

class ModelController {
    func detect(image: CIImage) -> String? {
        var res: String?
        
        guard let model = try? VNCoreMLModel(for: detection().model) else {
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
    
    func transformToMosaic(image: CIImage) -> Image? {
        var res: UIImage?
        
        guard let model = try? VNCoreMLModel(for: mosaic().model) else {
            fatalError("FATAL ERROR: Loading CoreML Model Failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNPixelBufferObservation] else {
                fatalError("FATAL ERROR: Model failed to process image.")
            }
            
            if let firstResult = results.first {
                res = UIImage(pixelBuffer: firstResult.pixelBuffer)
            }
        }
        
        let targetRect = CGRect(x: 0, y: 0, width: 640, height: 960)
        if let transformedImage = image.scaleAndAddBorders(within: targetRect) {
            let handler = VNImageRequestHandler(ciImage: transformedImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
        
        if let image = res {
            return Image(uiImage: image)
        }
        
        return nil
    }
    
    
    func transformToCuphead(image: CIImage) -> Image? {
        var res: UIImage?
        
        guard let model = try? VNCoreMLModel(for: cuphead().model) else {
            fatalError("FATAL ERROR: Loading CoreML Model Failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNPixelBufferObservation] else {
                fatalError("FATAL ERROR: Model failed to process image.")
            }
            
            if let firstResult = results.first {
                res = UIImage(pixelBuffer: firstResult.pixelBuffer)
            }
        }
        
        let targetRect = CGRect(x: 0, y: 0, width: 640, height: 960)
        if let transformedImage = image.scaleAndAddBorders(within: targetRect) {
            let handler = VNImageRequestHandler(ciImage: transformedImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
        
        if let image = res {
            return Image(uiImage: image)
        }
        
        return nil
    }
    

    
    func transformToStarryNight(image: CIImage) -> Image? {
        var res: UIImage?
        
        guard let model = try? VNCoreMLModel(for: starry_night().model) else {
            fatalError("FATAL ERROR: Loading CoreML Model Failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNPixelBufferObservation] else {
                fatalError("FATAL ERROR: Model failed to process image.")
            }
            
            if let firstResult = results.first {
                res = UIImage(pixelBuffer: firstResult.pixelBuffer)
            }
        }
        
        let targetRect = CGRect(x: 0, y: 0, width: 640, height: 960)
        if let transformedImage = image.scaleAndAddBorders(within: targetRect) {
            let handler = VNImageRequestHandler(ciImage: transformedImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
        
        if let image = res {
            return Image(uiImage: image)
        }
        
        return nil
    }
    
    func transformToCartoon(image: CIImage) -> Image? {
        var res: UIImage?
        
        guard let model = try? VNCoreMLModel(for: cartoon().model) else {
            fatalError("FATAL ERROR: Loading CoreML Model Failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNPixelBufferObservation] else {
                fatalError("FATAL ERROR: Model failed to process image.")
            }
            
            if let firstResult = results.first {
                res = UIImage(pixelBuffer: firstResult.pixelBuffer)
            }
        }
        
        let targetRect = CGRect(x: 0, y: 0, width: 1536, height: 1536)
        if let transformedImage = image.scaleAndAddBorders(within: targetRect) {
            let handler = VNImageRequestHandler(ciImage: transformedImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
        
        if let image = res {
            return Image(uiImage: image)
        }
        
        return nil
    }
    
    func transformToAnime(image: CIImage) -> Image? {
        var res: UIImage?
        
        guard let model = try? VNCoreMLModel(for: anime().model) else {
            fatalError("FATAL ERROR: Loading CoreML Model Failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNPixelBufferObservation] else {
                fatalError("FATAL ERROR: Model failed to process image.")
            }
            
            if let firstResult = results.first {
                res = UIImage(pixelBuffer: firstResult.pixelBuffer)
            }
        }
        
        let targetRect = CGRect(x: 0, y: 0, width: 256, height: 256)
        if let transformedImage = image.scaleAndAddBorders(within: targetRect) {
            let handler = VNImageRequestHandler(ciImage: transformedImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
        
        if let image = res {
            return Image(uiImage: image)
        }
        
        return nil
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

extension CIImage {
    func scaleAndAddBorders(within rect: CGRect) -> CIImage? {
        let imageSize = self.extent.size
        let scaleX = rect.width / imageSize.width
        let scaleY = rect.height / imageSize.height
        let scale = min(scaleX, scaleY)
        
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        let scaledImage = self.transformed(by: transform)
        
        let outputRect = scaledImage.extent
        let xPadding = (rect.width - outputRect.width) / 2
        let yPadding = (rect.height - outputRect.height) / 2
        let paddingRect = outputRect.insetBy(dx: -xPadding, dy: -yPadding)
        
        let backgroundImage = CIImage(color: CIColor.white).cropped(to: paddingRect)
        let compositeFilter = CIFilter(name: "CISourceOverCompositing")
        compositeFilter?.setValue(scaledImage, forKey: kCIInputImageKey)
        compositeFilter?.setValue(backgroundImage, forKey: kCIInputBackgroundImageKey)
        
        guard let outputImage = compositeFilter?.outputImage else {
            return nil
        }
        return outputImage
    }
}

