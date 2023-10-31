
import Foundation
import Vision
import VisionKit

// A class responsible for recognizing text from scanned images
final class TextRecognizer {
    let cameraScan: VNDocumentCameraScan
    
    init(cameraScan: VNDocumentCameraScan) {
        self.cameraScan = cameraScan
    }
    
    // Queue for processing text recognition requests
    private let queue = DispatchQueue(label: "scan-codes", qos: .default, attributes: [], autoreleaseFrequency: .workItem)
    
    // Function to recognize text from scanned images
    func recognizeText(withCompletionHandler completionHandler: @escaping ([String]) -> Void) {
        queue.async {
            // Extract images from each scanned page
            let images = (0..<self.cameraScan.pageCount).compactMap {
                self.cameraScan.imageOfPage(at: $0).cgImage
            }
            
            // Create an array of images and text recognition requests
            let imagesAndRequests = images.map { (image: $0, request: VNRecognizeTextRequest()) }
            
            // Process each image and extract text
            let textPerPage = imagesAndRequests.map { image, request -> String in
                let handler = VNImageRequestHandler(cgImage: image, options: [:])
                do {
                    try handler.perform([request])
                    guard let observations = request.results else { return "" }
                    return observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
                } catch {
                    print(error)
                    return ""
                }
            }
            
            // Notify the main thread with the recognized text
            DispatchQueue.main.async {
                completionHandler(textPerPage)
            }
        }
    }
}
