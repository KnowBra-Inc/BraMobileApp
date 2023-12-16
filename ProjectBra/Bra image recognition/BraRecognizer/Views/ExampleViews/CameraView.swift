////
////  CameraViews.swift
////  Bra image recognition
////
////  Created by Elderied McKinney on 12/2/23.
////
//
//import SwiftUI
//import UIKit
//
//struct CameraView: UIViewControllerRepresentable {
//    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//        var parent: CameraView
//
//        init(parent: CameraView) {
//            self.parent = parent
//        }
//
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//            if let image = info[.originalImage] as? UIImage {
//                parent.image = image
//            }
//
//            parent.$presentationMode.wrappedValue.dismiss()
//        }
//
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            parent.$presentationMode.wrappedValue.dismiss()
//        }
//    }
//
//    @Binding var presentationMode: PresentationMode
//    @Binding var image: UIImage?
//
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(parent: self)
//    }
//
//    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraView>) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.delegate = context.coordinator
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<CameraView>) {
//        // Update the view controller if needed
//    }
//}
//
//struct ContentView: View {
//    @State private var showSuccessScreen = false
//    @State private var capturedImage: UIImage?
//    @Binding var presentationMode: PresentationMode
//    @Binding var image: UIImage?
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                Button("Capture Picture") {
//                    self.showSuccessScreen = true
//                }
//                .padding()
//                .foregroundColor(.white)
//                .background(Color.blue)
//                .cornerRadius(10)
//
//                NavigationLink(
//                    destination: SuccessScreen(),
//                    isActive: $showSuccessScreen,
//                    label: { EmptyView() }
//                ).hidden()
//
//                CameraView(presentationMode: presentationMode, image: $capturedImage)
//            }
//            .navigationTitle("Capture App")
//        }
//    }
//}
