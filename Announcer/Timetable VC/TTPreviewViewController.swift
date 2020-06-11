//
//  TTPreviewViewController.swift
//  Announcer
//
//  Created by JiaChen(: on 10/6/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import UIKit
import PDFKit

class TTPreviewViewController: UIViewController {

    var page: PDFPage?
    var `class`: String!
    
    var croppingOffsets = (leading: 0,
                           top: 0,
                           bottom: 0,
                           trailing: 0)
    
    @IBOutlet weak var timetableImageView: UIImageView!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var offsetPointLabel: UILabel!
    @IBOutlet weak var cropSegmentedControl: UISegmentedControl!
    @IBOutlet weak var cropStepper: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = `class`
        
        let pageSize: CGSize = (page?.bounds(for: .mediaBox).size)!
        
        // Ok so
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
        
        let rect = page!.bounds(for: PDFDisplayBox.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageSize)
        
        let image = renderer.image(actions: { context in
            let cgContext = context.cgContext

            cgContext.setFillColor(gray: 1, alpha: 1)
            
            cgContext.fill(rect)

            cgContext.translateBy(x: 0, y: 0)
            
            cgContext.rotate(by: .pi / 2)
            
            cgContext.scaleBy(x: 1, y: -1)
            
            page!.draw(with: PDFDisplayBox.mediaBox, to: cgContext)
        }).rotate(radians: .pi / 2 * 3)

        timetableImageView.image = image
        
        doneButton.layer.cornerRadius = 10
    }

    @IBAction func getInformation(_ sender: Any) {
        let vc = UIViewController()
        let imageView = UIImageView()
    }
    
    @IBAction func changedCroppingTool(_ sender: UISegmentedControl) {
        switch cropSegmentedControl.selectedSegmentIndex {
        case 0:
            offsetPointLabel.text = "\(croppingOffsets.leading) pt"
        case 1:
            offsetPointLabel.text = "\(croppingOffsets.top) pt"
        case 2:
            offsetPointLabel.text = "\(croppingOffsets.bottom) pt"
        case 3:
            offsetPointLabel.text = "\(croppingOffsets.trailing) pt"
        default: break
        }


    }
    
    @IBAction func stepperChanged(_ sender: UIStepper) {
        let pageSize = page!.bounds(for: .mediaBox).size
        
        let widthMaxValue = pageSize.width / 4
        let heightMaxValue = pageSize.height / 4
        
        switch cropSegmentedControl.selectedSegmentIndex {
        case 0:
            croppingOffsets.leading = Int(cropStepper.value)
            
            cropStepper.maximumValue = Double(widthMaxValue)
        case 1:
            croppingOffsets.top = Int(cropStepper.value)
            
            cropStepper.maximumValue = Double(heightMaxValue)
        case 2:
            croppingOffsets.bottom = Int(cropStepper.value)
            
            cropStepper.maximumValue = Double(heightMaxValue)
        case 3:
            croppingOffsets.trailing = Int(cropStepper.value)
            
            cropStepper.maximumValue = Double(widthMaxValue)
        default: break
        }
        
        offsetPointLabel.text = "\(Int(cropStepper.value)) pt"
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

extension UIImage {
    func rotate(radians: CGFloat) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}
