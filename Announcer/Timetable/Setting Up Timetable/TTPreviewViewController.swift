//
//  TTPreviewViewController.swift
//  Announcer
//
//  Created by JiaChen(: on 10/6/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import UIKit
import PDFKit
import Vision
import VisionKit

class TTPreviewViewController: UIViewController {

    var page: PDFPage?
    var `class`: String!
    
    var croppingOffsets = (leading: CGFloat.zero,
                           top: CGFloat.zero,
                           bottom: CGFloat.zero,
                           trailing: CGFloat.zero)
    
    var cropFrame: CGRect!
    
    @IBOutlet weak var timetableImageView: UIImageView!
    @IBOutlet weak var doneButton: UIButton!
    
    var timetableImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set up title to be the class
        // So the navigation controller will be like "S4-07"
        title = `class`
        
        // Curve doneButton
        doneButton.layer.cornerRadius = 10
        
        // Getting the pageSize
        let pageSize: CGSize = (page?.bounds(for: .mediaBox).size)!
        
        // Create timetable image to be used for Vision
        // - Getting the rectangle for the whole class timetable page
        let rect = page!.bounds(for: PDFDisplayBox.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageSize)
        
        // Creating an image of timetable
        timetableImage = renderer.image(actions: { context in
            let cgContext = context.cgContext

            cgContext.setFillColor(gray: 1, alpha: 1)
            
            cgContext.fill(rect)

            cgContext.translateBy(x: 0, y: 0)
            
            cgContext.rotate(by: .pi / 2)
            
            cgContext.scaleBy(x: 1, y: -1)
            
            page!.draw(with: .mediaBox, to: cgContext)
        }).rotate(radians: .pi / 2 * 3)

        // Start cropping timetableImage, will automatically update imageView when done
        DispatchQueue.global(qos: .background).async {
            self.crop()
        }
    }
    
    
    // Dumping the reading code here temporarily
    func getData() {
        
        let pageSize: CGSize = (page?.bounds(for: .mediaBox).size)!
        
        // width is height
        // height is wifht
        let width: CGFloat = pageSize.width / 6
        let heightMultiplier: CGFloat = pageSize.height / 35
        let height: CGFloat = heightMultiplier * 2
        
        let x = pageSize.width - width - width
        let y = pageSize.height - heightMultiplier * 8.5
        
        let selection = (page?.selection(for: CGRect(x: x,
                                                     y: y,
                                                     width: width,
                                                     height: height)))!
        
        let attributedString = selection.attributedString
    }
    
    func crop() {
        let cgImage = timetableImage.cgImage!
        
        performOCR(on: cgImage, recognitionLevel: .accurate)
    }
    
    func performOCR(on cgImage: CGImage, recognitionLevel: VNRequestTextRecognitionLevel)  {
        
        print("starting OCR")
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        let request = VNRecognizeTextRequest  { (request, error) in
            if let error = error {
                let alert = UIAlertController(title: "An Error Occurred", message: error.localizedDescription, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (_) in
                    self.crop()
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                    self.navigationController?.dismiss(animated: true, completion: nil)
                }))
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
                
                return
            }

            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }

            
            let timetableSize = self.timetableImage.size
            
            for currentObservation in observations {
                let topCandidate = currentObservation.topCandidates(1)
                if let recognizedText = topCandidate.first {
                    
                    print("---")
                    print("Text Recognized : ", recognizedText.string)
                    print("Position : ", currentObservation.boundingBox)
                    
                    if recognizedText.string.lowercased().contains("school of science and technology") {
                        
                        self.croppingOffsets.leading = timetableSize.width * currentObservation.boundingBox.minX
                        self.croppingOffsets.top = timetableSize.height - timetableSize.height * currentObservation.bottomLeft.y
                        
                        print("we got the other guy")
                    } else if recognizedText.string.lowercased().contains("asc timetables") {
                        self.croppingOffsets.trailing = timetableSize.width - timetableSize.width * currentObservation.boundingBox.maxX
                        self.croppingOffsets.bottom = timetableSize.height * currentObservation.boundingBox.maxY + 4
                    }
                }
            }
            
            let ratio: CGFloat = 3
            
            let cropFrame = CGRect(x: ratio * self.croppingOffsets.leading,
                                   y: ratio * self.croppingOffsets.top,
                                   width: ratio * (timetableSize.width - self.croppingOffsets.leading - self.croppingOffsets.trailing),
                                   height: ratio * (timetableSize.height - self.croppingOffsets.top - self.croppingOffsets.bottom))
            
            self.cropFrame = cropFrame
            
            // Updating the imageView with the new image
            let image = self.timetableImage.cropImage(with: cropFrame)
            
            self.timetableImage = image
            
            DispatchQueue.main.async {
                self.timetableImageView.image = image
            }
        }
        
        request.recognitionLevel = recognitionLevel

        try? requestHandler.perform([request])
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
