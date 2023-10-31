
import VisionKit
import SwiftUI

// A SwiftUI representation of a document scanner view
struct ScannerView: UIViewControllerRepresentable {
    private let completionHandler: ([String]?) -> Void
    
    init(completion: @escaping ([String]?) -> Void) {
        self.completionHandler = completion
    }
    
    // Define the UIViewController type as VNDocumentCameraViewController
    typealias UIViewControllerType = VNDocumentCameraViewController
    
    // Create the VNDocumentCameraViewController and set its delegate
    func makeUIViewController(context: UIViewControllerRepresentableContext<ScannerView>) -> VNDocumentCameraViewController {
        let viewController = VNDocumentCameraViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
    
    // Update the view controller if needed (empty in this case)
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: UIViewControllerRepresentableContext<ScannerView>) {}
    
    // Create a coordinator for handling delegate callbacks
    func makeCoordinator() -> Coordinator {
        return Coordinator(completion: completionHandler)
    }
    
    // Coordinator class to handle VNDocumentCameraViewControllerDelegate callbacks
    final class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        private let completionHandler: ([String]?) -> Void
        
        init(completion: @escaping ([String]?) -> Void) {
            self.completionHandler = completion
        }
        
        // Called when document scanning is finished
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            // Handle the scan results using a TextRecognizer
            let recognizer = TextRecognizer(cameraScan: scan)
            recognizer.recognizeText(withCompletionHandler: completionHandler)
            
            // Dismiss the UIViewController
            controller.dismiss(animated: true)
        }
        
        // Called when the user cancels the document scanning
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            completionHandler(nil)
        }
        
        // Called when an error occurs during document scanning
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            print("Document camera view controller did finish with error ", error)
            completionHandler(nil)
        }
    }
}
