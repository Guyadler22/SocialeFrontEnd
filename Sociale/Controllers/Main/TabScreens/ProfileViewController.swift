//
//  ProfileViewController.swift
//  Sociale
//
//  Created by Guy Adler on 17/11/2023.
//

import UIKit

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var uploadsCollectionView: UICollectionView!
    
    @IBOutlet weak var profileImageContainer: UIView!
    
    lazy var changeProfileButton  = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        view.widthAnchor.constraint(equalToConstant: 30).isActive = true
        view.layer.cornerRadius = 15
        view.backgroundColor = UIColor.white
        view.isUserInteractionEnabled = true
        let imageView = UIImageView(image: UIImage(named: "Plus"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openGallery)))
        view.addSubview(imageView)
        imageView.isUserInteractionEnabled = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return view
    }()
    
    
    @objc func openGallery() {
        openImageGallery(delegate: self)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Profile ciontroller")
        profileImageContainer.addSubview(changeProfileButton)
        changeProfileButton.trailingAnchor.constraint(equalTo: profileImageContainer.trailingAnchor, constant: 12).isActive = true
        
        changeProfileButton.bottomAnchor.constraint(equalTo: profileImageContainer.bottomAnchor).isActive = true
        
        
        if let user = AuthManager.instance.getUser(), let userImage = user.image {
            userImage.downloadImage(to: profileImageView)
        }
       
        
        profileImageView.layer.cornerRadius = 40
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = UIColor.systemGray3.cgColor
        profileImageView.clipsToBounds = true
        uploadsCollectionView.delegate = self
        uploadsCollectionView.dataSource = self
   
        uploadsCollectionView.register(UINib(nibName: ImageViewCollectionViewCell.id, bundle: nil), forCellWithReuseIdentifier: ImageViewCollectionViewCell.id)
        
        
        // Do any additional setup after loading the view.
    }
    

 
}



extension ProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage,
           let imageData = image.pngData() {
            if let token = AuthManager.instance.getToken() {
                Task {
                    let user = try await SocialeAPI.postProfileImage(data:imageData, token: token)
                    AuthManager.instance.setUser(user)
                    profileImageView.image = image
                }
            }
            
        }
        self.dismiss(animated: true)
        
    }
}
    

extension ProfileViewController : UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch AuthManager.instance.getUser() {
            case .some(let user):
             return user.uploads.count
            case .none:
             return 0
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:ImageViewCollectionViewCell.id,for: indexPath)
        if let cell = cell as? ImageViewCollectionViewCell {
            let user = AuthManager.instance.getUser()!
            cell.populate(user.uploads[indexPath.row])
            return cell
        } else {
            return cell
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width / 4, height: 100)
    }
    
}

