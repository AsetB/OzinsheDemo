//
//  UIViewController + Extensions.swift
//  OzinsheDemo
//
//  Created by Aset Bakirov on 22.12.2023.
//

import UIKit

//textfiled with image icon on the left
extension UITextField {
    func setIcon(_ image: UIImage) {
        let iconView = UIImageView(frame:
                                    CGRect(x: 10, y: 5, width: 20, height: 20))
        iconView.image = image
        
        let iconContainerView: UIView = UIView(frame: CGRect(x: 20, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
}

//adds padding to text inside TextField
class TextFieldWithPadding: UITextField {
    var padding = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 16)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

//Telephone number mask
extension String {
    func applyPatternOnNumbers(pattern: String, replacementCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacementCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
}

extension ProfileEditViewController {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneTextField {
            let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
            
            let formattedText = newText.applyPatternOnNumbers(pattern: "+# (###) ###-####", replacementCharacter: "#")
            
            let maxLength = "+# (###) ###-####".count
                if formattedText.count > maxLength {
                return false
            }
            textField.text = formattedText
            return false
        }
        return true
    }
}

//Checks email mask
public let __firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
public let __serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
public let __emailRegex = __firstpart + "@" + __serverpart + "[A-Za-z]{2,8}"
public let __emailPredicate = NSPredicate(format: "SELF MATCHES %@", __emailRegex)

extension String {
    func isEmail() -> Bool {
        return __emailPredicate.evaluate(with: self)
    }
}

extension UITextField {
    func isEmail() -> Bool {
        return self.text?.isEmail() ?? false
    }
}

//Page control with image
class CustomPageControl: UIPageControl {
    override func draw(_ rect: CGRect) {
        self.setIndicatorImage(UIImage(named: "RectanglePC"), forPage: currentPage)
    }
}

//For MovieInfo Description label maximum lines
extension UILabel {
    var maxNumberOfLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let text = (self.text ?? "") as NSString
        let textHeight = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
}
