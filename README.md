> <h2><strong>Qt Quick Linux Manager Utility - Application</strong></h2>

<h5>Title   : Linux Manager Application</h5>

<h5>Author  : Dimos Katsimardos</h5>

<h5>Date    : Janvier 06, 2020</h5>

<h5>IDE     : Qt Creator 4.11.0 Open Source Community Edition</h5>

<h5>Tools   : Qt 5.14.0 Open Source Community Edition, QML, C++</h5>

<h5>Applicable  : Every Linux distribution</h5>

-------------------------------------------------------------------------------

- Description: This is a custom Qt Quick Application for Linux Desktop. User has the ability
  create or remove a new or existing user from its Linux Desktop by providing his/her credentials.
  Also, the user has the ability to create, rename or remove a group from the system.
  Last, there is provided an option for a few system related information, like for example:
  the current real users and groups that exist in the Linux system, the available shells of the target
  system, the Networking Interfaces, the Routing tableand the Firewall configuration of the system
  for every possible Firewall Table, like for example Filter, RAW, Security and Mangle.

- Manager Interface:

![Manager](https://github.com/dimkatsi91/Manager_v2/blob/master/samples/ManagerWindow.png)


-------------------------------------------------------------------------------

- Deployment via [CQtDeployer](https://github.com/QuasarApp/CQtDeployer) :

  1. Build in Qt Creator in 'Release' mode
  2. Clean project
  3. Enter terminal inside release folder where Manager_v2 is located
  4. Run next command to generate a Distribution/ folder containing bin/Manager_v2 
  5. Run this Distribution/bin/Manager_v2 executable to launch application

