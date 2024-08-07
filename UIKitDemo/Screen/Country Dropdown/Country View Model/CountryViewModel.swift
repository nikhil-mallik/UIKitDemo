//
//  CountryViewModel.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 20/06/24.
//

import UIKit
import Combine
import Alamofire

class CountryViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var countries: [Country] = []
    @Published var filteredCountries: [Country] = []
    @Published var states: [Statess] = []
    @Published var filteredStates: [Statess] = []
    @Published var cities: [String] = []
    @Published var filteredCities: [String] = []
    var defaultStates = Statess(name: "No State Available", stateCode: "XXXXX")
    var defaultCities = City(name: "No City Available")
    // MARK: - Variable
    weak var vc: CountryViewController?       // Weak reference to the view controller
    var cancellables = Set<AnyCancellable>()  // Set to hold cancellable objects
    
    // MARK: - Fetch Countries
    func fetchCountries() {
        guard let url = URL(string: countryAPI) else { return }
        fetchData(with: url, expecting: CountriesResponse.self) { [weak self] (response) in
            self?.countries = response.data
            self?.filteredCountries = response.data
        }
    }
    
    // MARK: - Clear Cities
    func clearCities() {
        cities.removeAll()
        filteredCities.removeAll()
    }
    
    // MARK: - Fetch States
    func fetchStates(for country: String, button: UIButton? = nil) {
        guard let url = URL(string: stateAPI) else { return }
        let body = ["country": country]
        if let button = button { LoaderViewHelper.showLoader(on: button) }
        fetchData(with: url, method: .post, body: body, expecting: StatesResponse.self) { [weak self] (response) in
            self?.states = response.data.states
            self?.filteredStates = response.data.states
            self?.reloadTableView(for: .state)
            LoaderViewHelper.hideLoader()
            print("States fetched -> \(response.data.states.count)")
            if self?.states.count == 0 {
                self?.vc?.selectedStateNameLbl.text = "State not available"
                self?.vc?.selectedCityNameLbl.text = "City not available"
                self?.vc?.selectedState = self?.defaultStates
                self?.vc?.selectedCity = self?.defaultCities.name
            }
        }
    }
    
    // MARK: - Fetch Cities
    func fetchCities(for country: String, state: String, button: UIButton? = nil) {
        guard let url = URL(string: cityAPI) else { return }
        let body = ["country": country, "state": state]
        if let button = button { LoaderViewHelper.showLoader(on: button) }
        fetchData(with: url, method: .post, body: body, expecting: CitiesResponse.self) { [weak self] (response) in
            self?.cities = response.data
            self?.filteredCities = response.data
            self?.reloadTableView(for: .city)
            LoaderViewHelper.hideLoader()
            print("Cities fetched -> \(response.data.count)")
            if self?.cities.count == 0 {
                self?.vc?.selectedCityNameLbl.text = "City not available"
            }
        }
    }
    
    // MARK: - Country Search Methods
    func searchCountries(with query: String) {
        if query.count >= 2 {
            filteredCountries = countries.filter { $0.name.lowercased().contains(query.lowercased()) }
        } else {
            filteredCountries.removeAll()
            filteredCountries = countries
        }
    }
    
    
    // MARK: - States Search Methods
    func searchStates(with query: String) {
        if query.count >= 2 {
            filteredStates = states.filter { $0.name.lowercased().contains(query.lowercased()) }
        } else {
            filteredStates.removeAll()
            filteredStates = states
        }
    }
    
    // MARK: - Cities Search Methods
    func searchCities(with query: String) {
        if query.count >= 2 {
            filteredCities = cities.filter { $0.lowercased().contains(query.lowercased()) }
        } else {
            filteredCities.removeAll()
            filteredCities = cities
        }
    }
    
    func resetArrayData(for type: CountryViewController.DropdownType) {
        switch type {
        case .country:
            searchStates(with: "")
            searchCities(with: "")
        case .state:
            searchCountries(with: "")
            searchCities(with: "")
        case .city:
            searchCountries(with: "")
            searchStates(with: "")
        }
    }
    
    // MARK: - Private Helper Methods
    private func fetchData<T: Decodable>(with url: URL, method: HTTPMethod = .get, body: [String: Any]? = nil, expecting: T.Type, completion: @escaping (T) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    AlertHelper.showAlert(withTitle: "Alert", message: "Error fetching data: \(error)", from: self.vc!)
                    print("Error fetching data: \(error)")
                }
            }, receiveValue: { response in
                completion(response)
            })
            .store(in: &cancellables)
    }
    
    private func reloadTableView(for type: CountryViewController.DropdownType) {
        DispatchQueue.main.async {
            self.vc?.reloadTableView(for: type)
            self.resetArrayData(for: type)
            self.vc?.clearAllSearchBars()
            self.vc?.checkButtonEnableDisable()
        }
    }
}
