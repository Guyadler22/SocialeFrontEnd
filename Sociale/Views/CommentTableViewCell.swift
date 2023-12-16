//
//  CommentTableViewCell.swift
//  Sociale
//
//  Created by Guy Adler on 09/12/2023.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    static let id = "CommentTableViewCell"
    
    //var comment:Comment!
    var isCurrentUserLiked: Bool = false

    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var userNameCell: UILabel!
    
    @IBOutlet weak var commentCell: UILabel!
    
    @IBOutlet weak var commentLikeButton: UIImageView!
   
    @IBOutlet weak var CommentTImeCell: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.commentLikeButton.image = UIImage(systemName: "heart")?.withRenderingMode(.alwaysOriginal)
        isCurrentUserLiked = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commentLikeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(like)))
        profileImage.layer.cornerRadius = 20
        
    }
    
    @objc func like(){
        
    }
    
    func populate(comment : Comment){
        comment.user.image?.downloadImage(to: profileImage)
        userNameCell.text = comment.user.name
        commentCell.text = comment.content
        
        let created_at = comment.created_at.toIntDate()
        let now = IntDate.now()
        let diff_sec = now.difference_sec(other: created_at)
        
        if diff_sec > 60 {
            let diff_min = now.difference_min(other: created_at)
            self.CommentTImeCell.text = "\(diff_min)m"
        } else {
            self.CommentTImeCell.text = "\(diff_sec)s"
        }
        
        
    }
    
    
    
}
