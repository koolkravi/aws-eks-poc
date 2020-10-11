import { Component, OnInit } from '@angular/core';
import { BehaviorSubject } from 'rxjs';
import { EmployeeComponent } from '../employee.component';
import { Employee } from '../model/employee';
import { EmployeeService } from '../service/employee.service';

@Component({
  selector: 'app-employee-list',
  templateUrl: './employee-list.component.html',
  styleUrls: ['./employee-list.component.css']
})
export class EmployeeListComponent implements OnInit {

  employees: Employee[];
  constructor(private employeeService: EmployeeService) { }

  ngOnInit(): void {
    // this.employeeService.getEmployees().subscribe(
    //   (response: Employee[]) => this.handleSuccessfulResponse(response)
    // )

    // subscribe to entire collection
    this.employeeService.employees.subscribe(
      (response: Employee[]) => this.handleSuccessfulResponse(response)
    )
    this.employeeService.loadEmployees();    // load all Employees

  }

  handleSuccessfulResponse(response: Employee[]) {
    this.employees = response;
  }

  deleteEmployee(employee: Employee) {
    this.employeeService.deleteEmployee(employee.empId).subscribe(
      (response) => {
        //this.employees = this.employees.filter(e => e.empId !== employee.empId);
        //this.ngOnInit();
        this.employeeService.loadEmployees();    // load all Employees
      }
    )
  }
}
