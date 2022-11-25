//
//  BurbankAlertVC.swift
//  BurbankApp
//
//  Created by dmss on 06/02/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit

class BurbankAlertVC: UIViewController
{
    var titleLabel: UILabel! =
        {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = UIColor.orangeBurBankColor()
        //label.font = burbankFont(size: 14.0)
            label.font = ProximaNovaSemiBold(size: 16.0)

        return label
    }()
    var messageLabel: UILabel! = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = ProximaNovaRegular(size: 15.0)
        label.numberOfLines = 0
        
        return label
    }()
    var alertView: UIControl! = {
        let view = UIControl()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.cornerRadius = 5.0
        
        return view
    }()
    var buttonsStackView: UIStackView! = {
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 10
        
        
        return stackView
    }()
    var buttonsStackViewWidthAnchor: NSLayoutConstraint!
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var messageLabel: UILabel!
    
    init(title: String, message: String) {

        super.init(nibName: nil, bundle: nil)
        titleLabel.text = title
        messageLabel.text = message
    }
    let heightFactor: CGFloat = 0.049
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0)
        view.addSubview(alertView)
        alertView.addSubview(buttonsStackView)
        
        setUpAlertView()
        setUpLabels()
        setUpButtonStackView()
    }
    

    private func setUpButtonProperties(button: UIButton, isHighlighted: Bool)
    {
        let radius = SCREEN_HEIGHT * heightFactor * 0.5
        button.cornerRadius = radius
        button.borderWidth = 1.0
        if isHighlighted == false
        {
            button.setTitleColor(.black, for: .normal)
            button.borderColor = UIColor.black
        }else
        {
            button.setTitleColor(UIColor.orangeBurBankColor(), for: .normal)
            button.borderColor = UIColor.orangeBurBankColor()
        }
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       // dismiss(animated: true, completion: nil)
        
    }
    private func setUpAlertView()
    {
        alertView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        alertView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        var  multipler: CGFloat = 0.26
        if IS_IPHONE_4
        {
            multipler = 0.3
        }else
        {
            multipler = 0.26
        }
        alertView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multipler).isActive = true
        let label = UILabel()
        alertView.addSubview(label)
        
    }
    private func setUpLabels()
    {
        let titleBackGroundView = UIView()
        titleBackGroundView.translatesAutoresizingMaskIntoConstraints = false
        alertView.addSubview(titleBackGroundView)
        titleBackGroundView.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 10).isActive = true
        titleBackGroundView.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: 0).isActive = true
        titleBackGroundView.topAnchor.constraint(equalTo: alertView.topAnchor).isActive = true
        titleBackGroundView.heightAnchor.constraint(equalTo: alertView.heightAnchor, multiplier: 0.25).isActive = true
        titleBackGroundView.addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: titleBackGroundView.leftAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: titleBackGroundView.centerYAnchor).isActive = true
        alertView.addSubview(messageLabel)
        messageLabel.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 15).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -15).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleBackGroundView.bottomAnchor, constant: 15).isActive = true
       // messageLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.lightGray
        alertView.addSubview(label)
        label.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 0).isActive = true
        label.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: 0).isActive = true
        label.topAnchor.constraint(equalTo: titleBackGroundView.bottomAnchor, constant: 0).isActive = true
        label.heightAnchor.constraint(equalToConstant: 0.5).isActive = true

        
        
    }
    var stackViewWidth: CGFloat = 0 //SCREEN_HEIGHT * heightFactor * 2.5// w:h = 2.5: 1 aspet ratio with height
    private func setUpButtonStackView()
    {
        stackViewWidth = SCREEN_HEIGHT * heightFactor * 2.5
        buttonsStackView.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -10).isActive = true
        buttonsStackView.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -10).isActive = true
        let height = SCREEN_HEIGHT * heightFactor
        buttonsStackView.heightAnchor.constraint(equalToConstant: height).isActive = true
        buttonsStackViewWidthAnchor = buttonsStackView.widthAnchor.constraint(equalToConstant: stackViewWidth)
        buttonsStackViewWidthAnchor.isActive = true
    }
    func addButton(button: UIButton)
    {
        setUpButtonProperties(button: button,isHighlighted: true)
        stackViewWidth = stackViewWidth + stackViewWidth/*SCREEN_HEIGHT * heightFactor * 2.5 */+ 10
        buttonsStackViewWidthAnchor.constant = stackViewWidth
        buttonsStackView.addArrangedSubview(button)
    }
    func addDefaultButton(title: String)
    {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.addTarget(self, action: #selector(defaultButtonTapped(sender:)), for: .touchDown)
        setUpButtonProperties(button: btn, isHighlighted: false)
        buttonsStackView.addArrangedSubview(btn)
    }
    @objc func defaultButtonTapped(sender: AnyObject)
    {
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
