//
//  ViewController.swift
//  Trainee app
//
//  Created by Stanislav Lezovsky on 26.03.2022.
//

import UIKit

final class NoteViewController: UIViewController, UITextFieldDelegate {

    // MARK: - константы
    let noteView = NoteView(frame: .zero)
    var completion: ((NoteModel) -> Void)?

    // MARK: - lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        noteView.titleField.delegate = self
        noteView.noteText.becomeFirstResponder()
        setupNavBar()
        notificationSetup()
        view.addSubview(noteView)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            let model = NoteModel(
                title: noteView.titleField.text,
                noteText: noteView.noteText.text,
                date: noteView.dateField.text
            )
            if model.isEmpty == true {
                model.saveNoteOrAlert(model: model, rootVC: self)
            } else {
                completion?(model)
            }
        }
    }

    // MARK: - метод обработки нажатия вне вью
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(
            touches,
            with: event
        )
    }

    override func viewWillLayoutSubviews() {
        noteView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
    }

    // MARK: - обсерверы для клавиаутуры
    private func notificationSetup() {
            let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(
                self,
                selector: #selector(keyboardWasShown(notification:)),
                name: UIResponder.keyboardWillShowNotification,
                object: nil
            )
            notificationCenter.addObserver(
                self,
                selector: #selector(keyboardWillBeHidden(notification:)),
                name: UIResponder.keyboardWillHideNotification,
                object: nil
            )
        }

    // MARK: - метод для сохранения
    @objc func saveViewData() {
        noteView.resignResponders()
            let model = NoteModel(
            title: noteView.titleField.text,
            noteText: noteView.noteText.text,
            date: noteView.dateField.text
        )
        if model.isEmpty == true {
        model.saveNoteOrAlert(model: model, rootVC: self)
        } else {
            completion?(model)
        }
    }

    // MARK: - настройка навигейшн бара
    private func setupNavBar() {
        let saveButton = UIBarButtonItem(
            title: "Готово",
            style: .done,
            target: self,
            action: #selector(saveViewData)
        )
        navigationItem.rightBarButtonItem = saveButton
        title = "Заметка"
    }

    // MARK: - методы для инсета контента при открытии клавиатуры
    @objc func keyboardWasShown(notification: NSNotification) {
        navigationItem.rightBarButtonItem?.isEnabled = true
        navigationItem.rightBarButtonItem?.tintColor = .systemBlue
        let info = notification.userInfo
        if let keyboardRect = info?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardSize = keyboardRect.size
            noteView.noteText.contentInset = UIEdgeInsets(top: 0, left: 0,
                                                          bottom: keyboardSize.height, right: 0)
            noteView.noteText.scrollIndicatorInsets = noteView.noteText.contentInset
        }
    }

    @objc func keyboardWillBeHidden(notification: NSNotification) {
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem?.tintColor = .clear
        noteView.noteText.contentInset = UIEdgeInsets(top: 0, left: 0,
                                                      bottom: 0, right: 0)
        noteView.noteText.scrollIndicatorInsets = noteView.noteText.contentInset
    }
}
