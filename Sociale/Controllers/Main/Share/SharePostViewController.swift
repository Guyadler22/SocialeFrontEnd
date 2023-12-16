//
//  SharePostViewController.swift
//  Sociale
//
//  Created by Guy Adler on 17/11/2023.
//

import UIKit




protocol PostShareDelegate : AnyObject {
    func share(post: PostDto)
}

class SharePostViewController: UIViewController {
 
    var uploadType: UploadType!
    
    var shareDelegate: PostShareDelegate!
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var postCaptionTv: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        switch uploadType {
            case .Video(_, let uIImage):
                postImageView.image = uIImage
            case .Image(let data):
                postImageView.image = UIImage(data: data)
            default:
                break
        }
      
       
    }
    
    @IBAction func share(_ sender: Any) {
        let caption = postCaptionTv.text ?? ""
        var postBody = PostBody(caption: caption,is_video: false)
        switch uploadType {
            case .Video(_, _):
                postBody.is_video = true
            default:
                break
        }
        
        let post = PostDto(uploadType: uploadType, body: postBody)
        
        shareDelegate.share(post: post)
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
