//
//  CalendarViewController.swift
//  Assist
//
//  Created by Bryce Aebi on 11/30/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: SlidableViewController {

    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.registerCellViewXib(file: "CalendarCellView")
        calendarView.cellInset = CGPoint(x: 0, y: 0)
        calendarView.registerHeaderView(xibFileNames: ["CalendarHeaderView"])
        
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor(hexString: "#181A1Dff")
        navigationController!.navigationBar.isTranslucent = false

    }

    @IBAction func onHomeButtonTap(_ sender: AnyObject) {
        slidingViewController.showMainContent(duration: 0.25)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension CalendarViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
        let startDate = Date() // You can use date generated from a formatter
        let endDate = Date()                                // You can also use dates created from this function
        let parameters = ConfigurationParameters(
            startDate: startDate,
            endDate: endDate,
            numberOfRows: 6, // Only 1, 2, 3, & 6 are allowed
            calendar: Calendar.current,
            generateInDates: .forAllMonths,
            generateOutDates: .tillEndOfGrid,
            firstDayOfWeek: .sunday)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        let myCustomCell = cell as! CalendarCellView
        
        // Setup Cell text
        myCustomCell.dayLabel.text = cellState.text
        
        // Setup text color
        if cellState.dateBelongsTo == .thisMonth {
            myCustomCell.dayLabel.textColor = UIColor(hexString: "#efeff4ff")
        } else {
            myCustomCell.dayLabel.textColor = UIColor.gray
        }
        
        /*let diff = Calendar.current.components([.Day], fromDate: date, toDate: Date(), options: [])
        if diff.day == 0 {
            myCustomCell.selectedDate.isHidden = false
        }*/
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        let myCustomCell = cell as! CalendarCellView
        
        // Let's make the view have rounded corners. Set corner radius to 25
        myCustomCell.selectedDate.layer.cornerRadius =  16
        
        if cellState.isSelected {
            myCustomCell.selectedDate.isHidden = false
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        let myCustomCell = cell as! CalendarCellView
        myCustomCell.selectedDate.isHidden = true
    }
    
    // This sets the height of your header
    func calendar(_ calendar: JTAppleCalendarView, sectionHeaderSizeFor range: (start: Date, end: Date), belongingTo month: Int) -> CGSize {
        return CGSize(width: 200, height: 72)
    }
    // This setups the display of your header
    func calendar(_ calendar: JTAppleCalendarView, willDisplaySectionHeader header: JTAppleHeaderView, range: (start: Date, end: Date), identifier: String) {
        //let headerCell = (header as? CalendarHeaderView)
        //headerCell?.title.text = "Hello Header"
    }
}
