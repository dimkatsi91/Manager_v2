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
  4. install [CQtDeployer](https://github.com/QuasarApp/CQtDeployer) 
  5. Run next command to generate a Distribution/ folder for generate Distribution in out folder :
  
         make deploy
  6. Run this Distribution/bin/Manager_v2 executable to launch application


-------------------------------------------------------------------------------

- Update: December 29, 2020 : Deployment through appimagetool and linuxdeployqt. 
          Compiled and deployed in Ubuntu 20.04. To use in another Linux desktop
          version, recompile and follow common deployment procedure regarding 
          Linuxdeployqt and Appimagetool kits.

-------------------------------------------------------------------------------

- [x] Example I : Adding a new group in the system :
  
  - Provide credentials, long press Submit to activate & press this button

    ![credentials](https://github.com/dimkatsi91/Manager_v2/blob/master/samples/creds_submit.png)

  - List users before new user creation

    ![cat_users_apriori](https://github.com/dimkatsi91/Manager_v2/blob/master/samples/before_user_addition.png)

  - Type new user information and press the button CREATE

    ![create_new_user](https://github.com/dimkatsi91/Manager_v2/blob/master/samples/user_create.png)

  - List users after new user creation

    ![cat_users_aposteriori](https://github.com/dimkatsi91/Manager_v2/blob/master/samples/after_user_addition.png)

  - BONUS: Check IPv4 Firewall configuration for Mangle Table

    ![ip4tables_Mangle](https://github.com/dimkatsi91/Manager_v2/blob/master/samples/ipv4_mangle_firewall.png)
