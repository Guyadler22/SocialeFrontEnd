//
//  UploadViewController.swift
//  Sociale
//
//  Created by Guy Adler on 16/10/2023.
//

import Foundation
import UIKit
import MobileCoreServices
import UniformTypeIdentifiers



extension UploadViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage,
           let imageData = image.pngData() {
            openShareVC(upload: .Image(imageData))
        }
        self.dismiss(animated: true)
    
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let url = urls.first {
            do {
                let data = try Data(contentsOf: url)
                openShareVC(upload: .Video(data, videoSnapshot(vidURL: url)))
               // self.uploadFileData = data
            } catch {
                showAlert(content: error.localizedDescription)
            }
        }
    }
}


extension UploadViewController {
    
    func openShareVC(upload: UploadType) {
        performSegue(withIdentifier: "toShareScreen", sender: upload)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? SharePostViewController,
           let uploadType = sender as? UploadType {
            
            dest.uploadType = uploadType
            dest.shareDelegate = self
            
        }
    }
}



extension UploadViewController : PostShareDelegate {
    func share(post: PostDto) {
        guard let token = AuthManager.instance.getToken() else {return}
        Task {
            do  {
                navigationController?.popViewController(animated: true)
                switch post.uploadType {
                case .Image(let imageData):
                    let user_with_image = try await SocialeAPI.postImage(data: imageData,
                                                                       postBody: post.body,
                                                                       fileType: .Video,
                                                                       token:token)
                    AuthManager.instance.setUser(user_with_image)
                    
                    showAlert(content: "Uploaded image successfully", dismissAfter: 4)
                    break;
                case .Video(let videoData, _):
                    let user_with_video = try await SocialeAPI.postImage(data: videoData,
                                                                       postBody: post.body,
                                                                       fileType: .Video,
                                                                       token:token)
                    AuthManager.instance.setUser(user_with_video)
                    showAlert(content: "Uploaded video successfully", dismissAfter: 4)
                }
                
            } catch {
                handleApiError(error)
            }
        }
    }
}

class UploadViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!

    @IBOutlet weak var viewToolBar: UIView!
    
    @IBOutlet weak var selectedImage: UIImageView!
    
    @IBOutlet weak var cameraIv: UIImageView!
    @IBOutlet weak var galleryIv: UIImageView!
 
    
    func selectFiles(type: UTType) {
       
        let types = [type]
        let documentPickerController = UIDocumentPickerViewController(
                forOpeningContentTypes: types)
        documentPickerController.delegate = self
        self.present(documentPickerController, animated: true, completion: nil)
    }
    
    @objc func openCamera() {
       
        let types = [UTType.mpeg4Movie]
        let picker = UIImagePickerController()
        picker.sourceType  = .camera
        picker.mediaTypes = [kUTTypeImage as String]
        picker.videoQuality = .typeMedium
        picker.delegate = self
        self.present(picker, animated: true)
    }

    @objc func pickImage(_ sender: Any) {
        
        let alert = UIAlertController(title: "Pick from gallery", message: "Choose file type", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Video", style: .default,handler: {[weak self] act in
            self?.selectFiles(type: UTType.mpeg4Movie)
        }))
        alert.addAction(UIAlertAction(title: "Image", style: .default, handler: {[weak self] act in
            if let strongSelf = self {
                strongSelf.openImageGallery(delegate: strongSelf)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        present(alert, animated: true)
        //image

        // video
       
    }
    
    
    @IBAction func openUploads(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "MyUploadsViewController")
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Upload View controller")
        cameraIv.isUserInteractionEnabled = true
        cameraIv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openCamera)))
   
        galleryIv.isUserInteractionEnabled = true
        galleryIv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickImage)))
    }
    
    @IBAction func signOut(_ sender: Any) {
        
        let alert = UIAlertController(title: "Signout", message: "Would you like to signout?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Signout", style: .destructive) { [weak self] view in
        
            if let router = self?.getRouter() {
                AuthManager.instance.removeToken()
                let homeNavController = UIStoryboard(name: "Main", bundle: .main)
                router.changeRootViewController(vc: homeNavController.instantiateViewController(withIdentifier: "AuthNavController"))
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        present(alert, animated: true)
    }
}
