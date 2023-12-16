//
//  ExampleCVisionView.swift
//  Bra image recognition
//
//  Created by dadDev on 12/16/23.
//

import Foundation
import SwiftUI
import Vision
import CoreML
import AVFoundation
import PhotosUI

// Model Protocol
protocol ImageRecognitionModel {
    func recognizeImage(_ image: UIImage, completion: @escaping (String?, Error?) -> Void)
}

// ViewModel
class ImageRecognitionViewModel: ObservableObject {
    @Published var recognizedText: String?
    @Published var errorMessage: String?

    var model: ImageRecognitionModel

    init(model: ImageRecognitionModel) {
        self.model = model
    }

    func recognizeImage(_ image: UIImage) {
        model.recognizeImage(image) { recognizedText, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                } else {
                    self.recognizedText = recognizedText
                }
            }
        }
    }
}

// Core ML Model Implementation
class CoreMLImageRecognitionModel: ImageRecognitionModel {
    func recognizeImage(_ image: UIImage, completion: @escaping (String?, Error?) -> Void) {
        guard let model = try? VNCoreMLModel(for: FoodClassifier().model) else {
            completion(nil, NSError(domain: "ImageRecognition", code: 1, userInfo: [NSLocalizedDescriptionKey: "Model loading failed."]))
            return
        }

        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation], let topResult = results.first else {
                completion(nil, NSError(domain: "ImageRecognition", code: 2, userInfo: [NSLocalizedDescriptionKey: "No results found."]))
                return
            }

            completion(topResult.identifier, nil)
        }

        guard let ciImage = CIImage(image: image) else {
            completion(nil, NSError(domain: "ImageRecognition", code: 3, userInfo: [NSLocalizedDescriptionKey: "Image conversion failed."]))
            return
        }

        let handler = VNImageRequestHandler(ciImage: ciImage)

        do {
            try handler.perform([request])
        } catch {
            completion(nil, error)
        }
    }
}

// SwiftUI View
struct ContentView: View {
    @StateObject private var viewModel = ImageRecognitionViewModel(model: CoreMLImageRecognitionModel())
    @State private var selectedImage: UIImage?
    @State var imageSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(from: imageSelection)
        }
    }
    
    @State private var isShowPhotoLibrary = false
    @State private var image: Image?
    @State private var isShowImagePicker = false


    var body: some View {
        VStack {
            
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
//            Image(uiImage: selectedImage ?? UIImage(systemName: "photo")!)
//                .resizable()
//                .scaledToFit()
//                .frame(width: 200, height: 200)
//                .onTapGesture {
//                    // Logic to pick an image from the gallery or camera
//                    // Set the selectedImage variable with the chosen image
////                    ImagePicker(image: self.$image, isImagePickerPresented: self.$isShowImagePicker)
//                    
//                    
//                }
            PhotosPicker(selection: $imageSelection ) {
                Text("Select Photo")
            }

            Button("Recognize Image") {
                if let selectedImage = selectedImage {
                    viewModel.recognizeImage(selectedImage)
                }
            }

            if let recognizedText = viewModel.recognizedText {
                Text("Recognized Text: \(recognizedText)")
            }

            if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
            }
        }
        .padding()
    }
    
    private func setImage(from imageSelection: PhotosPickerItem?) {
        guard let imageSelection else { return }
        
        Task {
            if let data = try? await imageSelection.loadTransferable(type: Data.self) {
                if let uiimage = UIImage(data: data) {
                    selectedImage = uiimage
                    return
                }
            }
        }
    }
}


struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: Image?
    @Binding var isImagePickerPresented: Bool

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var image: Image?
        @Binding var isImagePickerPresented: Bool

        init(image: Binding<Image?>, isImagePickerPresented: Binding<Bool>) {
            _image = image
            _isImagePickerPresented = isImagePickerPresented
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                image = Image(uiImage: uiImage)
            }

            isImagePickerPresented = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isImagePickerPresented = false
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(image: $image, isImagePickerPresented: $isImagePickerPresented)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        // Update the view controller if needed
    }
}
