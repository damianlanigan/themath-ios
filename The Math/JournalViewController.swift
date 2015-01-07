//
//  JournalViewController.swift
//  The Math
//
//  Created by Mike Kavouras on 12/22/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

class JournalViewController: UIViewController, CategoryViewDelegate {
    
    @IBOutlet weak var personalView: PersonalView!
    @IBOutlet weak var lifestyleView: LifestyleView!
    @IBOutlet weak var moneyView: MoneyView!
    @IBOutlet weak var healthView: HealthView!
    @IBOutlet weak var workView: WorkView!
    @IBOutlet weak var loveView: LoveView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        personalView.delegate = self
        lifestyleView.delegate = self
        moneyView.delegate = self
        healthView.delegate = self
        workView.delegate = self
        loveView.delegate = self
    }
    
    
    // MARK: <CategoryViewDelegate>
    
    func moodSelectedForCategory(mood: Mood, category: Category) {
        println(category.type.rawValue)
        println(mood.rawValue)
    }
}
