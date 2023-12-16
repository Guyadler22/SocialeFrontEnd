//
//  TabBarController.swift
//  Sociale
//
//  Created by Guy Adler on 15/11/2023.
//

import UIKit

enum Screen {
   case Feed, Upload, Profile
}



class TabBarController: UITabBarController {

    static let GRAY  = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1)
    static let TAB_BAR_HEIGHT : CGFloat = 80
    static let UPLOAD_TAB_ANIMATION_OFFSET: CGFloat = 20
    static let UPLOAD_TAB_OFF_SET_TOP: CGFloat = TabBarController.TAB_BAR_HEIGHT/4
    static let UPLOAD_TAB_SIZE : CGFloat = 80
    
    
    
    var screen = Screen.Upload
    var uploadTabTopConstraint : NSLayoutConstraint?
    
    lazy var customTabBar : UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var uploadTab: UIView = {
        let view = UIImageView(image: UIImage(named: "Plus"))
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    lazy var profileTab: UIImageView = {
        let view = UIImageView(image: UIImage(named: "profile")?.withTintColor(TabBarController.GRAY))
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    lazy var homeTab: UIImageView = {
        let view = UIImageView(image: UIImage(named: "home")?.withTintColor(TabBarController.GRAY))
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
            
      //  tabBar.removeFromSuperview()
        
    

        view.addSubview(customTabBar)
        
         
        customTabBar.addSubview(homeTab)
        customTabBar.addSubview(uploadTab)
        customTabBar.addSubview(profileTab)

        
        setConstraints()
        setTabItemsActions()
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.8) { [weak self] in
            
            self?.uploadTab.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self?.customTabBar.layoutIfNeeded()
        }
       
    }
    
    
    override func viewDidLayoutSubviews() {
        tabBar.removeFromSuperview()
     
    }
    
    
    func setConstraints() {
        
        customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        customTabBar.heightAnchor.constraint(equalToConstant: TabBarController.TAB_BAR_HEIGHT).isActive = true
        customTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        customTabBar.backgroundColor = UIColor(red: 248 / 255, green: 248/255, blue: 248 / 255, alpha: 1)
        
        
        let querterWidth : CGFloat = UIScreen.main.bounds.width / 6
        
        homeTab.trailingAnchor.constraint(equalTo: uploadTab.leadingAnchor, constant: -querterWidth).isActive = true
        homeTab.centerYAnchor.constraint(equalTo: customTabBar.centerYAnchor, constant: 0).isActive = true
        homeTab.widthAnchor.constraint(equalToConstant: 45).isActive = true
        homeTab.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        uploadTab.centerXAnchor.constraint(equalTo: customTabBar.centerXAnchor).isActive = true
        uploadTabTopConstraint = uploadTab.centerYAnchor.constraint(equalTo: customTabBar.centerYAnchor,constant: -TabBarController.UPLOAD_TAB_OFF_SET_TOP)
        uploadTabTopConstraint!.isActive = true
        
        uploadTab.widthAnchor.constraint(equalToConstant: TabBarController.UPLOAD_TAB_SIZE).isActive = true
        uploadTab.heightAnchor.constraint(equalToConstant: TabBarController.UPLOAD_TAB_SIZE).isActive = true
        
        
        
        profileTab.leadingAnchor.constraint(equalTo: uploadTab.trailingAnchor, constant: querterWidth).isActive = true
        profileTab.centerYAnchor.constraint(equalTo: customTabBar.centerYAnchor, constant: 0).isActive = true
        profileTab.widthAnchor.constraint(equalToConstant: 45).isActive = true
        profileTab.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
    
    }
    
    
    @objc func changeScreenGestureAction(_ sender: Any?) {
        if let gr = sender as? UITapGestureRecognizer,
           let tab = gr.view {
            
            if tab == homeTab && screen != .Feed {
            
                changeVC(screen: .Feed)
                homeTab.image = homeTab.image?.withTintColor(UIColor.black)
                profileTab.image = profileTab.image?.withTintColor(TabBarController.GRAY)
                
                self.uploadTabTopConstraint?.constant = -TabBarController.UPLOAD_TAB_OFF_SET_TOP
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.8) { [weak self] in
                    self?.uploadTab.transform = CGAffineTransform.identity
                    self?.customTabBar.layoutIfNeeded()
                }
                screen = .Feed
            }
            else if tab == uploadTab && screen != .Upload {
                changeVC(screen: .Upload)
                
                homeTab.image = homeTab.image?.withTintColor(TabBarController.GRAY)
                profileTab.image = profileTab.image?.withTintColor(TabBarController.GRAY)
               
                self.uploadTabTopConstraint?.constant -= TabBarController.UPLOAD_TAB_ANIMATION_OFFSET
                
                
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.8) { [weak self] in
                    
                    self?.uploadTab.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    self?.customTabBar.layoutIfNeeded()
                }
                screen = .Upload
            }
            else if tab == profileTab && screen != .Profile {
                changeVC(screen: .Profile)
                homeTab.image = homeTab.image?.withTintColor(TabBarController.GRAY)
                profileTab.image = profileTab.image?.withTintColor(UIColor.black)
                
        
                self.uploadTabTopConstraint?.constant = -TabBarController.UPLOAD_TAB_OFF_SET_TOP
                
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.8) { [weak self] in
                    self?.uploadTab.transform = CGAffineTransform.identity
                    self?.customTabBar.layoutIfNeeded()
                }
                screen = .Profile
            }
        
            
        }
      
    }
  
    
    func setTabItemsActions() {
   
        homeTab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeScreenGestureAction)))
        profileTab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeScreenGestureAction)))
        uploadTab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeScreenGestureAction)))
    }
    
    
    func changeVC(screen: Screen) {
        
        switch screen {
            case .Upload:
                selectedIndex = 0
            case .Profile:
                selectedIndex = 1
            case .Feed:
                selectedIndex = 2
        }
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
