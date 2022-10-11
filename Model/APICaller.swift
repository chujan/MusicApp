//
//  APICaller.swift
//  MusicApp
//
//  Created by Jennifer Chukwuemeka on 30/09/2022.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    private init() {}
    
    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    
    public func getAlbumDetails(for album: Album, completion: @escaping (Result<AlbumDetailsResponse, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/albums/" + album.id), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data,  _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(AlbumDetailsResponse.self, from: data)
                   // print(result)
                    completion(.success(result))
                }
                catch {
                    print(error)
                    completion(.failure(error))
                }

            }
            task.resume()
        }
    }
    
    public func getCurrentUserAlbums(completion: @escaping (Result<[Album], Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/me/albums"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data,  _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    
                    let result = try JSONDecoder().decode(LibraryAlbumsResponse.self, from: data)
                    print(result)
                    completion(.success(result.items.compactMap({ $0.album 
                    })))
                }
                catch {
                    print(error)
                    completion(.failure(error))
                }

            }
            task.resume()
        }
    }
    
    public func saveAlbum(album: Album, completion: @escaping (Bool) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/me/albums?ids=\(album.id)"), type: .PUT) { baseRequest in
            
            var request = baseRequest
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { data,  response, error in
                
               
                    guard let code = (response as? HTTPURLResponse)?.statusCode,
                      error == nil else {
                    completion(false)
                    return
                }
                print(code)
                completion(code == 200)

            }
            task.resume()
            
        }
    }
    
    public func getPlaylistDetails(for playlist: Playlist, completion: @escaping (Result<PlayListDetailResponse, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/playlists/" + playlist.id), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data,  _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    
                    let result = try JSONDecoder().decode(PlayListDetailResponse.self, from: data)
                    print(result)
                    completion(.success(result))
                }
                catch {
                    print(error)
                    completion(.failure(error))
                }

            }
            task.resume()
        }
    }
    
    public func getCurrentUserPlaylists(completion: @escaping ((Result<[Playlist], Error>) -> Void)) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/me/playlists?limits=20"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(LibraryPlaylistsResponse.self, from: data)
                    completion(.success(result.items))
                    print(result)
                }
                catch {
                    print(error)
                    completion(.failure(error))
                }

            }
            task.resume()
        }
        
    }
    
    public func ctratePlaylists(with name: String, completion: @escaping (Bool) -> Void) {
        getCurrentUserProfile {[weak self] result in
            switch result {
            case.success(let profile):
                let urlString = Constants.baseAPIURL + "/users/\(profile.id)/playlists"
                print(urlString)
                self?.createRequest(with: URL(string: urlString), type: .POST)  { baseRequest in
                    var request = baseRequest
                    let json = [
                        "name": name
                    ]
                    request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
                    let task = URLSession.shared.dataTask(with: request) { data, _, error in
                        guard let data = data, error == nil else {
                            completion(false)
                            return
                        }
                        do {
                            let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                            if let response = result as? [String: Any], response["id"] as? String != nil {
                                print("created")
                                completion(true)
                                
                            }
                            else {
                            completion(false)
                          //  print(result)
                            }
                        }
                        catch {
                            print(error.localizedDescription)
                            completion(false)
                        }

                    }
                    task.resume()
                                    
                }
            case.failure(let error):
                print(error.localizedDescription)
                
            }
        }
        
    }
    public func addTrackPlaylists(track: AudioTrack, playlist: Playlist, completion: @escaping (Bool) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/playlists/\(playlist.id)/tracks"), type: .POST) { baseRequest in
            var request = baseRequest
            let json = [
                "uris": [
                    "spotify:track:\(track.id)"
                    ]
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data , error == nil else {
                    completion(false)
                    return
                }
                do {
                    let result = try  JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(result)
                    if let response = result as? [String: Any], response["snapshot_id"] as? String != nil {
                        completion(true)
                    }
                    else {
                       
                        completion(false)
                    }
                    
                }
                catch {
                    completion(false)
                    
                }
                

            }
            task.resume()
            
            
        }
        
        
    }
    public func removeTrackFromPlaylists(track: AudioTrack, playlist: Playlist, completion: @escaping (Bool) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/playlists/\(playlist.id)/tracks"), type: .DELETE) { baseRequest in
            var request = baseRequest
            let json: [String: Any] = [
                "tracks": [
                    [
                        "uri": "spotify:track:\(track.id)"
                    ]
                    ]
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data , error == nil else {
                    completion(false)
                    return
                }
                do {
                    let result = try  JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(result)
                    if let response = result as? [String: Any], response["snapshot_id"] as? String != nil {
                        completion(true)
                    }
                    else {
                       
                        completion(false)
                    }
                    
                }
                catch {
                    completion(false)
                    
                }
                

            }
            task.resume()
    }
    }
    
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/me"), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    //print(result)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }

            }
            task.resume()
        }
        
    }
    
    public func getNewReleases(completion: @escaping ((Result<NewReleasesResponse, Error>)) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/new-releases?limit=40"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                  //  print(result)
                    completion(.success(result))
//                    let json =  try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                  //  print(json)
                    
                    
                }
                catch {
                    completion(.failure(error))
                }

            }
            task.resume()
        }
    }
     
    public func getFeaturedPlayLists(completion: @escaping((Result<FeaturedPlaylistsResponse, Error>) -> Void)) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/featured-playlists?limit=20"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: data)
                   // print(result)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }

            }
            task.resume()
        }
    }
    
    public func getRecommendations( generes: Set<String>, completion: @escaping ((Result<RecommendationsResponse, Error>) -> Void)) {
        let seeds = generes.joined(separator: ",")
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations?limit=20&seed_genres=\(seeds)"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                  // print(result)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }

            }
            task.resume()

        }
    }
    
    public func getRecommendedGenres(completion: @escaping ((Result<RecommendedGenresResponse, Error>) -> Void)) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations/available-genre-seeds"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                            guard let data = data, error == nil else {
                                completion(.failure(APIError.failedToGetData))
                                return
                            }
                            do {
                                let result = try   JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
                               // print(result)
                              
                                completion(.success(result))
                            }
                            catch {
                                completion(.failure(error))
                            }
            
                        }
                        task.resume()
        }
    }
    
    public func getCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/categories?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    //print(url)
                    completion(.failure(APIError.failedToGetData))
                    return
                    
                }
                do {
                    let result = try JSONDecoder().decode(AllCategoriesResponse.self, from: data)
                    //print(result.categories.items)
                    completion(.success(result.categories.items))
                }
                catch {
                    completion(.failure(error))
                }

                
            }
            task.resume()
            
        }
    }
    
    public func getCategoryPlaylists(category: Category,completion: @escaping (Result<[Playlist], Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/categories/\(category.id)/playlists?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                    
                }
                do {
                    let result = try  JSONDecoder().decode(CategoryPlaylistsResponse.self, from: data)
                    let playlists = result.playlists.items
                    completion(.success(playlists))
                    print(playlists)
                }
                catch {
                    completion(.failure(error))
                }

                
            }
            task.resume()
            
        }
    }
    
    public func search(with query: String, completion: @escaping (Result<[SearchResult], Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/search?limit=10&type=album,artist,playlist,track&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"), type: .GET) { request in
            print(request.url?.absoluteString ?? "non")
            let task = URLSession.shared.dataTask(with:request ) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(SearchResultsResponse.self, from: data)
                    var searchResults: [SearchResult] = []
                    searchResults.append(contentsOf:result.tracks.items.compactMap({SearchResult.track(model: $0)}))
                    searchResults.append(contentsOf:result.albums.items.compactMap({SearchResult.album(model: $0)}))
                    searchResults.append(contentsOf:result.artists.items.compactMap({SearchResult.artist(model: $0)}))
                    searchResults.append(contentsOf:result.playlists.items.compactMap({SearchResult.playlist(model: $0)}))
                    completion(.success(searchResults))
                 
                }
                catch {
                    print(error)
                    completion(.failure(error))
                }

            }
            task.resume()
            
        }
    }
    
    
    enum HTTPMethod: String {
        case GET
        case POST
        case DELETE
        case PUT
    }
    
    private func createRequest(with url: URL?, type:HTTPMethod, completion: @escaping(URLRequest) -> Void) {
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else {
                return
            }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
}
