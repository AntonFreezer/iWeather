//
//  UIImageView+Extension.swift
//  iWeather
//
//  Created by Anton Kholodkov on 26.02.2024.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(with url: URL?,
                  placeholder: UIImage? = UIImage(named: "placeholder"),
                  cornerRadius: CGFloat = 16,
                  resize: Bool = true,
                  crop: Bool = true,
                  resizeMode: Kingfisher.ContentMode = .aspectFill,
                  cropSize: CGSize? = nil,
                  processorOptions: [ImageProcessor] = []) {
        
        guard let url = url else {
            DispatchQueue.main.async {
                self.image = placeholder
            }
            return
        }
        
        DispatchQueue.main.async {
            var processors: [ImageProcessor] = []
            
            if resize || crop {
                var size = self.bounds.size
                if let cropSize = cropSize, crop {
                    size = cropSize
                }
                if resize {
                    let resizeProcessor = ResizingImageProcessor(referenceSize: size, mode: resizeMode)
                    processors.append(resizeProcessor)
                }
                if crop {
                    let cropProcessor = CroppingImageProcessor(size: size)
                    processors.append(cropProcessor)
                }
            }
            
            let roundCornerProcessor = RoundCornerImageProcessor(cornerRadius: cornerRadius)
            processors.append(roundCornerProcessor)
            
            processors.append(contentsOf: processorOptions)
            
            // Combine all processors with the |> operator provided by Kingfisher
            let finalProcessor = processors.reduce(nil) { combinedProcessor, nextProcessor in
                combinedProcessor == nil ? nextProcessor : combinedProcessor! |> nextProcessor
            }
            
            self.kf.indicatorType = .activity
            self.kf.setImage(
                with: url,
                placeholder: placeholder,
                options: [
                    .processor(finalProcessor ?? DefaultImageProcessor.default),
                    .cacheSerializer(FormatIndicatedCacheSerializer.png),
                    .scaleFactor(self.window?.windowScene?.screen.scale ?? UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheMemoryOnly
                ]
            )
        }
    }
}

