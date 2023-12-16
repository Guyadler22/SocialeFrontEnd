import UIKit




class AlertView : UIView {
    
    
    static var showing = false
    var bottomConstraint : NSLayoutConstraint?
    var leadingConstraint : NSLayoutConstraint?
    var trailingConstraint : NSLayoutConstraint?
    
    
    
    lazy var textField: UILabel = {
        let tf = UILabel()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textAlignment = .center
        return tf
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(greaterThanOrEqualToConstant: 70).isActive = true
        backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        isUserInteractionEnabled = true
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
        
        layer.cornerRadius = 10.2
        clipsToBounds = true
        
    }
    
    convenience init(content: String) {
        self.init(frame: .zero)
        textField.attributedText = NSAttributedString(string: content, attributes: [.font: UIFont.boldSystemFont(ofSize: 16)])
        addSubview(textField)
        textField.numberOfLines = 0
        textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        textField.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func dismiss() {
        self.leadingConstraint?.constant = UIScreen.main.bounds.width / 2
        self.trailingConstraint?.constant = -UIScreen.main.bounds.width / 2
        
        self.setNeedsLayout()
        self.textField.layer.opacity = 0
        AlertView.showing = false
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.8) { [weak self] in
          
            self?.layoutIfNeeded()
        } completion: { [weak self] _ in
            self?.removeFromSuperview()
        }

    }
    
    func show(_ vc: UIViewController, dismissAfter: TimeInterval = 2.5) {
        vc.view.addSubview(self)
        AlertView.showing = true
        leadingConstraint = leadingAnchor.constraint(equalTo: vc.view.leadingAnchor, constant: 16)
        trailingConstraint = trailingAnchor.constraint(equalTo: vc.view.trailingAnchor, constant: -16)
        bottomConstraint = bottomAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.bottomAnchor, constant: 100)
        bottomConstraint!.isActive = true
        leadingConstraint!.isActive = true
        trailingConstraint!.isActive = true
        self.bottomConstraint?.constant = -24
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1) { [weak self] in
            self?.layoutIfNeeded()
        }
    
        DispatchQueue.main.asyncAfter(deadline: .now() + dismissAfter, execute: { [weak self] in
            self?.dismiss()
        })
    }
}
