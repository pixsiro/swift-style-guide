//
//  EpisodeDetailViewController.swift
//  GotEpisodes
//
//  Created by Fabio Butti on 18/07/17.
//  Copyright © 2017 tiknil. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import AlamofireImage

class EpisodeDetailViewController: TkMvvmViewController<EpisodeDetailViewModel> {

  // MARK: - Properties
  // MARK: Class
  
  
  // MARK: Public
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var titleLbl: UILabel!
  @IBOutlet weak var seasonLbl: UILabel!
  @IBOutlet weak var episodeLbl: UILabel!
  @IBOutlet weak var airDateLbl: UILabel!
  @IBOutlet weak var summaryLbl: UILabel!
  
  
  // MARK: Private
  
  
  // MARK: - Methods
  // MARK: Class
  
  
  // MARK: Lifecycle
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let vm = viewModel {
      title = "S\(vm.seasonText.value)E\(vm.numberText.value)"
    }
  }
  
  override func setupBindings() {
    super.setupBindings()
    
    // Lo eseguo solo se viewmodel e outlets sono istanziati
    if let vm = viewModel,
      let _ = titleLbl {
      // Binding sul viewmodel
      vm.imageUrl.producer.observe(on: UIScheduler()).startWithValues { imageUrl in
        guard let url = imageUrl else { return }
        self.imageView.af_setImage(withURL: url)
      }
      titleLbl.reactive.text <~ vm.titleText
      seasonLbl.reactive.text <~ vm.seasonText
      episodeLbl.reactive.text <~ vm.numberText
      airDateLbl.reactive.text <~ vm.airDateText
      summaryLbl.reactive.text <~ vm.summaryText
    }
  }
  
  
  // MARK: Custom accessors
  
  
  // MARK: IBActions
  
  
  // MARK: Public
  
  
  // MARK: Private
  

}
