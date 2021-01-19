//
//  SwiftUIView.swift
//  ConanBus
//
//  Created by 白謹瑜 on 2021/1/19.
//

import SwiftUI


struct ImagePickerController:UIViewControllerRepresentable{
    
    @Binding var selectImage: Image
    @Binding var showSelectPhoto: Bool
    
    func makeCoordinator() -> ImagePickerController.Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var imagePickerController: ImagePickerController
        
        init(_ imagePickerController: ImagePickerController) {
            self.imagePickerController = imagePickerController
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                imagePickerController.selectImage = Image(uiImage: uiImage)
            }
            imagePickerController.showSelectPhoto = false
        }
        
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerController>) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.delegate = context.coordinator
        return controller
        
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePickerController>) {
    }
    
}

struct SwiftUIView: View {
    @State private var selectImage = Image(systemName: "photo")
    @State private var showSelectPhoto = false
    
    var body: some View {
        ZStack{
            VStack{
                Button(action: {
                    self.showSelectPhoto = true
                }) {
                    selectImage
                        .resizable()
                        .scaledToFill()
                        .frame(width:200, height:200)
                        .clipped()
                        .foregroundColor(.blue)
                }
                .buttonStyle(PlainButtonStyle())
                .sheet(isPresented: $showSelectPhoto) {
                    ImagePickerController(selectImage: self.$selectImage, showSelectPhoto:
                                            self.$showSelectPhoto)
                }
            }
        }        
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
