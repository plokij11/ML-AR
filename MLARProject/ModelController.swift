//
//  ModelController.swift
//  MLARProject
//
//  Created by MAC on 27.06.2023.
//

import Foundation
import CoreML

import UIKit
import Vision


class ModelController {
    
    func detect(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("FATALERROR: Loading CoreMl Model Failed")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNRecognizedObjectObservation] else {
                fatalError("FATALERROR: Model failed to precess image.")
            }

            if let firstResult = results.first {
                //тут інфо в лейбл виводиться
                print(firstResult.labels)
            }
        }

        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }

    func transformToMosaic(image: CIImage){
        guard let model = try? VNCoreMLModel(for: fast_neural_style_transfer_mosaic().model) else {
            fatalError("FATALERROR: Loading CoreMl Model Failed")
        }

        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNPixelBufferObservation] else {
                fatalError("FATALERROR: Model failed to precess image.")
            }

            if let firstResult = results.first {
                let ciimage : CIImage = CIImage(cvPixelBuffer: firstResult.pixelBuffer)
                let context:CIContext = CIContext(options: nil)

                let cgImage:CGImage = context.createCGImage(ciimage, from: ciimage.extent)!
                let myImage:UIImage = UIImage(cgImage: cgImage)
    //                print(firstResult.pixelBuffer)
                self.imageView.image = myImage
            }
        }
        let handler = VNImageRequestHandler(ciImage: image)

        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }

    func transformToCuphead(image: CIImage){
        guard let model = try? VNCoreMLModel(for: fast_neural_style_transfer_cuphead().model) else {
            fatalError("FATALERROR: Loading CoreMl Model Failed")
        }

        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNPixelBufferObservation] else {
                fatalError("FATALERROR: Model failed to precess image.")
            }


            if let firstResult = results.first {
                let ciimage : CIImage = CIImage(cvPixelBuffer: firstResult.pixelBuffer)
                let context:CIContext = CIContext(options: nil)

                let cgImage:CGImage = context.createCGImage(ciimage, from: ciimage.extent)!
                let myImage:UIImage = UIImage(cgImage: cgImage)
    //                print(firstResult.pixelBuffer)
                self.imageView.image = myImage
            }
        }
        let handler = VNImageRequestHandler(ciImage: image)

        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }

}
