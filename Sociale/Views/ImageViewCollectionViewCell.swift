//
//  ImageViewCollectionViewCell.swift
//  Sociale
//
//  Created by Guy Adler on 24/10/2023.
//

import UIKit

import Alamofire

class ImageViewCollectionViewCell: UICollectionViewCell {

    static let id = "ImageViewCollectionViewCell"

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func populate(_ upload: Upload) {
        if let url = upload.is_video ? upload.previewUrl : upload.uploadUrl {
            url.downloadImage(to: self.imageView)
        }
       
    }

}
