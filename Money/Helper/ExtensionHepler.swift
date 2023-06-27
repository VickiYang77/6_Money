//
//  ExtensionHepler.swift
//  Money
//
//  Created by Vicki Yang on 2023/5/13.
//

import UIKit

extension UINavigationBar {
    func addBottomSeparator(color: UIColor = .topSeparator) {
        let separatorView = UIView()
        separatorView.backgroundColor = color
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: separatorView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: separatorView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: separatorView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0),
            separatorView.heightAnchor.constraint(equalToConstant: 1.0)
        ])
    }
}

extension UIView {
    static var identifier: String {
        return String(describing: self)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "\(Self.self)", bundle: nil)
    }
}

extension DateFormatter {
    static func stringyyyyMMdd(from date: Date) -> String {
        return DateFormatter.string(from: date, format: "yyyy-MM-dd")
    }
    
    static func stringyyyyMMddAndTime(from date: Date) -> String {
        return DateFormatter.string(from: date, format: "yyyy-MM-dd HH:mm:ss")
    }
    
    static func string(from date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}
