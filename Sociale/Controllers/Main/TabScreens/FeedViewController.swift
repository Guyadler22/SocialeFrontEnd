//
//  FeedViewController.swift
//  Sociale
//
//  Created by Guy Adler on 17/11/2023.
//

import UIKit
import Combine


class FeedViewController: UIViewController {

    @IBOutlet weak var feedTableView: UITableView!
    
    let viewModel = FeedViewModel()
    var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Feed controller")
        feedTableView.register(UINib(nibName: UploadTableViewCell.id, bundle: .main), forCellReuseIdentifier: UploadTableViewCell.id)
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
   
        viewModel.uploads.sink { [weak self] uploads in
            
            self?.feedTableView.reloadData()
            
        }.store(in: &subscriptions)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.get_uploads()
    }

}



extension FeedViewController : FeedCellDelegate {
    func onCommentsClicked(upload: UploadWithUser) {
        let vc = CommentViewController.create(with: upload)
        present(vc, animated: true)
    }
}

extension FeedViewController  : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.uploads.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UploadTableViewCell.id, for: indexPath)
        if let cell = cell as? UploadTableViewCell {
            cell.delegate = self
            cell.populate(upload: viewModel.uploads.value[indexPath.row])
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        400
    }
    
}
