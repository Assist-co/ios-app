//
//  CalendarViewController.swift
//  Assist
//
//  Created by Bryce Aebi on 11/30/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: SlidableViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tasks: [Task]?
    var filteredTasks: [Task]?

    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var noEventsLabel: UILabel!
    @IBOutlet weak var calendarEventsTableView: UITableView!
    
    var selectedCell: CalendarCellView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView();
        TaskService.fetchTasksForClient { (tasks: [Task]?, error: Error?) in
            self.tasks = tasks
        }
    }
    
    private func setupTableView() {
        calendarEventsTableView.dataSource = self;
        calendarEventsTableView.delegate = self;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Bad code:
        if let filteredTasks = filteredTasks {
            if filteredTasks.count > 0 {
                self.noEventsLabel.isHidden = true
            } else {
                self.noEventsLabel.isHidden = false
            }
        } else {
            self.noEventsLabel.isHidden = false
        }
        
        return filteredTasks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = calendarEventsTableView.dequeueReusableCell(withIdentifier: "CalendarTableCellTableViewCell", for: indexPath) as! CalendarTableCellTableViewCell
        
        if let task = self.filteredTasks?[indexPath.row] {
            cell.descriptionLabel.text = task.text
            let formatter = DateFormatter()
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            var startText = "???"
            if let startOn = task.startOn {
                startText = formatter.string(from: startOn)
            }
            cell.startAtLabel.text = startText
            var endText = "???"
            if let endOn = task.endOn {
                endText = formatter.string(from: endOn)
            }
            cell.endAtLabel.text = endText
        }
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !self.isUISetup {
            self.isUISetup = true
            self.setupMainThreadOperations()
        }
    }

    override func setupMainThreadOperations() {
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

}

extension CalendarViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
        let comp: DateComponents = Calendar.current.dateComponents([.year, .month, .hour], from: Calendar.current.startOfDay(for: Date()))
        let monthStart = Calendar.current.date(from: comp)!
        
        let startDate = monthStart // You can use date generated from a formatter
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
            myCustomCell.dayLabel.textColor = UIColor(hexString: "#888888ff")
        }
        
        if Calendar.current.isDate(date, inSameDayAs: Date()) {
            myCustomCell.selectedDate.isHidden = false
            myCustomCell.selectedDate.layer.cornerRadius =  16
            self.selectedCell = myCustomCell
        }
        
        myCustomCell.hasEventMarker.layer.cornerRadius = 3

    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        self.selectedCell?.selectedDate.isHidden = true
        let myCustomCell = cell as! CalendarCellView
        
        myCustomCell.selectedDate.layer.cornerRadius =  16
        
        if cellState.isSelected {
            myCustomCell.selectedDate.isHidden = false
        }
        
        self.filteredTasks = self.tasks?.filter({ ($0.startOn != nil) && Calendar.current.isDate($0.startOn!, equalTo: date, toGranularity: .day) })
        self.calendarEventsTableView.reloadData()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        let myCustomCell = cell as! CalendarCellView
        myCustomCell.selectedDate.isHidden = true
        
        self.filteredTasks = nil
        self.calendarEventsTableView.reloadData()
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
