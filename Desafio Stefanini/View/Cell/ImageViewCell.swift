//
//  ImageViewCell.swift
//  Desafio Stefanini
//
//  Created by Wladmir Edmar Silva Junior on 16/04/21.
//

import UIKit

class ImageViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loandingIndicator: UIActivityIndicatorView!

    func display(image: UIImage?) {
        imageView.image = image
    }
}
