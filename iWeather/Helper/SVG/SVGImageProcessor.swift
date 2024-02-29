//
//  SVGImageProcessor.swift
//  iWeather
//
//  Created by Anton Kholodkov on 28.02.2024.
//

import UIKit
import Kingfisher
import SVGKit

public struct SVGImgProcessor: ImageProcessor {
    public var identifier: String = "com.iWeather.svgprocessor"
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            return image
        case .data(let data):
            let imageSvg = SVGKImage(data: data)
            return imageSvg?.uiImage
        }
    }
}
