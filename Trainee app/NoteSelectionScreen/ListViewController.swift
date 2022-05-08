//
//  ListViewController.swift
//  Trainee app
//
//  Created by Stanislav Lezovsky on 17.04.2022.
//

import UIKit

final class ListViewController: UIViewController {

    // MARK: - константы
    private enum Constants {
        static let buttonSymbolConfig = UIImage.SymbolConfiguration(pointSize: 36, weight: .thin, scale: .default)
        static let plusButtonBlueColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)
        static let buttonSymbol = UIImage(systemName: "plus", withConfiguration: buttonSymbolConfig)
        static let savedNotesKey = "My Key"
    }
    private let notesTable = UITableView(frame: .zero, style: .insetGrouped)
    var notes = [NoteModel]()

    lazy var alert: UIAlertController = {
        let alert = UIAlertController(
            title: "Нечего удалять",
            message: "Не выбрано ни одной заметки для удаления",
            preferredStyle: .alert
        )
        let actionOK = UIAlertAction(title: "Продолжить", style: .cancel)
        alert.addAction(actionOK)
        return alert
    }()

    let plusButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Constants.plusButtonBlueColor
        button.layer.cornerRadius = 25
        button.setImage(Constants.buttonSymbol, for: .normal)
        button.tintColor = .white
        button.layer.masksToBounds = true
        button.addTarget(
            NoteViewController(),
            action: #selector(buttonMethod),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        plusButton.center.y += 90.0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(
            withDuration: 2.5,
            delay: 0.0,
            usingSpringWithDamping: 0.1,
            initialSpringVelocity: 10.0,
            options: [.layoutSubviews],
            animations: {
                self.plusButton.center.y -= 90.0
        },
            completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotesTable()
        addSaveNotificationOnAppDismiss()
        navigationItem.rightBarButtonItem = editButtonItem
        editButtonItem.title = "Выбрать"
    }

    // MARK: - сетап таблицы
    private func setupNotesTable () {
        title = "Заметки"
        self.notesTable.separatorStyle = .none
        notesTable.dataSource = self
        notesTable.delegate = self
        view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        view.addSubview(notesTable)
        view.addSubview(plusButton)
        view.bringSubviewToFront(plusButton)
        notesTable.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        notesTable.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            notesTable.topAnchor.constraint(equalTo: view.topAnchor),
            notesTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            notesTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            notesTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            plusButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: +60),
            plusButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -19),
            plusButton.widthAnchor.constraint(equalToConstant: 50),
            plusButton.heightAnchor.constraint(equalTo: plusButton.widthAnchor)
        ])
        notesTable.register(NotePreviewCell.self, forCellReuseIdentifier: "cell")
    }

    // MARK: - метод для кнопки "плюс" + кложур для новых заметок
    @objc private func buttonMethod() {
        if notesTable.isEditing == true {
            removeSelected()
        } else {
            noteCreationAnimation()
        }
    }

    private func createNewNote() {
        let newNoteVC = NoteViewController()
        DispatchQueue.main.async {
            newNoteVC.completion = { [weak self] model in
                self?.notes.append(model)
                self?.notesTable.reloadData()
            }
        }
        newNoteVC.title = "Note Pad"
        self.navigationController?.pushViewController(newNoteVC, animated: true)
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        notesTable.setEditing(editing, animated: true)
        switch isEditing {
        case true:
            self.editButtonItem.title = "Готово"
            buttonForDeletionTransition()
        case false:
            self.editButtonItem.title = "Выбрать"
            buttonForAddTransition()
            }
        }

    private func removeSelected() {
        // теперь массив не фильтруется а полностью очищается, я чет не могу найти, что я упустил
//        let filteredNotes = notes.filter {$0.selectionState == true}
        let filetered = [NoteModel]()
        if filetered.isEmpty {
            self.present(alert, animated: true, completion: nil)
        }
        print(notes.count)
//        notesTable.reloadData()
        //        1 способ
        //        notes.removeAll(where: {$0.selectionState == true})
        //        2 способ
        //        for note in notes {
        //            if note.selectionState == true {
        //                if let indexPaths = notesTable.indexPathsForSelectedRows {
        //                    let sortedArray = indexPaths.sorted {$0.row > $1.row}
        //                    for ino in (0...sortedArray.count - 1).reversed() {
        //                        notes.remove(at: sortedArray[ino].row)
        //                    }
        //                    notesTable.deleteRows(at: sortedArray, with: .fade)
        //                }
        //            }
        //        }
        //        3 способ
        //        for (index, note) in notes.enumerated() {
        //            if note.selectionState == true {
        //                notes.remove(at: index)
        //                let indexPath = IndexPath(item: index, section: 0)
        //                notesTable.deleteRows(at: [indexPath], with: .fade)
        //                notesTable.reloadData()
        //            }
        //        }
    }

    private func noteCreationAnimation() {
        UIView.animateKeyframes(
            withDuration: 1.0,
            delay: 0.0,
            options: [.layoutSubviews],
            animations: {
                UIView.addKeyframe(
                    withRelativeStartTime: 0.0,
                    relativeDuration: 0.25,
                    animations: {
                        self.plusButton.center.y -= 50.0
                    }
                )
                UIView.addKeyframe(
                    withRelativeStartTime: 0.25,
                    relativeDuration: 0.75,
                    animations: {
                        self.plusButton.center.y += 300.0
                    }
                )
            },
            completion: { _ in
                self.createNewNote()
            }
        )
    }

    private func buttonForDeletionTransition() {
        UIView.animate(
            withDuration: 1.0,
            animations: {
                self.plusButton.backgroundColor = .red
                self.plusButton.transform = CGAffineTransform(rotationAngle: 40)
            },
            completion: nil
        )
    }

    private func buttonForAddTransition() {
        UIView.animate(
            withDuration: 1.0,
            animations: {
                self.plusButton.backgroundColor = Constants.plusButtonBlueColor
                self.plusButton.transform = .identity
            },
            completion: nil
        )
    }

    // MARK: - методы для сохранения и загрузки массива заметок
    @objc private func saveArrayOfNotes() {
        let notesData = try? JSONEncoder().encode(notes)
        UserDefaults.standard.set(notesData, forKey: Constants.savedNotesKey)
    }

    func loadArrrayOfNotes() {
        guard let notesData = UserDefaults.standard.data(forKey: Constants.savedNotesKey),
        let cache = try? JSONDecoder().decode([NoteModel].self, from: notesData) else { return }
        notes = cache
    }

    private func addSaveNotificationOnAppDismiss() {
        let saveNotification = NotificationCenter.default
        saveNotification.addObserver(
            self,
            selector: #selector(saveArrayOfNotes),
            name: UIScene.willDeactivateNotification,
            object: nil
        )
    }
    // MARK: - анимации
    func plusToTrashAnimation() {
        UIView.animate(
            withDuration: 5.0,
            animations: {
            self.plusButton.backgroundColor = .red
            },
                       completion: nil
        )
    }
}

// MARK: - экстеншн для функционала тэйблвью
extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notesTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NotePreviewCell
        cell?.setupCellData(with: notes[indexPath.row])
        cell?.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: notesTable.bounds.width)
        cell?.layoutMargins = UIEdgeInsets.zero
        cell?.contentView.layer.masksToBounds = true
        return cell ?? NotePreviewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = notes[indexPath.row]
        let noteVC = NoteViewController()
        noteVC.noteViewWithCellData(with: model)
        notes.remove(at: indexPath.row)
        noteVC.completion = { [weak self] model in
            DispatchQueue.main.async {
                self?.notes.insert(model, at: indexPath.row)
                self?.notesTable.reloadData()
            }
        }
        self.navigationController?.pushViewController(noteVC, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            notesTable.beginUpdates()
            notes.remove(at: indexPath.row)
            notesTable.deleteRows(at: [indexPath], with: .left)
            notesTable.endUpdates()
        }
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(
        _ tableView: UITableView,
        editingStyleForRowAt indexPath: IndexPath
    ) -> UITableViewCell.EditingStyle {
        return .none
    }
}
