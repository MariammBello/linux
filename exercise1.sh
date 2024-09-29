
#!/bin/bash

# Exercise:
#Create 3 groups – admin, support & engineering and add the admin group to sudoers. 
#Create a user in each of the groups. 
#Generate SSH keys for the user in the admin group.

#Instruction:
#Submit the contents of /etc/passwd, /etc/group, /etc/sudoers

# Function to create groups
create_groups() {
    echo "Creating groups: admin, support, engineering"
    sudo groupadd admin
    sudo groupadd support
    sudo groupadd engineering
}

# Function to create users and add them to respective groups (no passwords required)
create_users() {
    echo "Creating users: mariam_admin, mariam_support, mariam_engineering"
    sudo useradd -m -G admin mariam_admin
    sudo useradd -m -G support mariam_support
    sudo useradd -m -G engineering mariam_engineering
}

# Ensure admin is a sudoer (assuming this is already set in /etc/sudoers)
check_sudoers() {
    echo "Ensuring mariam_admin is a sudoer"
    sudo grep '^%admin' /etc/sudoers || echo "%admin ALL=(ALL:ALL) ALL" | sudo EDITOR="tee -a" visudo
}

# Function to list RSA files
list_rsa_files() {
    echo "Listing RSA keys for mariam_admin"
    if [ -d /home/mariam_admin/.ssh ]; then
        ls -al /home/mariam_admin/.ssh
    else
        echo "No RSA key directory found for mariam_admin"
    fi
}

# Function to display results (contents of /etc/passwd, /etc/group, /etc/sudoers)
show_results() {
    echo "### Contents of /etc/group ###"
    cat /etc/group | grep 'admin\|support\|engineering'

    echo "### Contents of /etc/passwd ###"
    cat /etc/passwd | grep 'mariam_admin\|mariam_support\|mariam_engineering'

    echo "### Sudoers Entry for admin group ###"
    sudo cat /etc/sudoers | grep admin

    # List RSA key files for mariam_admin
    list_rsa_files
}

# Main function to run the assignment
run_assignment() {
    create_groups
    create_users
    check_sudoers
    show_results
}

# Run the assignment function
run_assignment
