//
//  RepoDetailsViewController.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 01. 11..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import UIKit

final class RepoDetailsViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    
    
    private static let fadeTransitionDuration: CFTimeInterval = 0.4
    
    var viewModel: RepoDetailsViewModel!
    
    private var contriTableViewController: ContriTableViewController?
    
    static func create(with viewModel: RepoDetailsViewModel) -> RepoDetailsViewController {
        let view = RepoDetailsViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        bind(to: viewModel)
        view.accessibilityIdentifier = AccessibilityIdentifier.repoDetailsView
        
    }
    
    private func bind(to viewModel:RepoDetailsViewModel) {
        viewModel.name.observe(on: self) { [weak self] in self?.title = $0 }
        viewModel.fullName.observe(on: self) { [weak self] in self?.fullNameLabel.text = $0 }
        viewModel.size.observe(on: self) { [weak self] in self?.sizeLabel.text = NSLocalizedString("Size \n\($0)", comment: "") }
        viewModel.stars.observe(on: self) { [weak self] in self?.starsLabel.text = "☆ \n\($0)" }
        viewModel.forks.observe(on: self) { [weak self] in self?.forksLabel.text = NSLocalizedString("Forks \n\($0)", comment: "") }
        viewModel.items.observe(on: self) { [weak self] in self?.contriTableViewController?.items = $0 }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: ContriTableViewController.self),
            let destinationVC = segue.destination as? ContriTableViewController {
            contriTableViewController = destinationVC
            contriTableViewController?.viewModel = viewModel
        }
    }
    
    private func setupBackButton() {
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    
}
