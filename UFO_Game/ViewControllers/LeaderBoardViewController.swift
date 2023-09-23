//
//  LeaderBoardViewController.swift
//  UFO_Game
//
//  Created by Egor Kruglov on 20.09.2023.
//

import UIKit

class LeaderBoardViewController: UIViewController {

    private lazy var tableView = {
        let table = UITableView()
        table.layer.cornerRadius = cornerRadiusM
        table.alwaysBounceVertical = false
        table.allowsSelection = false
        table.separatorStyle = .none
        
        return table
    }()
    private lazy var leaderLabel = {
        let label = UILabel()
        label.text = "LEADERBOARD"
        label.font = UIFont.systemFont(ofSize: heightXS, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        
        return label
    }()
    private lazy var closeButton = getButton(selector: #selector(closeLeaderBoard), title: "CLOSE")
    private lazy var rowHeight = {
        tableView.frame.height / 10
    }()
    
    private let dataStore = DataStore.shared
    private var leadersData: [GameResults]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setupUI()
        loadLeadersData()
    }
    
    deinit {
        print("LeaderboardVC was released")
    }
}

private extension LeaderBoardViewController {
    func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(leaderLabel)
        leaderLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(insetFromScreenEdges)
            make.horizontalEdges.equalToSuperview().inset(insetFromScreenEdges)
            make.height.equalTo(heightS)
        }
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(insetFromScreenEdges)
            make.horizontalEdges.equalToSuperview().inset(insetFromScreenEdges)
            make.height.equalTo(heightM)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(leaderLabel.snp.bottom).offset(generalInset)
            make.horizontalEdges.equalToSuperview().inset(insetFromScreenEdges)
            make.bottom.equalTo(closeButton.snp.top).inset(-generalInset)
        }
    }
    
    @objc func closeLeaderBoard() {
        dismiss(animated: true)
    }
    
    func loadLeadersData() {
        leadersData = dataStore.loadGameResults()
        tableView.reloadData()
    }
}

extension LeaderBoardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        leadersData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let gameResults = leadersData[indexPath.row]
        var config = cell.defaultContentConfiguration()
        config.text = "\(indexPath.row + 1). \(gameResults.playerName) - \(gameResults.score)"
        config.textProperties.font = UIFont.systemFont(ofSize: heightXS, weight: .bold)
        cell.contentConfiguration = config
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        rowHeight
    }
}

extension LeaderBoardViewController: UITableViewDelegate {
    
}
