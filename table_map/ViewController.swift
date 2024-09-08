//
//  ViewController.swift
//  table_map
//
//  Created by Sultan Kubentayev on 08/09/2024.
//

import UIKit
import MapKit
import SnapKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var arrayItems = [
        Items(
            title: "Kazakhstan Hotel",
            address: "address: \nDostyk Ave 52/2, Almaty 480051, Kazakhstan",
            image1: "kazakhstan_express",
            latitude: 37.7749,
            longitude: -122.4194
//            Настоящие координаты
//            latitude: 43.244643,
//            longitude: 76.957103
        ),
        Items(
            title: "Holiday Inn Express",
            address: "address: \nSeifullin Avenue, Seyfullin Avenue, Almaty 050067, Kazakhstan",
            image1: "holiday_inn_express",
            latitude: 43.239485,
            longitude: 76.933951
        ),
        Items(
            title: "Garden Park Inn",
            address: "address: \nBaytursynova St 139, Almaty 050013, Kazakhstan",
            image1: "garden_park_inn",
            latitude: 43.234285,
            longitude: 76.930439
        ),
        Items(
            title: "Resident Hotel",
            address: "address: \nZheltoksan St 89, Almaty 050009, Kazakhstan",
            image1: "resident_hotel",
            latitude: 43.256431,
            longitude: 76.938180
        ),
        Items(
            title: "Dostyk Hotel",
            address: "address: \nKurmangazy St 36, Almaty 050021, Kazakhstan",
            image1: "dostyk_hotel",
            latitude: 43.244690,
            longitude: 76.95134
        )
    ]
    
    
    var tableView1 : UITableView = {
        let tv = UITableView()
        tv.register(TableViewCell.self, forCellReuseIdentifier: "Cell")
        // За элементами
        tv.backgroundColor = UIColor(red: 55/255, green: 55/255, blue: 55/255, alpha: 1)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        
        tableView1.dataSource = self
        tableView1.delegate = self
        // Do any additional setup after loading the view.
    }

    func setupUI(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.app"), style: .done, target: self, action: #selector (barButtonTapped))
        navigationItem.title = "Booking"
        // цвет навигейшн бара
        view.backgroundColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
        view.addSubview(tableView1)
    }
    
    func setupConstraints(){
        tableView1.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    @objc func barButtonTapped() {
        
        arrayItems.insert(
            Items(
                title: "New Hotel Name",
                address: "Address",
                image1: "default",
                latitude: 0.0,
                longitude: 0.0
            ), at: 0)
        tableView1.reloadData()
        
//        tableView.beginUpdates()
//        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
//        tableView.endUpdates()
            
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Удаление элемента из массива данных
            arrayItems.remove(at: indexPath.row)
            
            // Удаление строки из таблицы с анимацией
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayItems.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        
        let item = arrayItems[indexPath.row]
        
        cell.titleLabel.text = item.title
        cell.addressLabel.text = item.address
        cell.imageView1.image = UIImage(named: item.image1)

        return cell
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 480
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mapVC = MapViewController()

        // Получаем выбранный элемент из массива
        let selectedItem = arrayItems[indexPath.row]

        // Передаем координаты в MapViewController
        mapVC.latitude = selectedItem.latitude
        mapVC.longitude = selectedItem.longitude

        // Переход на MapViewController
        navigationController?.pushViewController(mapVC, animated: true)
    }

    
    
}


