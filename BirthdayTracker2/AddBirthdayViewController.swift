//
//  ViewController.swift
//  BirthdayTracker2
//
//  Created by Валентина Лучинович on 25.09.2021.
//

import UIKit
import CoreData
import UserNotifications

class AddBirthdayViewController: UIViewController {
    @IBOutlet var firstNameTextFieled: UITextField!
    @IBOutlet var lastNameTextFiled: UITextField!
    @IBOutlet var birthdatePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        birthdatePicker.maximumDate = Date()
    }
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        print("Нажата кнопка сохранения.")
        
        let firstName = firstNameTextFieled.text ?? ""
        let lastName = lastNameTextFiled.text ?? ""
        let birthdate = birthdatePicker.date
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newBirthday = Birthday(context: context)
        newBirthday.firstName = firstName
        newBirthday.lastName = lastName
        newBirthday.birthdate = birthdate as Date?
        newBirthday.birthdayID = UUID().uuidString
        
        if let uniqueId = newBirthday.birthdayID {
            print("birthdayId: \(uniqueId)")
        }
        
        do {
            try context.save()
            let message = "Сегодня \(firstName) \(lastName) празднует день рождения!"
            let content = UNMutableNotificationContent()
            content.body = message
            content.sound = UNNotificationSound.default
            var dateComponents = Calendar.current.dateComponents([.month, .day], from: birthdate)
            dateComponents.hour = 8
//            dateComponents.minute = 12
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            if let identifier = newBirthday.birthdayID {
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                let center = UNUserNotificationCenter.current()
                center.add(request, withCompletionHandler: nil)
            }
        } catch let error {
            print("Не удалось сохранить из-за ошибки \(error)")
        }
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
