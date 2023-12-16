//
//  UploadTableViewCell.swift
//  Sociale
//
//  Created by Guy Adler on 27/11/2023.
//

import UIKit

protocol FeedCellDelegate : AnyObject {
    func onCommentsClicked(upload: UploadWithUser)
}

class UploadTableViewCell: UITableViewCell {
    
    static let id = "UploadTableViewCell"
    var upload: UploadWithUser!
    
    lazy var delegate: FeedCellDelegate? = nil
    
    var isCurrentUserLiked: Bool = false
    
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var massageButton: UIImageView!
    @IBOutlet weak var likeButton: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    
    @IBOutlet weak var uploadImage: UIImageView!
        
    override func prepareForReuse() {
        super.prepareForReuse()
        self.likeButton.image = UIImage(systemName: "heart")
        isCurrentUserLiked = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        likeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(like)))
        userImage.layer.cornerRadius = 22
        
        massageButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(commentTapped)))
        
        self.massageButton.isUserInteractionEnabled = true
                
    }
    
    @objc func commentTapped(){

        delegate?.onCommentsClicked(upload: upload)
    }
    
    
    
    
    @objc func like()  {
        Task { // Task - Runs Async
            do {
                let _ = try await SocialeAPI.post(endpoint: "user-uploads/like/\(upload._id)", data: LikeDto(likedTrue: !isCurrentUserLiked), responseBodyType: String.self)
                if isCurrentUserLiked {
                    // unlike
                    self.likeButton.image = UIImage(systemName: "heart")
                    if let user = AuthManager.instance.getUser() {
                        upload.likes = upload.likes.filter {u in
                            u._id != user._id
                        }
                    }
                } else {
                    self.likeButton.image = UIImage(systemName: "heart.fill")
                    if let user = AuthManager.instance.getUser() {
                        upload.likes.append(user.toUserSlice())
                    }
                }
              
                
                updatePeopleLikedLabel()
                isCurrentUserLiked = !isCurrentUserLiked
            } catch {
                print(error)
            }
        }
        
        
    }
    
    func updatePeopleLikedLabel() {
        likesLabel.text = "\(upload.likes.count) people liked this"
    }
    
    func populate(upload: UploadWithUser) {
        self.upload = upload
        upload.user.image?.downloadImage(to: userImage)
        if upload.is_video {
            if let previewUrl = upload.previewUrl {
                previewUrl.downloadImage(to: uploadImage)
            }
        } else {
            upload.uploadUrl.downloadImage(to: uploadImage)
        }
       
        // user details
        userNameLabel.text = upload.user.name
        
        // TODO: Location label
        // locationNameLabel.text = ...
        
        updatePeopleLikedLabel()
        
        
        if let user = AuthManager.instance.getUser() {
            if upload.likes
                .contains(where: { slice in
                    slice._id == user._id
                }) {
                isCurrentUserLiked = true
                
                self.likeButton.image = UIImage(systemName: "heart.fill")
            }
        }
    }
}
