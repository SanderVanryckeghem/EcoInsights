//  Detector.swift
//  EcoInsights
//
//  Created by Sander Vanryckeghem on 13/04/2023.
//

import Vision
import AVFoundation
import UIKit
import SwiftUI

extension ViewController {
    // Sets up the object detector with the specified CoreML model
    func setupDetector() {
        let modelURL = Bundle.main.url(forResource: "TunaDetector3", withExtension: "mlmodelc")
    
        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL!))
            let recognitions = VNCoreMLRequest(model: visionModel, completionHandler: detectionDidComplete)
            self.requests = [recognitions]
        } catch let error {
            print(error)
        }
    }
    
    // Called when the detection is complete
    func detectionDidComplete(request: VNRequest, error: Error?) {
        DispatchQueue.main.async(execute: {
            if let results = request.results {
                self.extractDetections(results)
            }
        })
    }
    
    // Extracts detected objects and draws bounding boxes and labels
    func extractDetections(_ results: [VNObservation]) {
        detectionLayer.sublayers = nil

        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else { continue }

            if let topLabelObservation = objectObservation.labels.first {
                let confidence = topLabelObservation.confidence

                // Only show detection if confidence score is higher than 80%
                if confidence >= 0.80 {
                    let productName = topLabelObservation.identifier
                    let productDetected = ProductController.shared.products.first(where: {$0.arLabel == productName})
                    if (productDetected == nil) {
                        return
                    }
                    let score = Double(productDetected!.totalScore)


                    // Transformations
                    let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(screenRect.size.width), Int(screenRect.size.height))
                    let transformedBounds = CGRect(x: objectBounds.minX, y: screenRect.size.height - objectBounds.maxY, width: objectBounds.maxX - objectBounds.minX, height: objectBounds.maxY - objectBounds.minY)

                    var shouldDraw = true

                    // Check if the current bounding box overlaps with any existing bounding boxes
                    for layer in detectionLayer.sublayers ?? [] {
                        let boxLayer = layer as CALayer
                        if boxLayer.name != nil {
                            let iou = intersectionOverUnion(boxLayer.frame, transformedBounds)

                            // If overlap is greater than 25%, skip drawing the current bounding box
                            if iou >= 0.5 {
                                shouldDraw = false
                                break
                            }
                        }
                    }

                    if shouldDraw {
                        let boxLayer = self.drawBoundingBox(transformedBounds, score: score, objectName: productName)
                        detectionLayer.addSublayer(boxLayer)

                        // Add product name and confidence
                        let scoreLayer = self.drawTextLayer(score, at: CGPoint(x: transformedBounds.origin.x - 18, y: transformedBounds.origin.y - 20))//Location of score
                        detectionLayer.addSublayer(scoreLayer)
                    }
                }
            }
        }
    }

    // Draw a text layer with object name and confidence percentage at a specified point
    func drawTextLayer(_ score: Double, at point: CGPoint) -> CALayer {
        let circleLayer = CALayer()
        let circleRadius: CGFloat = 20.0

        // Set the frame for the circle layer
        circleLayer.frame = CGRect(x: point.x, y: point.y, width: circleRadius * 2, height: circleRadius * 2)

        // Draw a circle
        circleLayer.cornerRadius = circleRadius
        let color: CGColor
        switch score {
        case 1..<2:
            color = UIColor.red.cgColor
        case 2..<3:
            color = UIColor(red: 237 / 255, green: 115 / 255, blue: 62 / 255, alpha: 1).cgColor
        case 3..<4:
            color = UIColor.orange.cgColor
        case 4..<5:
            color = UIColor.yellow.cgColor
        case 5...:
            color = UIColor.green.cgColor
        default:
            color = UIColor.gray.cgColor
        }
        circleLayer.backgroundColor = color

        // Create text layer with score
        let textLayer = CATextLayer()
        textLayer.string = String(format: "%.1f", score)
        textLayer.fontSize = 14
        textLayer.foregroundColor = UIColor.black.cgColor
        textLayer.alignmentMode = .center
        textLayer.contentsScale = UIScreen.main.scale

        // Set the frame for the text layer
        textLayer.frame = CGRect(x: 0, y: circleRadius - textLayer.fontSize / 2, width: circleRadius * 2, height: textLayer.fontSize)
        circleLayer.addSublayer(textLayer)

        return circleLayer
    }
    
    // Sets up the detection and tap gesture layers
    func setupLayers() {
        // Create and configure a new CALayer for displaying detected objects
        detectionLayer = CALayer()
        detectionLayer.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)
        detectionLayer.zPosition = 1 // Set zPosition to ensure the detection layer is above other layers
        self.view.layer.addSublayer(detectionLayer) // Add the detection layer as a sublayer of the view's layer

        // Create and configure a UITapGestureRecognizer to detect tap events
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture) // Add the tap gesture recognizer to the view
    }
    
    // Updates the detection layer's frame
    func updateLayers() {
        detectionLayer?.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)
    }
    
    // Draws a bounding box around a detected object
    func drawBoundingBox(_ bounds: CGRect, score: Double, objectName: String) -> CAShapeLayer {
        let boxLayer = CAShapeLayer()
        let path = UIBezierPath(rect: bounds)
        boxLayer.path = path.cgPath
        boxLayer.lineWidth = 3.0
        let color: CGColor
        switch score {
        case 1..<2:
            color = UIColor.red.cgColor
        case 2..<3:
            color = UIColor(red: 237 / 255, green: 115 / 255, blue: 62 / 255, alpha: 1).cgColor
        case 3..<4:
            color = UIColor.orange.cgColor
        case 4..<5:
            color = UIColor.yellow.cgColor
        case 5...:
            color = UIColor.green.cgColor
        default:
            color = UIColor.gray.cgColor
        }
        boxLayer.strokeColor = color
        boxLayer.fillColor = UIColor.clear.cgColor
        boxLayer.lineDashPattern = [6, 6]
        boxLayer.name = objectName
        return boxLayer
    }
    
    // Handles the AVCaptureOutput, forwarding it to the vision request handler
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:]) // Create handler to perform request on the buffer

        do {
            try imageRequestHandler.perform(self.requests) // Schedules vision requests to be performed
        } catch {
            print(error)
        }
    }
    
    // Calculates the Intersection over Union (IoU) of two CGRects
    func intersectionOverUnion(_ rect1: CGRect, _ rect2: CGRect) -> CGFloat {
        let intersection = rect1.intersection(rect2)
        let intersectionArea = intersection.width * intersection.height
        let unionArea = rect1.width * rect1.height + rect2.width * rect2.height - intersectionArea
        return CGFloat(intersectionArea / unionArea)
    }
    
    // Handles tap events on the detected objects
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        
        let tapLocation = gestureRecognizer.location(in: self.view)

        guard let sublayers = detectionLayer.sublayers else { return }
        
        for layer in sublayers {
            if let textLayer = layer as? CATextLayer, layer.frame.contains(tapLocation) {
                print("Tapped on: \(textLayer.string ?? "")")
                sharedData.openPopUpScan = true
                let productDetected = ProductController.shared.products.first(where: {$0.arLabel == layer.name})
                sharedData.pressedItem = productDetected
                break
            } else if let shapeLayer = layer as? CAShapeLayer, layer.name != nil, let path = shapeLayer.path, path.boundingBox.contains(tapLocation) {
                print("Tapped on: \(layer.name ?? "")")
                sharedData.openPopUpScan = true
                let productDetected = ProductController.shared.products.first(where: {$0.arLabel == layer.name})
                sharedData.pressedItem = productDetected
                break
            }
        }
    }
}
   
