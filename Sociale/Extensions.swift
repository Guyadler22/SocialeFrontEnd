//
//  Extensions.swift
//  Sociale
//
//  Created by Guy Adler on 26/10/2023.
//

import Foundation
import UIKit
import CoreMedia
import AVKit
import Alamofire

extension UIViewController {
    
    
    func openImageGallery(delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        let controller = UIImagePickerController()
        controller.delegate = delegate
        self.present(controller, animated: true)
    }

        
    func showAlert(content:String, dismissAfter: TimeInterval = 2.5) {
        if AlertView.showing {
            return
        }
        let alert = AlertView(content: content)
        alert.show(self, dismissAfter: dismissAfter)
    }
    
    
    func handleApiError(_ error: Error) {
        if let error = error as? ApiError {
            switch error {
            case .SocialeError(let message):
                showAlert(content: message, dismissAfter: 15)
                return
                
            default:
                break
            }
        }
        print(error)
        showAlert(content: error.localizedDescription, dismissAfter: 15)
    }
    
    func videoSnapshot(vidURL: URL) -> UIImage? {

        let asset = AVURLAsset(url: vidURL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true

        let timestamp = CMTime(seconds: 1, preferredTimescale: 60)

        do {
            let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
            return UIImage(cgImage: imageRef)
        }
        catch let error as NSError
        {
            print("Image generation failed with error \(error)")
            return nil
        }
    }
    
}

extension String {
    
    func downloadImage(to imageView: UIImageView) {
        let request = Alamofire.AF.request(URLRequest(url:URL(string: self)!))
        request.response(completionHandler: { [weak imageView] response in
            if let data = response.data {
                imageView?.image = UIImage(data: data, scale:1)
            }
        })
        request.resume()
    }
}



extension Double {
    func toIntDate() -> IntDate {
        return IntDate(value: self)
    }
}
