import UIKit
import CoreData

protocol RecentSearchVCDelegate: AnyObject {
    func didSelectCell(withQuery query: String)
}

final class RecentSearchesViewController: UIViewController {
    private var recentSearches: [String] = ["Moscow", "Riga"] {
        didSet {
            tableView.reloadData()
        }
    }
    weak var delegate: RecentSearchVCDelegate?
    private let cellIdentifier = "MyCell"
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: view.bounds, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        return table
    }()
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        fetchRecentSearches()
    }
    // MARK: - Private Methods
    private func fetchRecentSearches() {
        recentSearches = RecentSearchService.shared.getRecentSearches()
    }
}

    // MARK: - TableView Delegate , TableViewDataSource

extension RecentSearchesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recentSearches.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = recentSearches[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.popViewController(animated: true)
        delegate?.didSelectCell(withQuery: recentSearches[indexPath.row])
    }
}
