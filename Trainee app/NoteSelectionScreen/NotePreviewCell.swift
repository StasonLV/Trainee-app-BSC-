//
//  NotePreviewCell.swift
//  Trainee app
//
//  Created by Stanislav Lezovsky on 17.04.2022.
//

import UIKit

final class NotePreviewCell: UITableViewCell {

    var selectionState: Bool = false

    // MARK: - константы
    private enum Constants {
        static let noteNameFont: UIFont = .systemFont(ofSize: 16, weight: .bold)
        static let noteTextFont: UIFont = .systemFont(ofSize: 10, weight: .light)
        static let noteDateFont: UIFont = .systemFont(ofSize: 10, weight: .regular)
        static let backColor = CGColor(
            red: 0.898,
            green: 0.898,
            blue: 0.898,
            alpha: 1
        )
        static let buttonSymbolConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .heavy, scale: .default)
        static let cellEditSymbol = UIImage(
            systemName: "checkmark.circle",
            withConfiguration: buttonSymbolConfig
        )
        static let cellChooseSymbol = UIImage(
            systemName: "checkmark.circle.fill",
            withConfiguration: buttonSymbolConfig
        )
    }

    // MARK: - модель
    var note: NoteModel? {
        didSet {
            noteNameField.text = note?.title
            noteTextLabel.text = note?.noteText
            noteDateLabel.text = note?.date
        }
    }

    // MARK: - создание эл-тов ячеек
    lazy var checkButton: UIButton = {
        let btn = UIButton()
        btn.setImage(Constants.cellEditSymbol, for: .normal)
        btn.setImage(Constants.cellChooseSymbol, for: .selected)
        btn.alpha = 0.0
        btn.addTarget(self, action: #selector(cellSelected), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let noteNameField: UITextField = {
        let label = UITextField()
        label.font = Constants.noteNameFont
        label.placeholder = "Без названия"
        label.textColor = .black
        label.contentMode = .scaleAspectFit
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let noteTextLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.noteTextFont
        label.textColor = .placeholderText
        label.contentMode = .scaleAspectFit
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let noteDateLabel: UITextField = {
        let label = UITextField()
        label.font = Constants.noteDateFont
        label.textColor = .black
        label.isUserInteractionEnabled = false
        label.text = Date().toString(format: "dd.MM.yyyy")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - инициализаторы
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - настройка ячейки
    func setupCell() {
        backgroundColor = .clear
        contentView.backgroundColor = .white
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = Constants.backColor
        contentView.addSubview(noteNameField)
        contentView.addSubview(noteTextLabel)
        contentView.addSubview(noteDateLabel)
        contentView.addSubview(checkButton)

        NSLayoutConstraint.activate([
            checkButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            noteNameField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            noteNameField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            noteTextLabel.topAnchor.constraint(equalTo: noteNameField.bottomAnchor, constant: 4),
            noteTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            noteDateLabel.topAnchor.constraint(equalTo: noteTextLabel.bottomAnchor, constant: 24),
            noteDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    }

    @objc func cellSelected(sender: UIButton) {
        print("checkbox pressed")
        selectionState.toggle()
        print(selectionState)
    }

    // MARK: - настройка данных ячейки
    func setupCellData(with model: NoteModel) {
        self.note = model
        noteNameField.text = model.title
        noteTextLabel.text = model.noteText
        noteDateLabel.text = model.date
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        switch editing {
        case true:
            checkButtonAppearAnimation()
            contentAnimationForStartEditing()
        case false:
            checkButton.alpha = 0.0
            contentAnimationForEndEditing()
        }
    }

    func contentAnimationForStartEditing() {
        UIView.animate(
            withDuration: 0.75,
            delay: 0.0,
            animations: {
                self.noteNameField.center.x += 30.0
                self.noteTextLabel.center.x += 30.0
                self.noteDateLabel.center.x += 30.0
            }
        )
    }

    func contentAnimationForEndEditing() {
        UIView.animate(
            withDuration: 0.75,
            delay: 0.0,
            animations: {
                self.noteNameField.center.x -= 30.0
                self.noteTextLabel.center.x -= 30.0
                self.noteDateLabel.center.x -= 30.0
            }
        )
    }

    func checkButtonAppearAnimation() {
        UIView.animate(
            withDuration: 0.75,
            delay: 0.0,
            animations: {
                self.checkButton.alpha = 1.0
            }
        )
    }
}
