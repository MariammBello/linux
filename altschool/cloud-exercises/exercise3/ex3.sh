#!/bin/bash

Exercise() {
    echo "-"
    echo "Exercise"
    echo "-"
    echo "1. Create 3 groups – admin, support & engineering and add the admin group to sudoers."
    echo "2. Create a user in each of the groups."
    echo "3. Generate SSH keys for the user in the admin group."
    echo "-"
    echo "Instruction:"
    echo "Submit the contents of /etc/passwd, /etc/group, /etc/sudoers"
}

# Function to create groups
create_groups() {
    echo "-"    
    sudo groupadd group_admin
    sudo groupadd group_support
    sudo groupadd group_engineering
}




#Function to show created groups
show_groups() {
   echo "-"
   echo "Creating groups"
   echo "-"
   cat  /etc/group | grep 'group_admin\|group_support\|group_engineering'

}
#
# Function to create users and add them to respective groups (no passwords required)
create_users() {
    echo "-"
    sudo useradd -m -G group_admin user_admin
    sudo useradd -m -G group_support user_support
    sudo useradd -m -G group_engineering user_engineering
}

exclude_passwd() {
    sudo passwd -d user_admin
    sudo passwd -d user_support
    sudo passwd -d user_engineering
}

show_users() {
    echo "Creating users and adding them to their respective groups"
    echo "-"
    cat /etc/passwd | grep 'user_admin\|user_support\|user_engineering'

}

# Ensure group is a sudoer by adding it to /etc/sudoers
add_group_to_sudoers() {
    echo "-"
    echo "Granting sudo privileges to the required user"
    echo "-"
    
    # Add the admin group to the sudoers file if it's not already there
    sudo grep '^%group_admin' /etc/sudoers > /dev/null
    if [ $? -ne 0 ]; then
        echo "%admin ALL=(ALL:ALL) ALL" | sudo EDITOR="tee -a" visudo
     else
        echo "The group_admin group already has sudo privileges."
    fi
}


# Function to generate SSH keys for user_admin
generate_ssh_keys() {
    echo "-"
    echo "Generating SSH keys for admin user"
    sudo -u user_admin ssh-keygen -t rsa -b 4096 -f /home/user_admin/.ssh/id_rsa -N "" -q
}

# Function to list RSA files
list_rsa_files() {
    if [ -d /home/user_admin/.ssh ]; then
        # Switch to user_admin to avoid permission issues
        sudo -u user_admin ls -al /home/user_admin/.ssh
    else
        echo "No RSA key directory found for user_admin"
    fi
}


# Function to display results (contents of /etc/passwd, /etc/group, /etc/sudoers)
list_rsa() {
    echo "-"
    # List RSA key files for the user
    list_rsa_files
}

# Function to delete the users and groups created
delete_accounts() {
    echo "Deleting users"
    sudo userdel -r user_admin
    sudo userdel -r user_support
    sudo userdel -r user_engineering

    echo "Deleting groups"
    sudo groupdel group_admin
    sudo groupdel group_support
    sudo groupdel group_engineering

    echo "Removing group from sudoers"
    sudo sed -i '/^%group_admin/d' /etc/sudoers

    echo "Accounts and groups deleted."
}

# Main function to run the assignment
run_assignment() {
    Exercise
    create_groups
    show_groups
    create_users
    show_users
    add_group_to_sudoers
    generate_ssh_keys
    list_rsa
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
