//
//  CommentViewController.swift
//  Sociale
//
//  Created by Guy Adler on 09/12/2023.
//

import UIKit
import Combine

extension CommentViewController {
    static func create(with upload: UploadWithUser)  -> Self {
        let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: Self.id) as! Self
    
        vc.viewModel = CommentsViewModel(upload: upload)
        return vc
    }
}

class CommentViewController: UIViewController {
    
    static let id = "CommentViewController"
    var viewModel : CommentsViewModel!

    var subscriptions = Set<AnyCancellable>()
    
    @IBOutlet weak var commentTableVIew: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var commentProfileImage: UIImageView!
    @IBOutlet weak var commentTextLabel: UITextField!
    @IBOutlet weak var postButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTableVIew.register(UINib(nibName: CommentTableViewCell.id, bundle: .main), forCellReuseIdentifier: CommentTableViewCell.id)
        
        commentTableVIew.delegate = self
        commentTableVIew.dataSource = self
        
        viewModel.upload.sink { [weak self] upload in
            self?.commentTextLabel.text = ""
            self?.commentTableVIew.reloadData()
        }.store(in: &subscriptions)
        
        self.commentTextLabel.placeholder = "Add a comment for \(viewModel.upload.value.user.name)"
    }
    
    @IBAction func postTapped(_ sender: Any) {
        if let comment =  self.commentTextLabel.text,
           !comment.isEmpty {
            viewModel.post_comment(content: comment)
        }
    }
    
}

extension CommentViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.upload.value.comments.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.id, for: indexPath)
        if let cell = cell as? CommentTableViewCell {
            cell.populate(comment: viewModel.upload.value.comments[indexPath.row])
        }
        return cell
    }
    
}
