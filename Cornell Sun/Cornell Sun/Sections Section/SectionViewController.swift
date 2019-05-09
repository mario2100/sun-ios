//
//  SectionViewController.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 2/12/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import UIKit
import Crashlytics

struct SectionMeta {
    let title: String
    let imageName: String
}

enum Sections {
    case news(id: Int)
    case opinion(id: Int)
    case sports(id: Int)
    case arts(id: Int)
    case science(id: Int)
    case dining(id: Int)
    case multimedia(id: Int)
    //case sunspots
}

class SectionViewController: UIViewController {
    var tableView: UITableView!
    var sections: [Sections] = [.news(id: 2), .opinion(id: 3), .sports(id: 4), .arts(id: 5), .science(id: 6), .dining(id: 7), .multimedia(id: 9)]
    
//    var darkModeEnabled = UserDefaults.standard.bool(forKey: "darkModeEnabled")
    var darkModeEnabled = true
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Sections"
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.headerTitle
        ]
        
        updateColors()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView()
        tableView.register(SectionTableViewCell.self, forCellReuseIdentifier: "sectionCell")
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateColors), name: .darkModeToggle, object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func updateColors() {
        
        if(darkModeEnabled) {
            navigationController?.navigationBar.barTintColor = .darkTint
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkText]
            navigationController?.navigationBar.barStyle = .blackTranslucent
            tableView.backgroundColor = .darkCell
            
        } else {
            navigationController?.navigationBar.barTintColor = .white
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightText]
            navigationController?.navigationBar.barStyle = .default
            tableView.backgroundColor = .white
        }
        
        tableView.reloadData()
    }

    func sectionToMeta(section: Sections) -> SectionMeta {
        var title: String = ""
        var imageName: String = ""
        switch section {
        case .news:
            title = "News"
            imageName = "news-section"
        case .opinion:
            title = "Opinion"
            imageName = "opinion"
        case .sports:
            title = "Sports"
            imageName = "sports"
        case .arts:
            title = "Arts & Entertainment"
            imageName = "arts"
        case .science:
            title = "Science"
            imageName = "science"
        case .dining:
            title = "Dining"
            imageName = "dining"
        case .multimedia:
            title = "Multimedia"
            imageName = "multimedia"
        //case .sunspots:
            //return "Sunspots"
        }
        
        return SectionMeta(title: title, imageName: imageName)
    }
}

extension SectionViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "sectionCell") as? SectionTableViewCell else {
            return UITableViewCell()
        }
        let sectionMeta = sectionToMeta(section: sections[indexPath.row])
        cell.titleLabel.text = sectionMeta.title
        cell.sectionImageView.image = UIImage(named: sectionMeta.imageName)
        
        if(darkModeEnabled) {
            cell.backgroundColor = .darkCell
            cell.titleLabel.textColor = .darkText
            cell.detailImageView.image = UIImage(named: "disclosureArrowDark")
            cell.sectionImageView.image = UIImage(named: sectionMeta.imageName + "Dark")
        } else {
            cell.backgroundColor = .white
            cell.titleLabel.textColor = .black
            cell.detailImageView.image = UIImage(named: "disclosureArrowLight")
            cell.sectionImageView.image = UIImage(named: sectionMeta.imageName + "Light")
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = sections[indexPath.row]
        let sectionMeta = sectionToMeta(section: section)
        let sectionVC = SectionCollectionViewController(with: section, sectionTitle: sectionMeta.title)
        navigationController?.pushViewController(sectionVC, animated: true)
        Answers.logCustomEvent(withName: "Section Selected", customAttributes: ["Section": "\(section)"])
    }
}
