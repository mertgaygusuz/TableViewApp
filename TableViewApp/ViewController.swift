//
//  ViewController.swift
//  TableViewApp
//
//  Created by Mert Gaygusuz on 10.07.2022.
//

import UIKit

class ViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{
    

    @IBOutlet weak var table: UITableView!

    var fileURL : URL!
    var brands : [String] = []
    var brandDescriptions : [String] = []
    var brandDescription : String = ""
    var selectedRow : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        table.delegate = self
        
        //Edit Button
        
        let editButton = editButtonItem
        self.navigationItem.leftBarButtonItem = editButton
        
        let baseURL = try! FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
        
        fileURL = baseURL.appendingPathComponent("Brands.txt")
        loadData()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if selectedRow == -1 {
            return
        }
        if brandDescription == "" {
            brandDescriptions.remove(at: selectedRow)
            brands.remove(at: selectedRow)
        } else if brandDescription == brandDescriptions[selectedRow] {
            return
        } else {
            brandDescriptions[selectedRow] = brandDescription
        }
        saveData()
        table.reloadData()
    }
    
    @IBAction func btnAddBrandClicked(_ sender: UIBarButtonItem) {
        
        if table.isEditing {
            return
        }
        
        let alert = UIAlertController(title: "Marka Ekle", message: "Marka Adını Giriniz", preferredStyle: UIAlertController.Style.alert)
        
        alert.addTextField(configurationHandler: { txtBrandName in
            txtBrandName.placeholder = "Marka Adı"
        })
        
        
        let actionAdd = UIAlertAction(title: "Ekle", style: UIAlertAction.Style.default, handler: { action in
            
            let firstTextField = alert.textFields![0] as UITextField
            self.addBrand(brandName: firstTextField.text!)
        })
        
        let actionCancel = UIAlertAction(title: "İptal", style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.addAction(actionAdd)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return brands.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : UITableViewCell = table.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = brands[indexPath.row]
        return cell
        
    }
    
    
    func addBrand(brandName : String) {
        
        brands.insert(brandName, at: 0)
        brandDescriptions.insert("Girilmedi", at: 0)
        let indexPath : IndexPath = IndexPath(row: 0, section: 0)
        
        //Tabloya ekleme
        table.insertRows(at: [indexPath], with: UITableView.RowAnimation.left)
        saveData()
        table.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        performSegue(withIdentifier: "goToDescription", sender: self)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        table.setEditing(editing, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
            brands.remove(at: indexPath.row)
            brandDescriptions.remove(at: indexPath.row)
            table.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
            saveData()
        }
    }
    
    
    func saveData() {
        UserDefaults.standard.set(brands, forKey: "brands")
        UserDefaults.standard.set(brandDescriptions, forKey: "descriptions")
    }
    
    func loadData() {
        
        if let loadedData : [String] = UserDefaults.standard.value(forKey: "brands") as? [String] {
            brands = loadedData
            
        }
        if let aciklamalar : [String] = UserDefaults.standard.value(forKey: "descriptions") as? [String] {
            brandDescriptions = aciklamalar
        }
        table.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDescription", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let descriptionView : DescriptionViewController =  segue.destination as! DescriptionViewController
        selectedRow = table.indexPathForSelectedRow!.row
        descriptionView.setDescription(b: brandDescriptions[selectedRow])
        descriptionView.masterView = self
        
    }
}

