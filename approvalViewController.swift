//
//  approvalViewController.swift
//  siridemo
//
//  Created by Pri Tam on 4/14/19.
//  Copyright © 2019 Pri Tam. All rights reserved.
//

import UIKit

import Firebase

class approvalViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
    {
    
    var approvalarray:[String] = []
    var arrSelectedStudent :[Int] = []
    var dataupdated:[String] = []
    var useridarray:[String] = []
    var updateduserid:[String] = []
    
    
    @IBOutlet weak var approvaltb: UITableView!
    
    @IBOutlet weak var updatedtb: UITableView!
    
    
    @IBAction func savebutton(_ sender: UIButton) {
        
        self.savedata(updateddata: dataupdated, updateduserid: updateduserid)
        
        
        
       
        
    }
    
    func  savedata(updateddata:[String],updateduserid:[String])
    {
       
        let sequence = zip(updateddata, updateduserid)
        
        for (el1, el2) in sequence
        {
            print("name and userid = \(el1) - \(el2)")
            
            let db = database.database.reference()
           let ref = db.child("accepteduser").child(el2)
            let autoid = ref.childByAutoId()
            let data = ["name":el1,"userid":el2] as [String:Any]
            autoid.setValue(data)
            
    self.alert(msg: "User Accepted Successfully")
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        if tableView == approvaltb
        {
            count = self.approvalarray.count
        }
        if tableView == updatedtb
        {
            count = self.dataupdated.count
        }
        
        
        return count
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var siricell = UITableViewCell()
        
        if tableView == approvaltb
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "approvalcell") as! ApprovaldataTableViewCell
            
            cell.approvallabel.text = self.approvalarray[indexPath.row]
            cell.secondapprovallabel.text = self.useridarray[indexPath.row]
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            // cell.lblStudentName.text = getStudentName[indexPath.row]
            
            if arrSelectedStudent.contains(indexPath.row)
            {
                //  cell.btnCheckbox.setImage(UIImage(named: "selectedItem"), for: .normal)
                cell.approvalimage1.image = UIImage(named: "selectedItem")
            }
            else
            {
                //cell.btnCheckbox.setImage(UIImage(named: "unSelectedItem"), for: .normal)
                cell.approvalimage1.image = UIImage(named: "unSelectedItem")
            }
            
        siricell = cell
            
        }
        if tableView == updatedtb
        {
         let cell = tableView.dequeueReusableCell(withIdentifier: "approvalcell2") as! updatedTableViewCell
            cell.updatedlabel.text = dataupdated[indexPath.row]
            siricell = cell
        }
        
        
        
        
        
        return siricell
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        
        print("the indexpath = \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "approvalcell") as! ApprovaldataTableViewCell
        
        

        if let index = arrSelectedStudent.index(of: indexPath.row)
        {
            arrSelectedStudent.remove(at: index)
            
            dataupdated.remove(at: index)
            self.approvaltb.reloadData()
            //   selected = indexPath.row - indexPath.row
            cell.approvalimage1.image = UIImage(named: "selectedItem")
           
            // print("selected lblStudentName = \(cell.approvallabel.text!)")
             print("data updated after remove = \(self.dataupdated)")
           
            self.updatedtb.reloadData()
        }
        else
        {
            
            arrSelectedStudent.append(indexPath.row)
    
             cell.approvalimage1.image = UIImage(named: "unSelectedItem")
            
         
            let index = tableView.indexPathForSelectedRow
            let cell = tableView.cellForRow(at: index!) as! ApprovaldataTableViewCell
            
           
           // print("de selected lblStudentName = \(cell.approvallabel.text!)")
            self.dataupdated.append(cell.approvallabel.text!)
            // print("the userid = \(dataupdated[indexPath.row])")
            //print("hiddenuserid = \(useridarray[indexPath.row])")
            self.updateduserid.append(cell.secondapprovallabel.text!)
            print("updateduserid = \(self.updateduserid)")
             print("data updated = \(self.dataupdated)")
            self.approvaltb.reloadData()
            self.updatedtb.reloadData()
           
        }
        
        approvaltb.beginUpdates()
        approvaltb.endUpdates()
        approvaltb.reloadData()
    }

    
    
    let db = database.database.reference()
 
    var apporvalobj:[Admindatamodel] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
       self.retrieveemploydata()
        
        
    }
    
       

    func retrieveemploydata()
    {
        let ref = db.child("Userdetails").observe(DataEventType.value) { (snap) in
            let eventdataloc = snap.value as? [String:Any] ?? [:]
            print("eventdataloc = \(eventdataloc)")
            self.approvalarray.removeAll()
            for (key1, val) in eventdataloc
            {
                let ref = self.db.child("Userdetails").child(key1)
                
                ref.observe(DataEventType.value) { (snapshot) in
                    let eventdataloc1 = snapshot.value as? [String:Any] ?? [:]
                    
                    
                    for (key,val) in eventdataloc1
                    {
                        print("the key = \(key)")
                        let ref1 = self.db.child("Userdetails").child(key1).child(key)
                        ref1.observe(DataEventType.value) { (snapshot) in
                            let eventdataloc1 = snapshot.value as? [String:Any] ?? [:]
                            
                            let obj = Admindatamodel().userdetails(user: eventdataloc1)
                            self.apporvalobj.append(obj)
                            self.getdata(data: self.apporvalobj)
                            
                            //
                            
                            
                        }
                        
                    }
                    
                }
                
                
                
            }
        }
      
       
        
        }
        
  
    func getdata(data:[Admindatamodel])
    {
        self.approvalarray.removeAll()
        self.useridarray.removeAll()
        if self.apporvalobj.count > 0
        {
            for i in self.apporvalobj
            {
                self.approvalarray.append(i.sirifirstname!)
                self.useridarray.append(i.siriuserid!)
                
            }
            print("self approval array = \(self.approvalarray)")
        }
         self.approvaltb.reloadData()
    }
    
    
    func alert(msg:String)
    {
        let alert = UIAlertController(title: msg, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    

}
