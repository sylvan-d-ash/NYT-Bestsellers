//
//  APIService.swift
//  NYT Bestsellers
//
//  Created by Sylvan Ash on 12/12/2024.
//

import Foundation
import Combine

protocol APIEndpoint {
    var path: String { get }
    var parameters: [String: Any]? { get }
}

enum APIError: Error {
    case invalidResponse
    case invalidData
}

protocol APIClient {
    func request<T: Decodable>(_ endpoint: APIEndpoint) -> AnyPublisher<T, Error>
    func request<T: Decodable>(_ endpoint: APIEndpoint) async -> Result<T, Error>
}

final class URLSessionAPIClient: APIClient {
    private let baseUrl = "https://api.nytimes.com/svc/books/v3"

    static var apiKey: String {
        guard let key = ProcessInfo.processInfo.environment["NYT_API_KEY"] else {
            fatalError("Missing API Key!")
        }
        return key
    }

    func request<T: Decodable>(_ endpoint: APIEndpoint) -> AnyPublisher<T, Error> {
        guard var url = URL(string: baseUrl) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        url = url.appending(path: endpoint.path)

        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        components.queryItems = getQueryItems(for: endpoint.parameters)

        guard let url = components.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { data, response in
                guard let resp = response as? HTTPURLResponse, (200...299).contains(resp.statusCode) else {
                    throw APIError.invalidResponse
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func request<T>(_ endpoint: APIEndpoint) async -> Result<T, Error> where T : Decodable {
        guard var url = URL(string: baseUrl) else {
            return .failure(URLError(.badURL))
        }
        url = url.appending(path: endpoint.path)

        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return .failure(URLError(.badURL))
        }
        components.queryItems = getQueryItems(for: endpoint.parameters)

        guard let url = components.url else {
            return .failure(URLError(.badURL))
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(T.self, from: data)
            return .success(response)
        } catch _ as DecodingError {
            return .failure(APIError.invalidData)
        } catch {
            return .failure(APIError.invalidResponse)
        }
    }

    private func getQueryItems(for parameters: [String: Any]?) -> [URLQueryItem]? {
        var parameters = parameters ?? [:]
        parameters["api-key"] = Self.apiKey

        return parameters.map { key, value in
            var stringValue: String?

            switch value {
            case let string as String:
                stringValue = string
            case let number as NSNumber:
                stringValue = number.stringValue
            case let array as [Any]:
                // Convert array to comma-separated string
                stringValue = array.map { "\($0)" }.joined(separator: ",")
            case let bool as Bool:
                stringValue = bool ? "true" : "false"
            default:
                // Skip unsupported types
                break
            }

            return URLQueryItem(name: key, value: stringValue)
        }
    }
}

protocol CategoriesListService {
    func fetchCategories() -> AnyPublisher<CategoriesResponse, Error>
    func fetchBooks(for category: String) -> AnyPublisher<BooksResponse, Error>
}

final class APIService: CategoriesListService {
    private let baseUrl = "https://api.nytimes.com/svc/books/v3"

    static var apiKey: String {
        guard let key = Bundle.main.infoDictionary?["API_KEY"] as? String else {
            fatalError("Missing API Key!")
        }
        return key
    }

    func fetchCategories() -> AnyPublisher<CategoriesResponse, Error> {
        guard let url = URL(string: baseUrl + "/lists/names.json" + "?api-key=\(Self.apiKey)") else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: CategoriesResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func fetchBooks(for category: String) -> AnyPublisher<BooksResponse, Error> {
        guard let url = URL(string: baseUrl + "lists/current/" + category + "?api-key=\(Self.apiKey)") else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: BooksResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
