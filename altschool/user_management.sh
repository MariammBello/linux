#!/bin/bash

#!/bin/bash

# Function to display the menu
show_menu() {
    echo "1) Add User"
    echo "2) Delete User"
    echo "3) Create Group"
    echo "4) Add User to Group"
    echo "5) Delete Group"
    echo "6) Exit"
    echo -n "Enter your choice: "
    read choice
}

# Function to add a user
add_user() {
    echo -n "Enter the username to add: "
    read username
    sudo useradd -m -s /bin/bash "$username"  # -m creates a home directory; -s sets the shell
    echo "User $username has been added."
    sudo passwd "$username"  # Set password for the user
}

# Function to delete a user
delete_user() {
    echo -n "Enter the username to delete: "
    read username
    sudo userdel -r "$username"  # -r removes the user's home directory as well
    echo "User $username has been deleted."
}

create_group() {
    echo -n "Enter the group name to create: "
    read groupname
    sudo groupadd "$groupname"
    echo "Group $groupname has been created."
}

# Function to add a user to a group
add_user_to_group() {
    echo -n "Enter the username: "
    read username
    echo -n "Enter the group to add $username to: "
    read groupname
    sudo usermod -aG "$groupname" "$username"
    echo "User $username has been added to group $groupname."
}

# Function to delete a group
delete_group() {
    echo -n "Enter the group name to delete: "
    read groupname
    sudo groupdel "$groupname"
    echo "Group $groupname has been deleted."
}


while true; do
    show_menu
    case $choice in
        1) add_user ;;
        2) delete_user ;;
        3) create_group ;;
        4) add_user_to_group ;;
        5) delete_group ;;
        6) exit 0 ;;
        *) echo "Invalid option, please try again." ;;
    esac
done

# Make the script executable by changing the permissions
     #chmod +x user_management.sh
# Run the script by running the command 
     # ./user_management.sh
