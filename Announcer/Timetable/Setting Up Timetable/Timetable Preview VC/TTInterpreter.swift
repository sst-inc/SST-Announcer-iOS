//
//  TTInterpreter.swift
//  Announcer
//
//  Created by JiaChen(: on 22/6/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import Vision
import UIKit

class TTInterpreter {
    
    var observations: [VNRecognizedTextObservation]
    var `class`: String
    var image: UIImage
    
    init(_ observations: [VNRecognizedTextObservation], class: String) {
        self.observations = observations
        self.class = `class`
        self.image = UIImage()
    }
//    
//    func getTimetable(_ observations: [VNRecognizedTextObservation]) -> Timetable {
//        
//        return Timetable(class: self.class,
//                         timetableImage: Timetable.convert(with: image),
//                         monday: <#T##[Lesson]#>,
//                         tuesday: <#T##[Lesson]#>,
//                         wednesday: <#T##[Lesson]#>,
//                         thursday: <#T##[Lesson]#>,
//                         friday: <#T##[Lesson]#>)
//    }
    
    func performOCR(on image: UIImage, exitCompletion: ((Error?, UIImage?) -> Void)) {
        
        var croppingOffsets = (leading: CGFloat.zero, trailing: CGFloat.zero, top: CGFloat.zero, bottom: CGFloat.zero)
        
        let recognitionLevel = VNRequestTextRecognitionLevel.accurate

        let cgImage = image.cgImage!

        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        let request = VNRecognizeTextRequest { (request, error) in
            if let error = error {
//                exitCompletion(error, nil)
                
                return
            }

            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }

            
            let timetableSize = image.size
            
            for currentObservation in observations {
                let topCandidate = currentObservation.topCandidates(1)
                if let recognizedText = topCandidate.first {
                    
                    print("---")
                    print("Text Recognized : ", recognizedText.string)
                    print("Position : ", currentObservation.boundingBox)
                    
                    if recognizedText.string.lowercased().contains("school of science and technology") {
                        
                        croppingOffsets.leading = timetableSize.width * currentObservation.boundingBox.minX
                        croppingOffsets.top = timetableSize.height - timetableSize.height * currentObservation.bottomLeft.y
                        
                        print("we got the other guy")
                    } else if recognizedText.string.lowercased().contains("asc timetables") {
                        croppingOffsets.trailing = timetableSize.width - timetableSize.width * currentObservation.boundingBox.maxX
                        croppingOffsets.bottom = timetableSize.height * currentObservation.boundingBox.maxY + 4
                    }
                }
            }
            
            let ratio: CGFloat = 3
            
            let cropFrame = CGRect(x: ratio * croppingOffsets.leading,
                                   y: ratio * croppingOffsets.top,
                                   width: ratio * (timetableSize.width - croppingOffsets.leading - croppingOffsets.trailing),
                                   height: ratio * (timetableSize.height - croppingOffsets.top - croppingOffsets.bottom))
            
            // Updating the imageView with the new image
            let image = image.cropImage(with: cropFrame)
            
//            exitCompletion(nil, image)
        }
        
        request.recognitionLevel = recognitionLevel

        try? requestHandler.perform([request])
    }
}
