//
//  ViewController.swift
//  Time_Visualizer
//
//  Created by administrator on 1/10/22.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let save = (UIApplication.shared.delegate as! AppDelegate).saveContext
    
    var weekList = [Week]()
    var dataList = [Times]()
    var daysList = [Days]()
    var data = [Times]()
    var selectedDay = 0
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var dayPickerView: UIPickerView!
    var transparentView = UIView()
    var addTableView = UITableView()
    var height: CGFloat = 220
    
    let days = ["Saterday","Sunday","Monday","Tuseday","Wednisday","Thursday","Friday"]
    let times = ["4:00","4:30","5:00","5:30","6:00","6:30","7:00","7:30","8:00","8:30","9:00","9:30"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchingData()
        
        mainTableView.dataSource = self
        mainTableView.delegate = self
        mainTableView.rowHeight = 90
        addTableView.dataSource = self
        addTableView.delegate = self
        addTableView.register(CustomAddTableViewCell.self, forCellReuseIdentifier: "addCell")
        addTableView.backgroundColor = .gray
        dayPickerView.delegate = self
        dayPickerView.dataSource = self
    }
    
    func fetchingData() {
        let weekResult: NSFetchRequest<Week> = Week.fetchRequest()
        let dataResult: NSFetchRequest<Times> = Times.fetchRequest()
        let daysResult: NSFetchRequest<Days> = Days.fetchRequest()
        do {
            weekList = try context.fetch(weekResult)
            daysList = try context.fetch(daysResult)
            dataList = try context.fetch(dataResult)
        }catch {
            print(error)
        }
        if weekList.isEmpty{
            startNewWeek()
        }else {
            let week = weekList[weekList.count - 1]
            let day = daysList.filter { day in
                return day.day! == days[selectedDay] && day.inWeek! == week
            }
            data = dataList.filter{ data in
                return data.inDay! == day[day.count - 1]
            }
            mainTableView.reloadData()
        }
    }

    func startNewWeek() {
        let date = Date()
        let formatedDate = DateFormatter()
        formatedDate.dateStyle = .short
        formatedDate.timeStyle = .none
        var setDate = formatedDate.string(from: date)
        setDate.removeLast(6)
        var dayDate = Int(setDate)! - 1
        
        let newWeek = Week(context: context)
        newWeek.weekNumber = Int32(weekList.count)
        save()
        
        for day in days{
            let newDay = Days(context: context)
            newDay.inWeek = newWeek
            newDay.day = day
            dayDate += 1
            newDay.date = String(dayDate)
            save()
            
            for time in times{
                let newData = Times(context: context)
                newData.inDay = newDay
                newData.time = time
                newData.note = " "
                save()
            }
        }
        
        fetchingData()
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        transparentView.frame = self.view.frame
        window?.addSubview(transparentView)
        
        let screenSize = UIScreen.main.bounds.size
        addTableView.frame = CGRect(x: 10, y: screenSize.height, width: screenSize.width - 20, height: height)
        addTableView.layer.cornerRadius = 20
        //addTableView.rowHeight = 60
        window?.addSubview(addTableView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action:  #selector(closeTransparentView))
        transparentView.addGestureRecognizer(tapGesture)
        
        transparentView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.addTableView.frame = CGRect(x: 10, y: screenSize.height - self.height, width: screenSize.width - 20, height: self.height)
            
        }, completion: nil)
    }
    
    @objc func closeTransparentView() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            let screenSize = UIScreen.main.bounds.size
            self.addTableView.frame = CGRect(x: 10, y: screenSize.height, width: screenSize.width - 20, height: self.height)
            self.transparentView.alpha = 0
        }, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = sender as? NSIndexPath else { return }
        let destination = segue.destination as! KeywordsViewController
        destination.controllDelegate = self
        destination.indexPath = indexPath
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == mainTableView{
            return data.count
        }else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == mainTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
            cell.layer.cornerRadius = 10
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor.systemOrange.cgColor
            cell.timeLabel.text = data[indexPath.row].time
            cell.taskTextfieald.text = data[indexPath.row].note
            cell.indexPath = indexPath as NSIndexPath
            cell.controllDelegate = self
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addCell", for: indexPath) as! CustomAddTableViewCell
            switch indexPath.row{
            case 0:
                cell.titleLabel.text = "Clcik Add New Week To Start New Week\nor Clicl View Chart to See Charts"
            case 1:
                cell.titleLabel.text = "Add New Week"
                cell.titleLabel.textColor = .red
            case 2:
                cell.titleLabel.text = "View Chart"
                cell.titleLabel.textColor = .blue
            default:
                cell.titleLabel.text = ""
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView == mainTableView{
            performSegue(withIdentifier: "addKeyword", sender: indexPath)
        }
        else{
            switch indexPath.row{
            case 1:
                //Set alert Message
                let alert = UIAlertController(title: "Start New Week ??", message: nil, preferredStyle: .alert)
                //Styling my aalert
                alert.view.layer.cornerRadius = 10
                alert.view.layer.borderWidth = 2
                alert.view.layer.borderColor = UIColor.red.cgColor
                //Add Action Buttons to My Alert
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {action in
                    return
                }))
                alert.addAction(UIAlertAction(title: "Sure", style: .destructive, handler: { action in
                    self.startNewWeek()
                    self.closeTransparentView()
                }))
                self.present(alert, animated: true, completion: nil)
            case 2:
                let chartsViewController = ChartsViewController()
                self.present(chartsViewController, animated: true, completion: nil)
                self.closeTransparentView()
            default:
                return
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == addTableView{
            switch indexPath.row{
            case 0:
                return 100
            case 1:
                return 60
            case 2:
                return 60
            default:
                return 10
            }
        }
        return 90
    }
}

extension ViewController: ControllDelegate {
    func newEntryPassing(string: String, indexPath: NSIndexPath) {
        data[indexPath.row].note = string
        save()
        fetchingData()
    }
    
    func keywordPassing(keyword: String, indexPath: NSIndexPath) {
        guard let currentNote = data[indexPath.row].note else { return }
        data[indexPath.row].note = "\(currentNote) \(keyword)"
        save()
        fetchingData()
    }
}

//MARK: Picker View Codes
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    //Number of rows in the Picker View
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //Number of elements in the row
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return days.count
    }
    //Elements that will be displayed
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        //Styling string element before display
        let day = NSAttributedString(string: days[row], attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle), size: 28),
        ])
        return day
    }
    //Save selected day
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDay = row
        fetchingData()
    }
}

