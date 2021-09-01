//
//  ViewController.swift
//  TestGora
//
//  Created by Александр Галкин on 31.08.2021.
//

import UIKit

class ViewController: UIViewController {
    
    private var userModel: [UserModel.UserData]?
    private var imageModel: [ImageModel.ImageData]?
    private var albumModel: [AlbumModel.AlbumData]?
    private var loading: LoadingView = LoadingView(frame: UIScreen.main.bounds)
    private let imageCache: ImageCache = ImageCache()
    
    private let userURL = URL(string: "https://jsonplaceholder.typicode.com/users")
    private let imageURL = URL(string: "https://jsonplaceholder.typicode.com/photos")
    private let albumURL = URL(string: "https://jsonplaceholder.typicode.com/albums")
    
    private let queue = DispatchQueue.global(qos: .utility)
    
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startFetchData()
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        createConstraints()
        tableView.addSubview(loading)
        
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.topItem?.title = "Users"
    }
    
    //MARK: - Download data from server
    private func startFetchData() {
        
        //Добавляем асинхронную задачу в очередь по загрузке данных с удаленного сервера
        queue.async {
            guard let userURL = self.userURL, let userData = try? Data(contentsOf: userURL) else {return}
            guard let imageURL = self.imageURL, let imageData = try? Data(contentsOf: imageURL) else {return}
            guard let albumURL = self.albumURL, let albumData = try? Data(contentsOf: albumURL) else {return}
            
            do {
                let decoder = JSONDecoder()
                self.userModel = try decoder.decode([UserModel.UserData]?.self, from: userData) as [UserModel.UserData]?
                self.imageModel = try decoder.decode([ImageModel.ImageData]?.self, from: imageData) as [ImageModel.ImageData]?
                self.albumModel = try decoder.decode([AlbumModel.AlbumData]?.self, from: albumData) as [AlbumModel.AlbumData]?
                
                //Вызываем обновление таблицы когда данные были загружены. Пока не будет вызвано данное замыкание на экране будет показан activity indicator
                DispatchQueue.main.async {
                    self.updateDataOnTableView(.success(self.userModel))
                }
            } catch {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Ошибка", message: "Ошибка загрузки данных", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "ОК", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    //MARK: - Start update Views
    private func updateDataOnTableView (_ states: DataStates<[UserModel.UserData]?>) {
        switch states {
        case .initil(_):
            break
        case .success(_):
            loading.isHidden = true
            tableView.reloadData()
            break
        default:
            break
        }
    }
    
    //MARK: - Method for sorting images for each user
    private func sortImages(albums: [AlbumModel.AlbumData], users: [UserModel.UserData], images: [ImageModel.ImageData], indexPath: IndexPath) -> [ImageModel.ImageData] {
        
        var sortedImageData: [ImageModel.ImageData] = []
        
        for album in albums where album.userId == users[indexPath.row].id {
            for image in images {
                if album.id == image.albumId {
                    sortedImageData.append(image)
                }
            }
        }
        return sortedImageData
    }
    
    
    //MARK: - Method that create adaptive representation views
    private func createConstraints() {
        tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Method taht create new ViewController and send data to him
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let albums = albumModel,
              let users = userModel,
              let images = imageModel else {return}

        let sortedImages = sortImages(albums: albums, users: users, images: images, indexPath: indexPath)
        
        //Передаем набор данных для загрзуки и кэш для хранения изображений
        let collection = InterviewCollectionViewController(imagesData: sortedImages, imageCache: imageCache)
        navigationController?.pushViewController(collection, animated: true)
    }

    //MARK: - How many rows to show
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard userModel != nil else {
            return 1
        }
        return userModel!.count
    }

    //MARK: Finally setting each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        
        guard userModel != nil else {
            return cell
        }
        cell.accessoryType = .disclosureIndicator
        
        if let text = userModel![indexPath.row].name {
            cell.textLabel!.text = text
        }
        return cell
    }
}
