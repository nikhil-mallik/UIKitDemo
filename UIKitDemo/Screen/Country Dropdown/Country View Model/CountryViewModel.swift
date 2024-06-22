//
//  CountryViewModel.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 20/06/24.
//

import Foundation
import Combine
import Alamofire

class CountryViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var countries: [Country] = []
    @Published var states: [Statess] = []
    @Published var cities: [String] = []
    
    // MARK: - Variable
    weak var vc: CountryViewController?       // Weak reference to the view controller
    var cancellables = Set<AnyCancellable>()  // Set to hold cancellable objects
    
    // MARK: - Fetch Countries
    func fetchCountries() {
        guard let url = URL(string: countryAPI) else { return }
        fetchData(with: url, expecting: CountriesResponse.self) { [weak self] (response) in
            self?.countries = response.data
            print("Countries fetched -> \(response.data.count)")
        }
    }
    
    // MARK: - Fetch States
    func fetchStates(for country: String) {
        guard let url = URL(string: stateAPI) else { return }
        let body = ["country": country]
        fetchData(with: url, method: .post, body: body, expecting: StatesResponse.self) { [weak self] (response) in
            self?.states = response.data.states
            self?.reloadTableView(for: .state)
            print("States fetched -> \(response.data.states.count)")
        }
    }
    
    // MARK: - Fetch Cities
    func fetchCities(for country: String, state: String) {
        guard let url = URL(string: cityAPI) else { return }
        let body = ["country": country, "state": state]
        fetchData(with: url, method: .post, body: body, expecting: CitiesResponse.self) { [weak self] (response) in
            self?.cities = response.data
            self?.reloadTableView(for: .city)
            print("Cities fetched -> \(response.data.count)")
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
            self.vc?.checkButtonEnableDisable()
        }
    }
}
