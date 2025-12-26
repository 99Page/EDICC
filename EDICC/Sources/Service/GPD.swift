//
//  File.swift
//  EDICC
//
//  Created by 노우영 on 12/18/25.
//

import Foundation

enum HttpMethod: String {
    case get = "GET", post = "POST", put = "PUT", delete = "DELETE"
}

enum GPDError: Error {
    case invalidURL, serverError(statusCode: Int)
    case decodingError(Error)
    case unknown(Error)
}

final class GPD {
    static let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        return URLSession(configuration: config)
    }()
    
    private init() {}
    
    static func build(_ url: String) -> GPDRequest {
        return GPDRequest(session: session, url: url)
    }
}

final class GPDRequest {
    fileprivate let session: URLSession
    fileprivate let urlString: String
    
    fileprivate var httpMethod: HttpMethod = .get
    fileprivate var params: [String: Any]? = nil
    fileprivate var headerFields: [String: String]? = nil
    fileprivate var needsValidation: Bool = false
    
    init(session: URLSession, url: String) {
        self.session = session
        self.urlString = url
    }
    
    // MARK: - Settings (체이닝)
    
    func method(_ method: HttpMethod) -> Self {
        self.httpMethod = method
        return self
    }
    
    func parameters(_ params: [String: Any]) -> Self {
        self.params = params
        return self
    }
    
    func parameters<E: Encodable>(_ object: E) -> Self {
        do {
            let data = try JSONEncoder().encode(object)
            let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            self.params = dict
        } catch {
            print("Parameter Encoding Failed: \(error)")
        }
        return self
    }
    
    func headers(_ headers: [String: String]) -> Self {
        self.headerFields = headers
        return self
    }
    
    func validate() -> Self {
        self.needsValidation = true
        return self
    }
    
    func decoding<T: Decodable>(_ type: T.Type) -> GPDExpecting<T> {
        return GPDExpecting(request: self)
    }
    
    func execute() async throws -> Data {
        return try await performRequest()
    }
    
    func execute() async throws {
        _ = try await performRequest()
    }
    
    func debug() -> Self {
            var log = "\n🚀 [GPDRequest Debugging] --------------------\n"
            
            // 1. URL 정보
            if let finalURL = makeURL() {
                log += "🌐 URL: \(finalURL.absoluteString)\n"
            } else {
                log += "🌐 URL: ❌ Invalid URL (생성 실패)\n"
            }
            
            // 2. Method 정보
            log += "💼 Method: \(httpMethod.rawValue)\n"
            
            // 3. Header 정보
            if let headers = headerFields, !headers.isEmpty {
                log += "🧢 Headers:\n"
                headers.forEach { key, value in
                    log += "   - \(key): \(value)\n"
                }
            } else {
                log += "🧢 Headers: None\n"
            }
            
            // 4. Body / Parameters 정보
            if let params = params, !params.isEmpty {
                log += "📦 Body / Parameters:\n"
                
                if httpMethod != .get {
                    // JSON Pretty Print 시도
                    if let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [.prettyPrinted, .sortedKeys]),
                       let jsonString = String(data: jsonData, encoding: .utf8) {
                        log += jsonString + "\n"
                    } else {
                        log += "   \(params)\n"
                    }
                } else {
                    log += "   (Query Params): \(params)\n"
                }
            } else {
                log += "📦 Body: None\n"
            }
            
            log += "--------------------------------------------\n"
            
            // ⭐️ 요청하신 대로 딱 한 번만 출력합니다.
            print(log)
            
            return self
        }
    
    fileprivate func performRequest() async throws -> Data {
        guard let url = makeURL() else { throw GPDError.invalidURL }
        let request = makeURLRequest(url: url)
        
        let (data, response) = try await session.data(for: request)
        
        if needsValidation, let httpRes = response as? HTTPURLResponse {
            guard (200...299).contains(httpRes.statusCode) else {
                throw GPDError.serverError(statusCode: httpRes.statusCode)
            }
        }
        
        return data
    }
    
    private func makeURLRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        headerFields?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        if let params = params, httpMethod != .get {
            request.httpBody = try? JSONSerialization.data(withJSONObject: params)
            if request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }
        
        return request
    }
    
    private func makeURL() -> URL? {
        guard var components = URLComponents(string: urlString) else { return nil }
        components.setQueryItems(with: params, method: httpMethod)
        return components.url
    }
}

struct GPDExpecting<T: Decodable> {
    
    private let request: GPDRequest
    private var decoder: JSONDecoder = JSONDecoder()
    
    init(request: GPDRequest) {
        self.request = request
    }
    
    func decoder(_ decoder: JSONDecoder) -> Self {
        var copy = self
        copy.decoder = decoder
        return copy
    }
    
    func request() async throws -> T {
        let data = try await request.performRequest()
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch let error as DecodingError {
            throw GPDError.decodingError(error)
        } catch {
            throw GPDError.decodingError(error)
        }
    }
}

private extension URLComponents {
    mutating func setQueryItems(with params: [String: Any]?, method: HttpMethod) {
        guard method == .get, let params = params else { return }
        
        queryItems = params.map { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }
    }
}
