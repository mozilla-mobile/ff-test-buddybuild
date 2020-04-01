//
//  ViewController.swift
//  MVCSplit
//
//  Created by Nishant Bhasin on 2020-03-12.
//  Copyright © 2020 Nishant Bhasin. All rights reserved.
//

import UIKit
import SnapKit

/* The layout for ViewController Money Split
   
|----------------|
|     Image      |
|    [Centre]    | (Top View)
|     $Split     |
|                |
|                |
|Attendees  Input| // Input is of type textfield
|Amount     Input| // Input is of type textfield
|                |
|    [Button]    | (Bottom View)
|----------------|

*/

class ViewController: UIViewController, UITextViewDelegate {

    // Views
    private lazy var topMoneyImageView: UIImageView = {
        let imgView = UIImageView(image: #imageLiteral(resourceName: "money"))
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    private lazy var topSplitLabel: UILabel = {
        let label = UILabel()
        label.text = totalSplitValueDescription
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private lazy var attendeesLabel: UILabel = {
        let label = UILabel()
        label.text = "Total attendees"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    private lazy var attendeesTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .right
        textView.textColor = .black
        textView.font = UIFont.boldSystemFont(ofSize: 18)
        textView.backgroundColor = UIColor(red:0.90, green:0.92, blue:0.93, alpha:1.0)
        textView.textContainer.maximumNumberOfLines = 1
        return textView
    }()
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.text = "Total amount"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    private lazy var amountTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .right
        textView.textColor = .black
        textView.font = UIFont.boldSystemFont(ofSize: 18)
        textView.backgroundColor = UIColor(red:0.90, green:0.92, blue:0.93, alpha:1.0)
        textView.textContainer.maximumNumberOfLines = 1
        return textView
    }()
    private var calculateSplitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Calculate Split", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBlue
        return button
    }()
    
    private var totalSplitValueDescription: String {
            return "$\(totalSplit)"
    }
    // Variables specific to business logic
    private var totalAttendees: Double {
        return Double(attendeesTextView.text) ?? 0
    }
    private var totalAmount: Double {
        return Double(amountTextView.text) ?? 0
    }
    private var totalSplit = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // Initialize
        self.view.addSubview(topMoneyImageView)
        self.view.addSubview(topSplitLabel)
        self.view.addSubview(attendeesLabel)
        self.view.addSubview(attendeesTextView)
        self.view.addSubview(amountLabel)
        self.view.addSubview(amountTextView)
        self.view.addSubview(calculateSplitButton)
        
        amountTextView.delegate = self
        attendeesTextView.delegate = self
        
        // The top imageview constraints setup
        topMoneyImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.height.lessThanOrEqualTo(180)
        }
        
        topSplitLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(topMoneyImageView.snp.bottom).offset(50)
            make.height.lessThanOrEqualTo(40)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.bottom.equalTo(attendeesLabel.snp.top).offset(-30)
            make.height.lessThanOrEqualTo(30)
            make.width.lessThanOrEqualTo(150)
        }
        
        attendeesLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.bottom.equalTo(calculateSplitButton.snp.top).offset(-40)
            make.height.lessThanOrEqualTo(30)
            make.width.lessThanOrEqualTo(150)
        }
        
        attendeesTextView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.left.equalTo(attendeesLabel.snp.right).offset(20)
            make.bottom.equalTo(calculateSplitButton.snp.top).offset(-40)
            make.height.equalTo(23)
        }
        
        amountTextView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.left.equalTo(amountLabel.snp.right).offset(38)
            make.bottom.equalTo(attendeesLabel.snp.top).offset(-30)
            make.height.equalTo(23)
        }
        
        calculateSplitButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            make.height.equalTo(40)
        }
        
        calculateSplitButton.addTarget(self, action: #selector(calculateSplitButtonAction), for: .touchUpInside)
    }
    
    // Business Logic
    func calculateTotalSplit() -> Double {
        var split = 0.0
        // Total Amount is 0
        guard totalAmount > 0 else { return 0 }
        // Total Attendees are 0
        guard totalAttendees > 0 else { return 0 }
        // Total Attendees are 1
        if totalAttendees == 1 { return totalAmount }
        
        split = (totalAmount / totalAttendees)
        
        return split
    }
    
    // Button Action
    
    @objc func calculateSplitButtonAction() {
        self.totalSplit = calculateTotalSplit()
        print("total split -> \(totalSplitValueDescription)")
        self.topSplitLabel.text = totalSplitValueDescription
    }
    
    // Textfield Delegate
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.isEmpty { return true }
        if textView.text.isEmpty && (Double(text) != nil) { return true }
        if textView.text.contains(".") && text == "." { return false }
        guard let _ = Double(textView.text) else {
            return false
        }
        return true
    }
}

