//
//  NetworkManager.swift
//  ToDo
//
//  Created by Vlad on 3.09.24.
//

import Foundation

protocol NetworkManagerProtocol: AnyObject {
    func fetchTasks(completion: @escaping (Result<[ToDo], Error>) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {
    private let url = URL(string: "https://dummyjson.com/todos")
    
    func fetchTasks(completion: @escaping (Result<[ToDo], Error>) -> Void) {
        guard let url = url else {
            let error = NSError(domain: "Invalid URL", code: 0)
            completion(.failure(error))
            return
        }
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                let error = NSError(domain: "Request failed", code: 0)
                completion(.failure(error))
                return
            }
            guard let data = data else {
                let error = NSError(domain: "Failed to retrieve data", code: 0)
                completion(.failure(error))
                return
            }
            do {
                let todoResponse = try JSONDecoder().decode(TodoResponse.self, from: data)
                var todos: [ToDo] = []
                let dispatchGroup = DispatchGroup()
                for item in todoResponse.todos {
                    dispatchGroup.enter()
                    let todo = ToDo(id: String(item.id), title: item.todo, description: "", completed: item.completed, date: Date())
                    todos.append(todo)
                    dispatchGroup.leave()
                }
                dispatchGroup.notify(queue: .main) {
                    completion(.success(todos))
                }
            } catch {
                let error = NSError(domain: "Failed to decode data", code: 0)
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
