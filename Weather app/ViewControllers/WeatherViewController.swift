import UIKit

class WeatherViewController: UIViewController {
    
    private let weatherService = WeatherService()

    private var weatherModel: WeatherModel? {
        didSet { updateUI() }
    }
    
    //MARK: - UI Components
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 48, weight: .medium)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "WeatherApp"
        searchBar.delegate = self
        setupSearchHistoryButton()
        setupViews()
        fetchData()
    }
    
    //MARK: - Private methods
    
    private func setupSearchHistoryButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: .init(systemName: "note.text"),
            style: .plain,
            target: self ,
            action: #selector(didTapRecentSearches)
        )
    }
    
    @objc private func didTapRecentSearches() {
        navigationController?.pushViewController(RecentSearchesViewController(), animated: true)
    }
    
    private func fetchData(forCity city: String = "Kyiv") {
        weatherService.getWeather(forCity: city) { result in
            switch result {
            case .success(let weatherModel):
                self.weatherModel = weatherModel
                self.updateUI()
            case .failure(let error):
                DispatchQueue.main.async {
                    self.cityLabel.text = "Ooops something wrong"
                    self.descriptionLabel.text = ""
                    self.temperatureLabel.text = ""
                }
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateUI() {
        guard let model = weatherModel else { return }
        
        DispatchQueue.main.async {
            self.cityLabel.text = model.name
            self.temperatureLabel.text = String(model.main.temperature) + "°C"
            self.descriptionLabel.text = model.weather[0].main
        }
    }
    
    private func setupViews() {
        view.addSubview(searchBar)
        view.addSubview(cityLabel)
        view.addSubview(temperatureLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            cityLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            cityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cityLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            temperatureLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 8),
            temperatureLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            descriptionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            iconImageView.widthAnchor.constraint(equalToConstant: 100),
            iconImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}

    //MARK: - SearchBar delegate methods

extension WeatherViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let city = searchBar.text else { return }
        
        searchBar.text = ""
        fetchData(forCity: city)
        searchBar.resignFirstResponder()
    }
    
    func searchBarShouldReturn(_ searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
}
