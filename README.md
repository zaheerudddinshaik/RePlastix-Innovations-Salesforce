# RePlastix Innovations – Salesforce Project

## Project Overview

RePlastix Innovations is a Salesforce-based management system designed to organize plastic waste collection, recycling operations, recycled products, customer orders, and stock replenishment.

The application uses Salesforce CRM capabilities to connect different operational activities through a centralized data model. Automation and Apex logic are used to reduce manual work and maintain consistent inventory information.

## Objectives

- Manage plastic waste collection records.
- Maintain recycling center information.
- Manage recycled products and their stock levels.
- Process customer orders for recycled products.
- Identify products that require restocking.
- Automate stock-related activities using Salesforce Flow.
- Apply validation rules to maintain data quality.
- Implement role-based and record-level security.
- Use Apex for inventory-related business logic.
- Test the implemented automation and Apex functionality.

## Salesforce Technologies Used

- Salesforce Developer Edition
- Custom Objects
- Custom Fields
- Custom Tabs
- Lightning App Manager
- Validation Rules
- Formula Fields
- Role Hierarchy
- Profiles
- Users
- Record-Level Security
- Flow Builder
- Apex
- Apex Testing

## Main Data Model

The application consists of the following major entities:

- Plastic Waste
- Recycling Center
- Recycled Product
- Order
- Restock Request

These objects are connected through relationships that allow information to move between waste management, recycling, product inventory, order processing, and restocking activities.

## Key Features

### Plastic Waste Management

Plastic waste records contain information such as collection date, location, recycling center, waste type, status, and weight.

### Recycled Product Management

Recycled products maintain product information, price, available stock, and stock threshold. A formula field provides an automatic indication of whether the available stock requires attention.

### Order Management

Orders connect customers with recycled products and record quantities and delivery information.

### Restock Management

Restock requests are created when product inventory requires replenishment. The request records the product, requested quantity, and approval status.

### Automation

Salesforce Flow is used to automate stock-related activities and create tasks when inventory conditions require action.

### Apex

Apex logic supports inventory processing by updating product stock based on orders and approved restock requests.

### Security

Salesforce security features including roles, profiles, users, sharing configuration, and record-level access are used to control access to project data.

## Project Documentation

The complete implementation and configuration process is available in the project documentation.

See:

`Documentation/SFReplastixDoc.pdf`

##Testing

The Apex implementation was tested using Salesforce Developer Console. The final test execution completed successfully, with the implemented Apex components reaching full code coverage in the recorded test run.

##Conclusion

The RePlastix Innovations Salesforce application demonstrates how Salesforce CRM can be configured and extended to support a complete plastic recycling management workflow. Custom data structures, security configuration, declarative automation, and Apex programming are combined to provide an integrated solution for managing waste, recycled products, orders, and inventory replenishment.

## Project Structure

```text
RePlastix-Innovations-Salesforce/
│
├── README.md
│
├── Documentation/
│   └── SFReplastixDoc.pdf
│
└── Apex/
    └── Apex implementation files

