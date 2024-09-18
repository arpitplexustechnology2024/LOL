//
//  EditQuestionPopup.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 12/09/24.
//

import UIKit

class EditQuestionPopup: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var editQuestionPopupView: UIView!
    @IBOutlet weak var editQuestionLabel: UILabel!
    @IBOutlet weak var editQuestionTextFiled: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var countTextLabel: UILabel!
    
    var currentQuestionText: String?
    var updateAction: ((String) -> Void)?
    
    let characterLimit = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateCharacterCountLabel()
    }
    
    private func setupUI() {
        editQuestionTextFiled.delegate = self
        editQuestionTextFiled.returnKeyType = .done
        hideKeyboardTappedAround()
        editQuestionPopupView.layer.cornerRadius = 25
        editQuestionTextFiled.layer.cornerRadius = 5
        editQuestionTextFiled.layer.masksToBounds = true
        updateButton.layer.cornerRadius = updateButton.frame.height / 2
        updateButton.applyGradient(colors: [UIColor(hex: "#FA4957"), UIColor(hex: "#FD7E41")])
        cancelButton.layer.cornerRadius = cancelButton.frame.height / 2
        cancelButton.layer.backgroundColor = UIColor.editpopup.cgColor
        editQuestionTextFiled.text = currentQuestionText
    }
    
    @IBAction func btnCancelTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnUpdateTapped(_ sender: UIButton) {
        guard let newQuestionText = editQuestionTextFiled.text, !newQuestionText.isEmpty else { return }
        updateAction?(newQuestionText)
        self.dismiss(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func updateCharacterCountLabel() {
        let currentTextCount = editQuestionTextFiled.text?.count ?? 0
        countTextLabel.text = "\(currentTextCount)/\(characterLimit)"
        
        if currentTextCount == characterLimit {
            editQuestionTextFiled.layer.borderWidth = 1
            editQuestionTextFiled.layer.borderColor = UIColor.boadercolor.cgColor
            countTextLabel.textColor = .boadercolor
        } else {
            editQuestionTextFiled.layer.borderWidth = 0
            countTextLabel.textColor = .whiteBlack
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        updateCharacterCountLabel()
        return updatedText.count <= characterLimit
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        updateCharacterCountLabel()
    }
}

