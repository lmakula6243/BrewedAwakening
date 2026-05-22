import SwiftUI
import FirebaseDatabase
import FirebaseCore
import Combine
import ConfettiSwiftUI

struct IDScannerChoicePage: View {
    @State var scannedCode = ""
    @State var intScannedCode: Int?
    @State var showScanSheet = false
    @State var typedID = ""
    @State var showIDSheet = false
    @ObservedObject var myViewModel: StudentsViewModel
    @ObservedObject var groupsVM: GroupsViewModel
    @State var nameOfGroup: String = ""
    @Binding var group: Group
    @State var showCheckmark = false
    @State var confettiCounter = 0
    @State var clockOutTimes: [Int: Date] = [:]
    @State var showSignOutAlert: Bool = false
    @State var studentPendingSignOut: Student?
   
   
    var body: some View {
        ZStack {
            VStack {
                Text("\(group.groupName)'s group is signing in")
                    .font(.custom("Hiragino Kaku Gothic StdN", size: 35))
                    .padding()
                
                VStack {
                    List {
                        
                        if let updatedGroup = groupsVM.groups.first(where: { $0.id == group.id }) {
                            
                            ForEach(updatedGroup.students) { student in
                                
                                HStack {
                                    
                                    VStack(alignment: .leading) {
                                        
                                        Text("\(student.firstname) \(student.lastname)")
                                            .font(.headline)
                                        
                                        Text("Scanner ID: \(student.scannerId)")
                                        Text("Student ID: \(student.idnum)")
                                        
                                        Button(action: {
                                            studentPendingSignOut = student
                                            showSignOutAlert = true
                                        }) {
                                            
                                        }
                                    }
                                
                                    Spacer()
                                    
                                    
                                    if student.clockInTime > 0 {

                                        let start = Date(
                                            timeIntervalSince1970: student.clockInTime
                                        )

                                        VStack(alignment: .trailing) {

                                            Text("Signed In:")
                                                .font(.caption)

                                            Text(formattedClockInTime(start))
                                                .font(.subheadline)
                                        }
                                    }
                                }
                                .listRowBackground(Color.orange)
                            }
                            .onDelete { indexSet in
                                
                                for index in indexSet {
                                    
                                    let student = updatedGroup.students[index]
                                    
                                    groupsVM.removeStudentFromGroup(
                                        groupId: updatedGroup.id,
                                        student: student
                                    )
                                }
                            }
                        }
                    }
                    
                    HStack {
                        Button(action: {
                            showScanSheet.toggle()
                            
                        }, label: {
                            VStack {
                                Text("Scan Button:" )
                                    .foregroundStyle(.black)
                                    .font(.custom("Hiragino Kaku Gothic StdN", size: 20))
                                    .padding()
                                ZStack {
                                    RoundedRectangle(cornerRadius: 90)
                                        .frame(width: 350, height: 300)
                                        .foregroundStyle(Color.orange)
                                    Image("Scanner")
                                        .resizable()
                                        .frame(width: 280, height: 280)
                                    
                                }
                            }
                        })
                        .sheet(isPresented: $showScanSheet){
                            Text("Scan Student ID")
                                .font(.largeTitle)
                            
                            TextField("Waiting for scan…", text: $scannedCode)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 400, height: 50)
                            
                                .onSubmit {
                                    processScan()
                                    showScanSheet = false
                                    checkMarkAnimation()
                                }
                            
                            Image("Scanner")
                            
                            
                        }
                        
                        Button(action: {
                            showIDSheet.toggle()
                        }, label: {
                            VStack {
                                Text("ID Button:")
                                    .foregroundStyle(Color.black)
                                    .font(.custom("Hiragino Kaku Gothic StdN", size: 20))
                                    .padding()
                                ZStack {
                                    RoundedRectangle(cornerRadius: 90)
                                        .frame(width: 350, height: 300)
                                        .foregroundStyle(Color.brown)
                                    Image("Keypad")
                                        .resizable()
                                        .frame(width: 300, height: 300)
                                }
                            }
                        })
                        .sheet(isPresented: $showIDSheet){
                            
                            Text("Type Student ID")
                                .font(.largeTitle)
                            
                            TextField("Type Student ID here…", text: $typedID)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 400, height: 50)
                                .onSubmit {
                                    processID(typedID)
                                    typedID = ""
                                    showIDSheet = false
                                    checkMarkAnimation()
                                }
                            Image("Keypad")
                        }
                    }
                    
                }
                .alert(isPresented: $showSignOutAlert) {

                    let name = "\(studentPendingSignOut?.firstname ?? "") \(studentPendingSignOut?.lastname ?? "")"

                    return Alert(
                        title: Text("Sign Out Confirmation"),
                        message: Text("\(name) is signed out at the current time. Are you sure you want to sign out?"),
                        primaryButton: .destructive(Text("Sign Out")) {

                            guard let student = studentPendingSignOut else { return }

                            let now = Date()

                            //TEMP
                            clockOutTimes[student.idnum] = now
                            
                            groupsVM.removeStudentFromGroup(
                                    groupId: group.id,
                                    student: student
                                )

                            print("\(student.firstname) signed out at \(now)")

                            studentPendingSignOut = nil
                        },
                        secondaryButton: .cancel {
                            studentPendingSignOut = nil
                        }
                    )
                }
            }
            if showCheckmark == true {
                
                ZStack {
                    Color.black.opacity(0.5).ignoresSafeArea()
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 500))
                        .foregroundStyle(.green)
                        .symbolEffect(.bounce, value: showCheckmark)
                }
            }
        }
        .confettiCannon(
            trigger: $confettiCounter,
            num: 70,
            confettiSize: 18,
            radius: 400
            
        )
        .onReceive(myViewModel.$students) { newStudents in

            guard let foundStudent = newStudents.last else { return }

            let currentStudents =
                groupsVM.groups.first(where: { $0.id == group.id })?.students ?? []

            let exists = currentStudents.contains {
                $0.idnum == foundStudent.idnum
            }

            guard !exists else { return }
//checks if a student already exists
            groupsVM.addStudentToGroup(
                groupId: group.id,
                student: foundStudent
            )
        }
    }
    
    
        func processScan() {
            
            if let intScannedCode = Int(scannedCode) {
                myViewModel.getData(byField: "scannerId", value: intScannedCode)
            } else {
                print("Invalid scan")
            }
           
        }
        
        func processID(_ code: String){
            guard let intNumCode = Int(typedID) else{
                print("invaild id#")
                return
            }
            myViewModel.getData(byField: "id", value: intNumCode)
        }

    func formattedClockInTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    func formattedClockOutTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    func checkMarkAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation{
                showCheckmark = true
            }
        }
        confettiCounter += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation{
                showCheckmark = false
            }
        }
        
    }
    
    func removeStudentFromGroup(at offsets: IndexSet) {
                for index in offsets {
                    let student = myViewModel.students[index]
                    
                    myViewModel.students.remove(at: index)
                    group.students.removeAll { $0.id == student.id }
                    
                    groupsVM.removeStudentFromGroup(
                        groupId: group.id,
                        student: student
                    )
                }
            }

    }
    
    

