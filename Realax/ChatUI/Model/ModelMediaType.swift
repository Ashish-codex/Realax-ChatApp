//
//  ModelMediaType.swift
//  Realax
//
//  Created by Ashish Prajapati on 24/02/24.
//

import Foundation
import MessageKit
import UIKit


struct ImageMediaItem: MediaItem {
  var url: URL?
  var image: UIImage?
  var placeholderImage: UIImage
  var size: CGSize

  init(image: UIImage?) {
    self.image = image
    size = CGSize(width: 240, height: 240)
    placeholderImage = UIImage()
  }

  init(imageURL: URL) {
    url = imageURL
    size = CGSize(width: 240, height: 240)
    placeholderImage = UIImage(named: "img_photo_placeholder")!
      
  }
}
