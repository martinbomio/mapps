MAPPS
=====
Measure of Accurate Physical Parameters in Sports.
This system allows to measure the performance of a sport man in real time, quantifying the activity from precise data. This allows to take scientific decisions whenever planning a training session.
The system doesn't take any decision, it simply allows the trainers to gather precise information about the performance of each one of the sports man at the same time.

The project consists of 6 different modules:
* authenticationhandler:
    Handles all authentication and authorization related logic.
* mapps-filter:
    This module processes the data and generates data ready to be displayed to the user. Here lies the implementation of the algorithm that unites all data from the different sensors to generate accurate measurements of the sports man activity.
* mapps-persistance:
    Handles the persistence layer. Here lies all of the DB DAOs.
* mapps-receiver:
    This module is in charge of the logic for receiving the data from all of the devices in the training session and sending it to the server.
* mapps-services:
    Handles all the exposed JEE services.
* mapps-webapp:
    Nice and simple webapp for managing the training sessions and displaying the results.


