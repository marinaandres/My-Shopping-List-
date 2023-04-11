//
//  ViewController.swift
//  My Shopping List
//
//  Created by Marina Andrés Aragón on 7/4/23.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var barButtonItem: UIBarButtonItem!
    @IBOutlet weak var myTableView: UITableView!
    
    
let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
var grocerie:[Groceries]?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImage(named: "frutasV")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleToFill
        
        
        title = "My Shopping List"
       
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.separatorColor = .black
        myTableView.separatorStyle = .singleLine
        myTableView.backgroundView = imageView
        
        recoverData()
        
    }
    
    @IBAction func add(_ sender: Any) {
        //Creamos una alerta
        let newElement = Groceries(context: self.context)
        let alert = UIAlertController(title: "Agregar elemento", message: "Agrega un alimento", preferredStyle: .alert)
        alert.view.backgroundColor = .clear
        alert.addTextField { textField in
            textField.text = newElement.element
            textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
            
        }
        let textField = alert.textFields![0]
        
        let botonAlerta = UIAlertAction(title: "No añadir", style: .default)
        let botonAlerta2 = UIAlertAction(title: "Añadir", style: .default){ (action) in
            
            //Agregamos el item
            let textField = alert.textFields![0]
            newElement.element = textField.text
            self.grocerie?.insert(newElement, at: 0)
            try! self.context.save()
            self.recoverData()
        
        }
        //Establecer el estado inicial del boton
        botonAlerta2.isEnabled = !(textField.text?.isEmpty ?? true)
        
        alert.addAction(botonAlerta)
        alert.addAction(botonAlerta2)
        self.present(alert, animated: true)
    }
    
    @objc func textFieldDidChange1(_ textField: UITextField) {
        if let alert = self.presentedViewController as? UIAlertController,
           let botonAlerta2 = alert.actions.last {
            // habilitar o deshabilitar el boton segun si hay texto en el textField
            botonAlerta2.isEnabled = !(textField.text?.isEmpty ?? true)
        }
    }
            func recoverData() {
                do {
                    self.grocerie = try self.context.fetch(Groceries.fetchRequest())
                    DispatchQueue.main.async {
                        
                        self.myTableView.reloadData()
                    }
                } catch {
                    print("hubo un error al recuperar los datos")
                }
                
            }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let groceries = grocerie {
            return groceries.count
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "MyCell")
        cell.textLabel?.text = grocerie![indexPath.row].element
        cell.backgroundColor = .lightText
        cell.textLabel?.textColor = .darkText
        cell.textLabel?.font = .boldSystemFont(ofSize: 20)
       
        return cell
    }
}
extension ViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let elementEditable = grocerie![indexPath.row]
        let alert = UIAlertController(title: "Modificar alimentos", message: "Edita el alimento", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = elementEditable.element
            textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
            
        }
        let textField = alert.textFields![0]
        
        let botonAlerta1 = UIAlertAction(title: "No editar", style: .default)
        let botonAlerta2 = UIAlertAction(title: "Editar", style: .default){ (action) in
                let textField = alert.textFields![0]
                elementEditable.element = textField.text
                try! self.context.save()
                self.recoverData()
            }
        
        //Establecer el estado inicial del boton
        botonAlerta2.isEnabled = !(textField.text?.isEmpty ?? true)
        
            alert.addAction(botonAlerta1)
            alert.addAction(botonAlerta2)
            self.present(alert, animated: true)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        if let alert = self.presentedViewController as? UIAlertController,
           let botonAlerta2 = alert.actions.last {
            // habilitar o deshabilitar el boton segun si hay texto en el textField
            botonAlerta2.isEnabled = !(textField.text?.isEmpty ?? true)
        }
    }

    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let accionEliminar = UIContextualAction(style: .destructive, title: "Eliminar"){(action, view, completionHandler) in
            let elementoEliminar = self.grocerie![indexPath.row]
            self.context.delete(elementoEliminar)
            try! self.context.save()
            self.recoverData()
        }
        return UISwipeActionsConfiguration(actions: [accionEliminar])
        
    }
}

