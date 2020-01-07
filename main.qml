import QtQuick 2.12
import QtQuick.Window 2.12
// import qt quick controls & layouts
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.12
// import some text field styles
import QtQuick.Controls.Styles 1.3
// import Qt Quick Dialogs
import QtQuick.Dialogs 1.2


ApplicationWindow {
    id: rootElementId
    visible: true
    width: 720
    height: 740
    title: qsTr("Bienvenue au Linux Manager Utilitaire")
    // Add the Menu Bar for all items regarding Manager Application
    //
    menuBar: MenuBar {
        // change default color of MenuBar
        background: Rectangle {
            color: "lightgray"
        }
        Menu {
            title: "&Help"
            Action {
                id: aboutManagerId
                text: qsTr("Manager &Help")
                icon.source: "/aboutManager.png"
                icon.color: "transparent"
                onTriggered: {
                    aboutManagerDialogId.open()
                }
            }
            Action {
                id: aboutAuthorId
                text: "About &Author"
                icon.source: "/aboutAuthor.png"
                icon.color: "transparent"
                onTriggered: {
                    //console.log("About Author Action was triggered ...")
                    genericMessageDialog.title = "About Author"
                    genericMessageDialog.text = "Dimos Katsimardos\nwww.linkedin.com/in/dimkatsi91\nJanvier 06, 2020"
                    genericMessageDialog.open()
                }
            }
        }
        // Window Manager App MenuBar & respective Actions :
        // [1] Change Manager background color & [2] Quit Manager Application
        //
        Menu {
            title: qsTr("&Window")
            width: 200
            Action {
                id: changeColorActionId
                text: qsTr("Change Manager &Color")
                icon.source: "/backColor.png"
                icon.color: "transparent"
                onTriggered: {
                    // open ColorDialog to choose a color
                    colorDialogId.open()
                }
            }
            MenuSeparator {}
            Action {
                id: quitManagerAppId
                text: qsTr("Quit &Manager")
                icon.source: "/exit.png"
                icon.color: "transparent"
                onTriggered: {
                    //console.log("Quit Action was triggered ...")
                    quitManagerDialogId.open()
                }
            }
        }
    }
    // A popUp Message Dialog in order to choose YES | NO upon quit action from Manager Application
    //
    MessageDialog {
        id: quitManagerDialogId
        title: "Quit Manager Application ?"
        text: "Are you sure you want to exit Manager?"
        standardButtons: StandardButton.Ok | StandardButton.Cancel
        onAccepted: {
            console.log("Quit MessageDialog accepted ...")
            Qt.quit()
        }
        onRejected: {
            console.log("Quit MessageDialog rejected ...")
        }
    }

    // Dialog to open when About Manager Action is chosen
    //
    Dialog {
        id: aboutManagerDialogId

        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: Math.min(parent.width, parent.height) / 3 * 2
        ////contentHeight: parent.height/2 // This doesn't cause the binding loop.
        ////parent: Overlay.overlay

        ////modal: true
        title: "About Manager"
        standardButtons: Dialog.Close

        Column {
            id: column
            spacing: 20
            width: rootElementId.width/3*2
            height: rootElementId.height

            Image {
                id: logo
                width: parent.width / 2
                anchors.horizontalCenter: parent.horizontalCenter
                fillMode: Image.PreserveAspectFit
                source: "/manager.png"
            }

            Label {
                width: parent.width
                text: "This is a Qt Quick Linux Application that helps user create, remove or rename "
                      + "a user in Linux Desktop. Enter current user username and type password two "
                      + "times just for confirmation. Then, enter 'Submit' Button in order to continue. "
                      + "Username and password fields can be cleared by switching the 'Clear' switch to the right. "
                      + "Linux Manager Application also gives user the ability to add or remove a group from "
                      + "its Linux Desktop. Last, but not least the user can check various information regarding "
                      + "its Linux Desktop, like for example current real users, real groups, Firewall configuration "
                      + "tables [Filter | RAW | Security | Mangle] can be printed out and see the applied rules for traffic. "
                      + "Furthermore, Routing table and Network Interfaces can be checked out. \n\t\tHave fun!"
                wrapMode: Label.Wrap
            }
        }
    }

    // A color dialog to choose Manager Application background color
    //
    ColorDialog {
        id: colorDialogId
        title: "Choose Manager Application background color"
        visible: false
        onAccepted: {
            // choose a color opening systems default application
            managerBackgroundColorId.color = colorDialogId.color
        }
    }

    // Add the ToolBar Actions regarding Manager Application
    //
    header: ToolBar {
        Row {
            anchors.fill: parent
            ToolButton {
                action: aboutManagerId
            }
            ToolButton {
                action: aboutAuthorId
            }
            ToolButton {
                action: quitManagerAppId
            }
        }
    }

    // change the background color of application window using a rectangle
    //
    background: Rectangle {
        id: managerBackgroundColorId
        color: "lightblue"
    }
    font: {font.family="Arial"; font.pointSize=9;}

    // quit() with ESC
    //
    Item {
        id: quitItemId
        // Attention: without focus property enabled it is not going to work!!!
        //
        focus: true
        Keys.onPressed: {
            if(event.key === Qt.Key_Escape) {
                // console.log("Escape key is pressed ... quit() is called upon app ... ciao !!!")
                Qt.quit()
            }
        }
    }

    // Declare three global vars for username, pass(1) and pass(2)
    //
    property string username: ""
    property string passwd_une: ""
    property string passwd_deux: ""
    // Declare variables for the new user that is about to be created
    //
    property string new_username: ""
    property string new_user_realname: ""
    property string new_user_group: ""
    property string new_user_id: ""
    property string new_user_shell: ""
    property string new_user_encr_password: ""

    // A few variables for the groups addition|removal|rename functionality
    //
    property string new_group_name: ""
    property string new_group_id: ""
    property string existing_group_new_name: ""

    // The Firewall Table that will be chosen by the user from the respective ComboBox
    // in the System & Networking Section related Actions | Default value: "filter" table
    //
    property string firewallTable: "filter"

    GroupBox {
        x: 5; y: 5
        title: qsTr("Credentials")
        id: credsGroupBoxId
        font.bold: true
        // this groupbox refers to operator credentials, i.e. username/password
        // and a submit button in order to store these values
        //
        Column {
            // Row element container for username fields
            //
            Row {
                id: usernameRowId
                spacing: 10
                width: 300
                bottomPadding: 5
                // A label for username
                Label {
                    text: "Type username            : "
                    id: usernameLabelId
                    color: "gray"
                }

                // A text field to enter operator's username
                TextField {
                    id:usernameTextFieldId
                    width: 100
                    placeholderText: "username"
                    placeholderTextColor: "lightgray"
                    ToolTip.delay: 500
                    ToolTip.timeout: 2000
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("Please type your username")

                    echoMode: TextInput.Normal
                    font: Qt.font({family: "Helvetica", pointSize: 9, italic: true})
                    onEditingFinished: {
                        username = text
                        // console.log("username: " + username)
                    }
                    // remove border color from the text field
                    background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 20
                        border.color: "transparent"
                    }
                }
            }
            // Row element containing password fields #1st time
            //
            Row {
                id: passwdUneRowId
                spacing: 10
                width: 300
                bottomPadding: 5
                // A label for password
                Label {
                    text: "Type password            : "
                    id: passwordLabel1Id
                    color: "gray"
                }
                // A text field to enter operator's password | time #1
                TextField {
                    id: passwordTextField1Id
                    placeholderText: "password"
                    placeholderTextColor: "lightgray"
                    ToolTip.delay: 500
                    ToolTip.timeout: 2000
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("Please type your password")

                    // password should not be visible when typed
                    echoMode: TextInput.Password
                    font: Qt.font({family: "Helvetica", pointSize: 9, italic: true})
                    onEditingFinished: {
                        passwd_une = text
                    }
                    // remove border color from the text field
                    background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 20
                        border.color: "transparent"
                    }
                }
            }
            // Row element containing password fields #2nd time
            Row {
                //
                id: passwdDeuxRowId
                spacing: 10
                width: 300
                bottomPadding: 5
                // A label for password re-entry
                Label {
                    text: "Retype password        : "
                    id: passwordLabel2Id
                    color: "gray"
                }
                // A text field to enter operator's password | time #2
                TextField {
                    id: passwordTextField2Id
                    placeholderText: "password"
                    placeholderTextColor: "lightgray"
                    ToolTip.delay: 500
                    ToolTip.timeout: 2000
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("Please type your password again")

                    // password should not be visible when typed
                    echoMode: TextInput.Password
                    font: Qt.font({family: "Helvetica", pointSize: 9, italic: true})
                    onEditingFinished: {
                        passwd_deux = text
                    }
                    // remove border color from the text field
                    background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 20
                        border.color: "transparent"
                    }
                }
            }
            // A Row containing CheckBox | when checked passwords become visible
            //
            Row {
                spacing: 10
                width: 200
                bottomPadding: 10
                CheckBox {
                    id: showPasswdsCheckBoxId
                    checked: false
                    text: qsTr("Show passwords")
                    // when this checkBos is checked --> make passwords text fields visible
                    //
                    onClicked: {
                        if(checked===true) {
                            // make password #1/2 textInput field visible
                            passwordTextField1Id.echoMode = TextInput.Normal
                            passwordTextField2Id.echoMode = TextInput.Normal
                        } else {
                            // make password #1/2 textInput field invisible
                            passwordTextField1Id.echoMode = TextInput.Password
                            passwordTextField2Id.echoMode = TextInput.Password
                        }
                    }
                }
            }

            // this is a MessageDialog to be called in various situations
            //
            MessageDialog {
                id: genericMessageDialog
                title: qsTr("WARNING")
                text: "This is the default warning message. Should be changed when Dialog is called."
            }

            // A DelayButton to 'Submit' operator's username and password
            // Should only be accepted IF and only IF password===retypeOfPassword
            /// and username === getenv("USER")
            Row {
                spacing: 10
                width: 300
                bottomPadding: 10
                DelayButton {
                    id: submitButtonId
                    property bool activated: false
                    // When the 'Submit' Button is pressed for '1.5' seconds, then it is activated and going on ...
                    delay: 1000
                    text: "Submit Credentials"
                    ToolTip.delay: 500
                    ToolTip.timeout: 1500
                    ToolTip.text: qsTr("Press this Button until it is activated.\nThen press it to proceed!")
                    ToolTip.visible: hovered
                    onActivated: {
                        activated = true
                    }
                    onPressed: {
                        if(activated === true) {
                            // TODO: Remove it at the end of this Manager Application
                            ///////////////////////////////////
                            if(passwd_une === "" || passwd_deux === "" || username === "") {
                                genericMessageDialog.title = "CREDENTIALS WARNING"
                                genericMessageDialog.text = "Please provide your username and password and try again!"
                                genericMessageDialog.open()
                            } else {

                                if(passwd_une !== passwd_deux) {
                                    genericMessageDialog.title = "PASSWORDS ERROR"
                                    genericMessageDialog.text = "Passwords do not match. Type them correctly and try again!"
                                    genericMessageDialog.open()
                                } else {
                                    genericMessageDialog.title = "CREDENTIALS INFOMRATION"
                                    genericMessageDialog.text = "Credentials provided. Continuing procedure .."
                                    genericMessageDialog.open()
                                    // pass entered username from the TextField to my C++ code
                                    //
                                    myManager.setUsername(username)
                                    // Same for password
                                    //
                                    myManager.setPassword(passwd_une)
                                    // Last action -> compare current username into system with the entered username in the TextField
                                    //
                                    if(myManager.compare_usernames() === false) {
                                        genericMessageDialog.title = "CURRENT USER ERROR"
                                        genericMessageDialog.text = "Please provide correct current username and try again!"
                                        genericMessageDialog.open()
                                        // If username is fake -> then swipe switch to the right and clean up text fields
                                        clearSwitchId.checked = true
                                        clearSwitchId.checked = false
                                    }
                                }
                            }
                        }
                    }
                    // align 'Submit' button in the center of the last Row
                    //
                    anchors.horizontalCenter: Qt.AlignHCenter
                    opacity: .75
                }
            }

            // Create a Switch to Clear Credentials Fields if the operator wants to
            //
            Switch {
                id: clearSwitchId
                text: "Clear Fields"
                checked: false
                ToolTip.delay: 500
                ToolTip.timeout: 1500
                ToolTip.text: qsTr("Clean up Credentials Text Fields!")
                ToolTip.visible: hovered
                onCheckedChanged: {
                    if(checked === true) {
                        usernameTextFieldId.text = ""
                        passwordTextField1Id.text = ""
                        passwordTextField2Id.text = ""
                        // Call c++ function that cleans up username/password Qstring variables
                        //
                        myManager.clearCredentials()
                    }
                }
            }


        }
    }

    /*                        END OF Credentials GroupBox                   */
    GroupBox {
        id: userMgmntId
        title: qsTr("User Management")
        font: Qt.font({family: "Helvetica", pointSize: 9, italic: true, bold: true})
        spacing: 5
        anchors.top: credsGroupBoxId.bottom
        width: credsGroupBoxId.width
        height: 400
        x: 5
        ColumnLayout {
            id: userMgmntColumnId
            Row {
                width: parent.width
                bottomPadding: 10
                // new user username Column
                // label & TextField
                Label {
                    text: "User Name          "
                    id: newUsernameLabelId
                }
                TextField {
                    id: newUsernameTextFieldId
                    width: userMgmntId.width - newUsernameLabelId.width - 14
                    // remove border color from the text field
                    background: Rectangle {
                        border.color: "transparent"
                    }
                    placeholderText: "      new user username"
                    placeholderTextColor: "lightgray"
                    ToolTip.delay: 500
                    ToolTip.timeout: 2000
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("New user to be created username")
                    onEditingFinished: {
                        new_username = newUsernameTextFieldId.text
                    }
                }
            }
            Row {
                width: parent.width
                bottomPadding: 10
                // new user real name Column
                // label & TextField
                Label {
                    text: "User Real Name     "
                    id: newUserRealnameLabelId
                }
                TextField {
                    id: newUserRealnameTextFieldId
                    width: userMgmntId.width - newUserRealnameLabelId.width - 14
                    // remove border color from the text field
                    background: Rectangle {
                        border.color: "transparent"
                    }
                    placeholderText: "  new user real name"
                    placeholderTextColor: "lightgray"
                    ToolTip.delay: 500
                    ToolTip.timeout: 2000
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("New user to be created real name")
                    onEditingFinished: {
                        new_user_realname = newUserRealnameTextFieldId.text
                    }
                }
            }
            Row {
                width: parent.width
                bottomPadding: 10
                // new user group Column
                // label & TextField
                Label {
                    text: "User Group Name    "
                    id: newUserGroupLabelId
                }
                TextField {
                    id: newUserGroupTextFieldId
                    width: userMgmntId.width - newUserGroupLabelId.width - 14
                    // remove border color from the text field
                    background: Rectangle {
                        border.color: "transparent"
                    }
                    placeholderText: "new user's group"
                    placeholderTextColor: "lightgray"
                    ToolTip.delay: 500
                    ToolTip.timeout: 2000
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("New user to be created group")
                    onEditingFinished: {
                        new_user_group = newUserGroupTextFieldId.text
                    }
                }
            }
            Row {
                width: parent.width
                bottomPadding: 10
                // new user ID Column
                // label & TextField
                Label {
                    text: "User ID            "
                    id: newUserIDLabelId
                }
                TextField {
                    id: newUserIDTextFieldId
                    width: userMgmntId.width - newUserIDLabelId.width - 14
                    // remove border color from the text field
                    background: Rectangle {
                        border.color: "transparent"
                    }
                    placeholderText: "          new user's ID"
                    placeholderTextColor: "lightgray"
                    ToolTip.delay: 500
                    ToolTip.timeout: 2000
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("New user to be created ID")
                    onEditingFinished: {
                        new_user_id = newUserIDTextFieldId.text
                    }
                }
            }
            Row {
                width: parent.width
                bottomPadding: 10
                // new user Shell Column
                // label & TextField
                Label {
                    text: "User Shell         "
                    id: newUserShellLabelId
                }
                TextField {
                    id: newUserShellTextFieldId
                    width: userMgmntId.width - newUserShellLabelId.width - 14
                    // remove border color from the text field
                    background: Rectangle {
                        border.color: "transparent"
                    }
                    placeholderText: "        new user's shell"
                    placeholderTextColor: "lightgray"
                    ToolTip.delay: 500
                    ToolTip.timeout: 2000
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("New user to be created shell")
                    onEditingFinished: {
                        new_user_shell = newUserShellTextFieldId.text
                    }
                }
            }
            Row {
                width: parent.width
                bottomPadding: 10
                // new user Password label & TextField
                //
                Label {
                    text: "User Password     "
                    id: newUserPasswordLabelId
                }
                TextField {
                    id: newUserPasswordTextFieldId
                    width: userMgmntId.width - newUserPasswordLabelId.width - 14
                    // remove border color from the text field
                    background: Rectangle {
                        border.color: "transparent"
                    }
                    echoMode: TextInput.Password
                    placeholderText: "    new user's password"
                    placeholderTextColor: "lightgray"
                    ToolTip.delay: 500
                    ToolTip.timeout: 2000
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("New user to be created password")
                    onEditingFinished: {
                        new_user_encr_password = newUserPasswordTextFieldId.text
                    }
                }
            }
            Row {
                width: parent.width
                bottomPadding: 10
                // Show passwords CheckBox Column
                Switch {
                    id: showNewUserPasswdsSwitchId
                    text: "Show Password"
                    checked: false
                    onCheckedChanged: {
                        if(checked === true) {
                            newUserPasswordTextFieldId.echoMode = TextInput.Normal
                        } else {
                            newUserPasswordTextFieldId.echoMode = TextInput.Password
                        }
                    }
                }
            }
            Row {
                width: parent.width
                bottomPadding: 10
                // Clear all User Management Fields
                Switch {
                    id: clearUserMgmntSwitchId
                    text: qsTr("Clear User Management Text Fields")
                    checked: false
                    onCheckedChanged: {
                        if(checked === true) {
                            newUsernameTextFieldId.text = ""
                            newUserGroupTextFieldId.text = ""
                            newUserRealnameTextFieldId.text = ""
                            newUserIDTextFieldId.text = ""
                            newUserShellTextFieldId.text = ""
                            newUserPasswordTextFieldId.text = ""
                        }
                    }
                }
            }

            Row {
                bottomPadding: 10
                width: parent.width
                // new user Confirm CheckBox Column
                CheckBox {
                    text: "Confirm above elements"
                    checked: false
                    // when clicked, check if username or password of the new user is empty !
                    // IF empty , do not proceed
                    onClicked: {
                        if(checked === true) {
                            if(new_username === "" || new_user_encr_password === "") {
                                genericMessageDialog.text = "New user to be created username and password should be both specified! Please enter them and try again!"
                                genericMessageDialog.title = "CONFIRM  ACTION  ERROR"
                                genericMessageDialog.open()
                            } else {
                                // call c++ code to pass string values from QML elements (TExtFieds) to c++ QString variables
                                // uername - real name (comment) - group - ID - user shell - password
                                //
                                myManager.setNew_username(new_username)
                                myManager.setNew_user_realname(new_user_realname)
                                myManager.setNew_user_group(new_user_group)
                                myManager.setNew_user_id(new_user_id)
                                myManager.setNew_user_shell(new_user_shell)
                                myManager.setNew_user_encr_password(new_user_encr_password)
                            }
                        }
                    }
                }
            }
            Row {
                bottomPadding: 10
                width: parent.width
                // new user 'CREATE' PushButton && 'REMOVE' DelayButton Row
                RowLayout {
                    Button {
                        id: createNewUserButtonId
                        text: qsTr("CREATE")
                        ToolTip.delay: 500
                        ToolTip.timeout: 1500
                        ToolTip.text: qsTr("Create a new user!")
                        ToolTip.visible: hovered
                        onClicked: {
                            // check if 'Submit Credentials' is checked in order to enter this CREATE user procedure
                            //
                            if(myManager.getUsername()==="" && myManager.getPassword()==="") {
                                // display a message that credentials should be entered
                                genericMessageDialog.text = "Credentials should be provided to create a user!"
                                genericMessageDialog.title = "CREATE  ACTION  ERROR"
                                genericMessageDialog.open()
                            } else {

                                // Next check: If the new user username & password 'at least' are not provided, then abort
                                // DIsplay a message that the new user information should be provided
                                //
                                if(myManager.getNew_username()==="" || myManager.getNew_user_encr_password()==="") {
                                    genericMessageDialog.text = "At least provide new user's username and password to create a new user!"
                                    genericMessageDialog.title = "CREATE  ACTION  ERROR"
                                    genericMessageDialog.open()
                                } else {

                                    if(myManager.is_username_valid() === true) {
                                        if(myManager.user_exists() === false) {
                                            // if the user does not exist , then create him
                                            if(myManager.adduser() === true) {
                                                //console.log("User: " + myManager.getNew_username() + " was succesfully created!")
                                                genericMessageDialog.text = qsTr("User: " + myManager.getNew_username() + " was succesfully created!")
                                                genericMessageDialog.title = "CREATE  ACTION  INFO"
                                                genericMessageDialog.open()
                                            } else {
                                                genericMessageDialog.text = qsTr("User: " + myManager.getNew_username() + " failed to be created! Please try again!")
                                                genericMessageDialog.title = "CREATE  ACTION  ERROR"
                                                genericMessageDialog.open()
                                            }
                                        }
                                    } else {
                                        genericMessageDialog.text = qsTr("User: " + myManager.getNew_username() + " is invalid. Try with another!")
                                        genericMessageDialog.title = "CREATE  ACTION  ERROR"
                                        genericMessageDialog.open()
                                    }
                                }

                            }



                        }
                    }
                    DelayButton {
                        id: removeUserDelayButtonId
                        property bool userdelActivate: false
                        delay: 1000
                        text: qsTr("REMOVE")
                        anchors.left: parent.right
                        ToolTip.delay: 500
                        ToolTip.timeout: 1500
                        ToolTip.text: qsTr("Remove a user from your Linux desktop!")
                        ToolTip.visible: hovered
                        onActivated: {
                            userdelActivate = true
                        }

                        onClicked: {

                            if(new_username==="" && new_user_encr_password==="") {
                                genericMessageDialog.text = "Please provide the user's username to remove"
                                genericMessageDialog.title = "REMOVE USER ERROR"
                                genericMessageDialog.open()
                            } else {

                                if(userdelActivate===true) {
                                    if(myManager.user_exists() === false) {
                                        genericMessageDialog.text = "Cannot remove user that does not exist in the system."
                                        genericMessageDialog.title = "REMOVE ACTION ERROR"
                                        genericMessageDialog.open()
                                    } else {
                                        if(myManager.deluser() === true && myManager.del_user_home()) {
                                            genericMessageDialog.text = qsTr("Just deleted user: " + new_username + " from your system!")
                                            genericMessageDialog.title = "REMOVE ACTION ERROR"
                                            genericMessageDialog.open()
                                        }
                                    }
                                } else {
                                    genericMessageDialog.text = "Please activate the REMOVE DelayButton in order to continue!"
                                    genericMessageDialog.title = "REMOVE ACTION ERROR"
                                    genericMessageDialog.open()
                                }
                            }

                        }
                    }
                }
            }
        }
    }

    /*                      SYSTEM & NETWORKING INFOMRATION                     */
    GroupBox {
        id: systemInfoGroupBox
        title: qsTr("System & Networking Information")
        x: 5
        width: credsGroupBoxId.width
        height: userMgmntId.height - 70
        anchors.left: credsGroupBoxId.right
        anchors.top: rootElementId.top
        font: Qt.font({family: "Helvetica", pointSize: 9, italic: true, bold: true})
        spacing: 5
        leftInset: 20
        // ColumnLayout for various checkBoxes
        //
        ColumnLayout {
            id: systemInfoColumnId
            anchors.left: parent.left
            Row {
                bottomPadding: 10
                leftPadding: 20
                // Show real system users
                CheckBox {
                    id: catUsersId
                    text: "Show real users"
                    checked: false
                    onClicked: {
                        if(checked===true) {
                            // capture the real users calling appropriate c++ function
                            genericMessageDialog.text = qsTr(myManager.cat_users())
                            genericMessageDialog.title = "Real Users"
                            genericMessageDialog.open()
                            catUsersId.checked = false
                        }
                    }
                }
            }
            Row {
                bottomPadding: 10
                leftPadding: 20
                // Show real groups
                CheckBox {
                    id: catGroupsId
                    text: "Show real groups"
                    onClicked: {
                        if(checked===true) {
                            // capture the real groups calling appropriate c++ function
                            genericMessageDialog.text = qsTr(myManager.cat_groups())
                            genericMessageDialog.title = "Real Groups"
                            genericMessageDialog.open()
                            catGroupsId.checked = false
                        }
                    }
                }
            }
            Row {
                bottomPadding: 10
                leftPadding: 20
                // show available shells
                CheckBox {
                    id: catShells
                    text: "Show available system shells"
                    onClicked: {
                        if(checked===true) {
                            // capture the system shells calling appropriate c++ function
                            genericMessageDialog.text = qsTr(myManager.cat_shells())
                            genericMessageDialog.title = "Available System Shells"
                            genericMessageDialog.open()
                            catShells.checked = false
                        }
                    }
                }
            }
            Row {
                bottomPadding: 10
                leftPadding: 20
                // Show Networking interfaces
                CheckBox {
                    id: interfacesId
                    text: "Show Network Interfaces"
                    onClicked: {
                        if(checked===true) {
                            // capture Network Interfaces calling appropriate c++ function
                            genericMessageDialog.text = qsTr(myManager.ifconfig())
                            genericMessageDialog.title = "Network Interfaces"
                            genericMessageDialog.open()
                            interfacesId.checked = false
                        }
                    }
                }
            }

            Row {
                bottomPadding: 10
                leftPadding: 20
                // Show Routing Table
                CheckBox {
                    id: routingTableCheckBox
                    text: "Show Routing Table"
                    onClicked: {
                        if(checked===true) {
                            genericMessageDialog.text = qsTr(myManager.netstat())
                            genericMessageDialog.title = "Routing Table"
                            genericMessageDialog.open()
                            routingTableCheckBox.checked = false
                        }
                    }
                }
            }

            Row {
                bottomPadding: 10
                leftPadding: 20
                // Show Routing table
                CheckBox {
                    id: firewall_4Id
                    text: "Show IPv4 Firewall Configuration"
                    onClicked: {
                        if(username==="" || passwordTextField1Id.text==="") {
                            //
                            genericMessageDialog.text = qsTr("Please provide your username & password to check IPv4 Firewall Configuration!")
                            genericMessageDialog.title = "WARNING"
                            genericMessageDialog.open()
                            firewall_4Id.checked = false
                        } else {
                            /////////////////////////////////  IPv4 /////////////////////////
                            genericMessageDialog.text = qsTr(myManager.ip4tables() )
                            genericMessageDialog.title = qsTr("IPv4 Firewall Configuration " + myManager.getTable() + " Table")
                            genericMessageDialog.open()
                            firewall_4Id.checked = false
                        }
                    }
                }
            }
            Row {
                bottomPadding: 10
                leftPadding: 20
                // Show Routing table
                CheckBox {
                    id: firewall_6Id
                    text: "Show IPv6 Firewall Configuration"
                    onClicked: {
                        if(username==="" || passwordTextField1Id.text==="") {
                            //
                            genericMessageDialog.text = qsTr("Please provide your username & password to check IPv6 Firewall Configuration!")
                            genericMessageDialog.title = "WARNING"
                            genericMessageDialog.open()
                            firewall_6Id.checked = false
                        } else {
                            /////////////////////////////////  IPv6 /////////////////////////
                            genericMessageDialog.text = qsTr(myManager.ip6tables() )
                            genericMessageDialog.title = qsTr("IPv6 Firewall Configuration " + myManager.getTable() + " Table")
                            genericMessageDialog.open()
                            firewall_6Id.checked = false
                        }
                    }
                }
            }
            Row {
                bottomPadding: 10
                leftPadding: 20
                // This ComboBox is the Table choice ::
                // Filter | RAW | Security | Mangle
                //
                ComboBox {
                    id: firewallComboBoxId
                    textRole: "choice"
                    ToolTip.delay: 500
                    ToolTip.timeout: 1500
                    ToolTip.text: qsTr("Please choose one Table to show its IPv4 or IPv6 Firewall Configuration!\n\t[Filter | Raw | Security | Mangle]")
                    ToolTip.visible: hovered
                    model: ListModel {
                        id: tablesModel

                        ListElement { choice: "Filter"; TableName: "filter" }
                        ListElement { choice: "Security"; TableName: "security" }
                        ListElement { choice: "Raw"; TableName: "raw" }
                        ListElement { choice: "Mangle"; TableName: "mangle" }
                    }

                    onActivated: {
                        // capture the new firewall table that the user has chosen
                        // ATTENTION :: ACHTUNG HERE ::
                        //
                        firewallTable = tablesModel.get(firewallComboBoxId.currentIndex).TableName
                        // Update the firewall Table in the c++ code
                        //
                        myManager.setTable(firewallTable)
                    }
                }
            }
        }
    }


    /*                      GROUP ACTIONS SECTION                               */
    GroupBox {
        id: groupMgmntId
        title: "Group Management"
        x: 5
        width: systemInfoGroupBox.width
        height: rootElementId.height - systemInfoGroupBox.height - 150
        anchors.bottom: userMgmntId.bottom
        anchors.right: systemInfoGroupBox.right
        font: Qt.font({family: "Helvetica", pointSize: 9, italic: true, bold: true})
        spacing: 5
        leftInset: 20
        ColumnLayout {
            id: groupColumnId
            // New group name
            Row {
                width: parent.width
                bottomPadding: 10
                leftPadding: 20
                // new user username Column
                // label & TextField
                Label {
                    text: "Group Name          "
                    id: newGroupNameLabelId
                }
                TextField {
                    id: newGroupNameTextFieldId
                    width: groupMgmntId.width - newGroupNameLabelId.width - 30
                    // remove border color from the text field
                    background: Rectangle {
                        border.color: "transparent"
                    }
                    placeholderText: "      new group name "
                    placeholderTextColor: "lightgray"
                    ToolTip.delay: 500
                    ToolTip.timeout: 2000
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("New group to be created name")
                    onEditingFinished: {
                        new_group_name = newGroupNameTextFieldId.text
                    }
                }
            }
            Row {
                // New group ID
                width: parent.width
                bottomPadding: 10
                leftPadding: 20
                // new user username Column
                // label & TextField
                Label {
                    text: "Group ID          "
                    id: newGroupIDLabelId
                }
                TextField {
                    id: newGroupIDTextFieldId
                    width: groupMgmntId.width - newGroupIDLabelId.width - 30
                    // remove border color from the text field
                    background: Rectangle {
                        border.color: "transparent"
                    }
                    placeholderText: "             new group ID (GID) "
                    placeholderTextColor: "lightgray"
                    ToolTip.delay: 500
                    ToolTip.timeout: 2000
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("New group to be created ID (GID)")
                    onEditingFinished: {
                        new_group_id = newGroupIDTextFieldId.text
                    }
                }
            }
            Row {
                // Existing group new name in order to rename it
                width: parent.width
                bottomPadding: 20
                leftPadding: 20
                // new user username Column
                // label & TextField
                Label {
                    text: "Group New Name       "
                    id: newGroupNewNameLabelId
                }
                TextField {
                    id: newGroupNewNameTextFieldId
                    width: groupMgmntId.width - newGroupNewNameLabelId.width - 30
                    // remove border color from the text field
                    background: Rectangle {
                        border.color: "transparent"
                    }
                    placeholderText: "  group new name "
                    placeholderTextColor: "lightgray"
                    ToolTip.delay: 500
                    ToolTip.timeout: 2000
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("Group to be renamed new name")
                    onEditingFinished: {
                        existing_group_new_name = newGroupNewNameTextFieldId.text
                    }
                }
            }
            Row {
                // CLear above group related fields
                Switch {
                    id: clearGroupSwitchId
                    text: "Clear Group Management Text Fields"
                    checked: false
                    leftPadding: 20
                    bottomPadding: 10
                    onCheckedChanged: {
                        if(checked===true) {
                            newGroupNameTextFieldId.text = ""
                            newGroupIDTextFieldId.text = ""
                            newGroupNewNameTextFieldId.text = ""
                        }
                    }
                }
            }
            Row {
                // Confirm in order to proceed
                CheckBox {
                    id: groupCheckBoxId
                    text: "Confirm Group Elements"
                    checked: false
                    leftPadding: 20
                    bottomPadding: 10
                    onClicked: {
                        if(checked===true) {
                            console.log("Checked groupbox confirm checkBox ...")
                            if(new_group_name==="") {
                                genericMessageDialog.text = "Please provide group name and then confirm elements."
                                genericMessageDialog.title = "WARNING"
                                genericMessageDialog.open()
                                groupCheckBoxId.checked = false
                            } else {
                                // set group name, group id and group new name if it is typed from the user
                                // feed C++ code with QML properties from TextFields from GrouBox elements ..
                                //
                                myManager.setGid(new_group_id)
                                myManager.setGroupname(new_group_name)
                                myManager.setNew_groupname(existing_group_new_name)
                                console.log("GroupName: " + new_group_name + " -- " + myManager.getGroupname())
                                console.log("Group New Name: " + existing_group_new_name + " -- " + myManager.getNew_groupname())
                            }
                        }
                    }
                }
            }
            RowLayout {
                // Three buttons : [1] CREATE [2] RENAME [3] REMOVE
                id: groupRowLayoutId
                Button {
                    id: createGroupId
                    text: "     CREATE"
                    leftInset: 20
                    ToolTip.delay: 500
                    ToolTip.timeout: 1500
                    ToolTip.text: qsTr("Create a new group in your Linux Desktop!")
                    ToolTip.visible: hovered
                    onClicked: {
                        if(username==="" || passwd_une==="") {
                            genericMessageDialog.text = "Please provide username and password and try again."
                            genericMessageDialog.title = "ERROR"
                            genericMessageDialog.open()
                        } else {
                            //if the group exists cannot create it
                            if(myManager.group_exists()===false) {
                                // if the group does not exist, I can create it
                                if(myManager.groupadd()===true) {
                                    genericMessageDialog.text = qsTr("New group: " + myManager.getGroupname() + " succesfully created!")
                                    genericMessageDialog.title = "SUCCESS"
                                    genericMessageDialog.open()
                                } else {
                                    genericMessageDialog.text = qsTr("New group: " + myManager.getGroupname() + " FAILED to be created!")
                                    genericMessageDialog.title = "GROUP CREATION FAILURE"
                                    genericMessageDialog.open()
                                }
                            } else {
                                genericMessageDialog.text = qsTr("The group: " + myManager.getGroupname() + " already exists. CANNOT create it. Try another one!")
                                genericMessageDialog.title = "GROUP CREATION FAILURE"
                                genericMessageDialog.open()
                            }
                        }
                    }
                }
                Button {
                    id: renameGroupId
                    text: "RENAME"
                    leftInset: 5
                    ToolTip.delay: 500
                    ToolTip.timeout: 1500
                    ToolTip.text: qsTr("Rename an existing group in your Linux Desktop!")
                    ToolTip.visible: hovered
                    onClicked: {
                        //
                        if(username==="" || passwd_une==="") {
                            genericMessageDialog.text = "Please provide username and password and try again."
                            genericMessageDialog.title = "ERROR"
                            genericMessageDialog.open()
                        } else {
                            //if the group does not exist cannot rename it
                            if(myManager.group_exists()===true) {
                                // if the group does not exist, I can create it
                                if(myManager.groupmod()===true) {
                                    genericMessageDialog.text = qsTr("The group: " + myManager.getGroupname() + " succesfully renamed!")
                                    genericMessageDialog.title = "SUCCESS"
                                    genericMessageDialog.open()
                                } else {
                                    genericMessageDialog.text = qsTr("The group: " + myManager.getGroupname() + " FAILED to be renamed!")
                                    genericMessageDialog.title = "GROUP CREATION FAILURE"
                                    genericMessageDialog.open()
                                }
                            } else {
                                genericMessageDialog.text = qsTr("The group: " + myManager.getGroupname() + " does not exist. CANNOT rename it. Try another one!")
                                genericMessageDialog.title = "GROUP CREATION FAILURE"
                                genericMessageDialog.open()
                            }
                        }
                    }
                }
                Button {
                    id: removeGroupId
                    text: "REMOVE"
                    leftInset: 5
                    ToolTip.delay: 500
                    ToolTip.timeout: 1500
                    ToolTip.text: qsTr("Remove a group from your Linux Dekstop!")
                    ToolTip.visible: hovered
                    onClicked: {
                        if(username==="" || passwd_une==="") {
                            genericMessageDialog.text = "Please provide username and password and try again."
                            genericMessageDialog.title = "ERROR"
                            genericMessageDialog.open()
                        } else {
                            //if the group does not exists cannot delete it
                            if(myManager.group_exists()===true) {
                                // if the group does not exist, I can create it
                                if(myManager.groupdel()===true) {
                                    genericMessageDialog.text = qsTr("Group: " + myManager.getGroupname() + " succesfully removed from your system!")
                                    genericMessageDialog.title = "SUCCESS"
                                    genericMessageDialog.open()
                                } else {
                                    genericMessageDialog.text = qsTr("Group: " + myManager.getGroupname() + " FAILED to be created!")
                                    genericMessageDialog.title = "GROUP REMOVAL FAILURE"
                                    genericMessageDialog.open()
                                }
                            } else {
                                genericMessageDialog.text = qsTr("The group: " + myManager.getGroupname() + " does not exist. CANNOT delete it. Try another one!")
                                genericMessageDialog.title = "GROUP REMOVAL FAILURE"
                                genericMessageDialog.open()
                            }
                        }
                    }
                }
            }
        }
    }
}
