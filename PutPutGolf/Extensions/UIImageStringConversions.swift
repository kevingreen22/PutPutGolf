//
//  UIImageToStringAndReverseExtensions.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/30/23.
//

import UIKit

public extension UIImage {
    
    typealias ImageFormat = ImageFormatType
    
    enum ImageFormatType {
        case png
        case jpeg(CGFloat)
    }
    
    /// Converts a UIImage to a data encoded string. Ideal for saving image data to JSON.
    /// - Parameter format: The format type to use when encoding the image. Defaults to .png
    /// - Returns: A string consisting of the data represented as a string.
    func toDataString(format: ImageFormat = .png) -> String {
        switch format {
        case .png:
            guard let imageData = self.pngData() else { return "" }
            return imageData.base64EncodedString()
        case .jpeg(let compression):
            guard let imageData = self.jpegData(compressionQuality: compression) else { return "" }
            return imageData.base64EncodedString()
        }
    }
    
}

extension String {
    
    /// Converts a data string to a UIImage.
    /// - Parameters:
    ///   - encoding: The type of encoding to use when converting the string to data. Defaults to .utf8
    ///   - allowsLossyConversion: Whether or not to allow lossless conversion. Defaults to false.
    /// - Returns: A UIImage object or nil if the string can not be converted.
    public func toUIImage(_ encoding: String.Encoding = .utf8, _ allowsLossyConversion: Bool = false) -> UIImage? {
        guard let imageData = self.data(using: encoding, allowLossyConversion: allowsLossyConversion) else { return nil }
        return UIImage(data: imageData)
    }
    
}
