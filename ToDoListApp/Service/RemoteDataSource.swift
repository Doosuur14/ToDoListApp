//
//  RemoteDataSource.swift
//  ToDoListApp
//
//  Created by Faki Doosuur Doris on 21.08.2025.
//

import Foundation

protocol RemoteDataSourceProtocol {
    func fetchContent(completion: @escaping (Result<[RemoteTodo], Error>) -> Void)

}

final class RemoteDataSource: RemoteDataSourceProtocol {
    static let shared = RemoteDataSource()

    func fetchContent(completion: @escaping (Result<[RemoteTodo], any Error>) -> Void) {
        guard let url =  URL(string: "https://dummyjson.com/todos") else { return  }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(RemoteTodoResponse.self, from: data)
                completion(.success(decoded.todos))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
