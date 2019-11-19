//
//  SearchViewController.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/29/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import UIKit
import MediaPlayer

final class SearchViewController: UIViewController {
    // MARK: - Properties
    private var toDisplay: [MPMediaItem]? = MPMediaQuery.songs().items
    private var tempItems: [MPMediaItem] = []
    private var selected: [Bool]?
    weak var delegate: SearchControllerDelegate?
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var searchField: UITextField!
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchField.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let items = toDisplay {
            selected = Array(repeating: false, count: items.count)
        }
    }
    // MARK: - Actions
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func clearTapped(_ sender: Any) {
        toDisplay = MPMediaQuery.songs().items
        tableView.reloadData()
    }
    @IBAction func doneTapped(_ sender: Any) {
        var result = [MPMediaItem]()
        guard let temp = toDisplay, let slctd = selected else { return }
        for (index, value) in temp.enumerated() where slctd[index] {
            result.append(value)
        }
        delegate?.getCodableItems(form: result)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func textChanged() {
        toDisplay = MPMediaQuery.songs().items
        guard let entered = searchField.text else { return }
        guard let temp = MPMediaQuery.songs().items else { return }
        tempItems = temp
        toDisplay = toDisplay?.filter {
            if let title = $0.title, let artist = $0.artist {
                return title.contains(entered) || artist.contains(entered)
            }
            return false
        }
        tableView.reloadData()
    }
}

extension SearchViewController: UITableViewDataSource {
    // MARK: - TableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let items = toDisplay else { return UITableViewCell() }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "QueueCell", for: indexPath) as? QueueCell {
            cell.item = items[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDisplay?.count ?? 0
    }
}

extension SearchViewController: UITableViewDelegate {
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected?[indexPath.row] = true
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selected?[indexPath.row] = false
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchViewController: UITextFieldDelegate {
    // MARK: - TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
