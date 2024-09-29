#!/bin/bash

# Exercise:
#Create 3 groups – admin, support & engineering and add the admin group to sudoers.
#Create a user in each of the groups.
#Generate SSH keys for the user in the admin group.

#Instruction:
#Submit the contents of /etc/passwd, /etc/group, /etc/sudoers

#
#

# Function to create groups
create_groups() {
    echo "Comment: Creating groups"
    echo "-"    
    sudo groupadd testadmin
    sudo groupadd testsupport
    sudo groupadd testengineering
}

#
# Function to create users and add them to respective groups (no passwords required)
create_users() {
    echo "-"
    echo "Comment: Creating users and adding them to respective groups"
    echo "-"
    sudo useradd -m -G testadmin testmariam_admin
    sudo useradd -m -G testsupport testmariam_support
    sudo useradd -m -G testengineering testmariam_engineering
}

# Ensure testadmin group is a sudoer by adding it to /etc/sudoers
add_testadmin_to_sudoers() {
    echo "-"
    echo "Granting sudo privileges to the required user"
    echo "-"
    
    # Add the admin group to the sudoers file if it's not already there
    sudo grep '^%testadmin' /etc/sudoers > /dev/null
    if [ $? -ne 0 ]; then
        echo "%admin ALL=(ALL:ALL) ALL" | sudo EDITOR="tee -a" visudo
        echo "The admin group has been added to the sudoers file."
    else
        echo "The testadmin group already has sudo privileges."
    fi
}

# Function to generate SSH keys for testmariam_admin
generate_ssh_keys() {
    echo "-"
    echo "Generating SSH keys for admin user"
    echo "-"
    sudo -u testmariam_admin ssh-keygen -t rsa -b 4096 -f /home/testmariam_admin/.ssh/id_rsa -N "" -q
    echo "SSH keys generated for testmariam_admin at /home/testmariam_admin/.ssh/"
    echo "-"
}

# Function to list RSA files
list_rsa_files() {
    echo "Listing RSA keys for testmariam_admin"
    if [ -d /home/testmariam_admin/.ssh ]; then
        # Switch to testmariam_admin to avoid permission issues
        sudo -u testmariam_admin ls -al /home/testmariam_admin/.ssh
    else
        echo "No RSA key directory found for testmariam_admin"
    fi
}


# Function to display results (contents of /etc/passwd, /etc/group, /etc/sudoers)
show_results() {
    echo "Contents of /etc/group"
    echo "-"
    cat /etc/group | grep 'testadmin\|testsupport\|testengineering'
    echo "-"
    echo "Contents of /etc/passwd"
    cat /etc/passwd | grep 'testmariam_admin\|testmariam_support\|testmariam_engineering'
    echo "-"
    echo "Sudoers Entry for admin group"
    sudo cat /etc/sudoers | grep testadmin

    # List RSA key files for testmariam_admin
    list_rsa_files
}

# Function to delete the users and groups created
delete_accounts() {
    echo "Deleting users: testmariam_admin, testmariam_support, testmariam_engineering"
    sudo userdel -r testmariam_admin
    sudo userdel -r testmariam_support
    sudo userdel -r testmariam_engineering

    echo "Deleting groups: testadmin, testsupport, testengineering"
    sudo groupdel testadmin
    sudo groupdel testsupport
    sudo groupdel testengineering

    echo "Removing testadmin group from sudoers"
    sudo sed -i '/^%testadmin/d' /etc/sudoers

    echo "Accounts and groups deleted."
}

# Main function to run the assignment
run_assignment() {
    create_groups
    create_users
    add_testadmin_to_sudoers  # Add testadmin group to sudoers
    generate_ssh_keys
    show_results
}

# Function to display the menu and prompt user for choice
show_menu() {
    echo "Please choose an option:"
    echo "1) Run exercise"
    echo "2) Delete accounts"
    echo "3) Exit"
    echo -n "Enter your choice: "
    read choice

    case $choice in
        1)
            run_assignment
            ;;
        2)
            delete_accounts
            ;;
        3)
            echo "Exiting."
            exit 0
            ;;
        *)
            echo "Invalid choice, please select 1, 2, or 3."
            show_menu
            ;;
    esac
}

# Run the menu function
show_menu
