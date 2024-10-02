# User and Group Management in Linux: A Beginner's Guide
In this guide, we’ll walk through the process of creating users, assigning them to groups, managing sudo privileges, and generating SSH keys—all using fundamental Linux commands. By the end, you’ll not only understand how to perform these tasks manually but also how to automate them using a Bash script for efficiency and reproducibility.

## Objectives of the Exercise:
1. Create three groups: admin, support, and engineering (you can modify the names to suit your needs).
2. Create a user in each group.
3. Generate SSH keys for the user in the admin group.
4. Verify the contents of the ```/etc/passwd```, /```etc/group```, and ```/etc/sudoers``` files to ensure the users and groups were set up correctly.
5. Clean up by deleting users and groups, allowing you to rerun the process as needed.

This guide will first cover the manual approach to performing these tasks and then introduce a Bash script to automate the entire process.

# Manual Approach to User and Group Management
### Creating Groups
To manage permissions for multiple users efficiently, we create groups. For the sake of this exercise, let's create three groups: groupadmin, groupsupport, and groupengineering.

Commands to Create Groups:
```
sudo groupadd groupadmin
sudo groupadd groupsupport
sudo groupadd groupengineering
```
```groupadd```: This command creates a new group.
```sudo```: You need root privileges to modify system-level resources like groups.

#### Verify Group Creation:
To confirm that the groups were created, search for them in the /etc/group file, which stores group information:

```
cat /etc/group | grep 'groupadmin\|groupsupport\|groupengineering'
```
This command will output the lines from /etc/group related to the groups we just created.

### Creating Users and Adding Them to Groups
Next, create one user for each group: user_admin for the groupadmin, user_support for the groupsupport, and user_engineering for the groupengineering.
Passwds are manually removed for running the script simply without any in-between prompts. Ideally passwords should be included

Commands to Create Users:
```
sudo useradd -m -G groupadmin user_admin
sudo useradd -m -G groupsupport user_support
sudo useradd -m -G groupengineering user_engineering
```
Commands to remove password for script simplicity
```
sudo passwd -d user_admin
sudo passwd -d user_support
sudo passwd -d user_engineering
```

```useradd```: Creates a new user.
```-m```: Automatically creates a home directory for the user.
```-G```: Assigns the user to the specified group.

#### Verify User Creation:
To check if the users were successfully created, look them up in the /etc/passwd file, which stores information about all users:
```
cat /etc/passwd | grep 'user_admin\|user_support\|user_engineering'
```
This command will display the user entries for the newly created users.

### Granting Sudo Privileges to the groupadmin Group
By default, users in the groupadmin group do not have administrative (sudo) privileges. To grant them this access, we need to modify the ```/etc/sudoers``` file.

Steps to Modify Sudo Privileges:
Open the sudoers file with the visudo command (this is the safest way to edit the file):
```
sudo visudo
```
Scroll down to where group privileges are defined, and add the following line to give sudo access to the groupadmin group:
```
%groupadmin ALL=(ALL:ALL) ALL
```
```%groupadmin```: The ```%``` symbol indicates that this is a group.
```ALL=(ALL:ALL) ALL```: This allows the group to run any command as any user.

Save the file and exit the editor (e.g., press Ctrl+O to save and Ctrl+X to exit if using nano).

#### Verify Sudo Privileges:
To ensure that the groupadmin group now has sudo privileges, run:
```
sudo grep '%groupadmin' /etc/sudoers
```
If the line exists, it confirms that members of the groupadmin group can now execute commands with elevated privileges.

### Generating SSH Keys for user_admin
SSH keys are an essential tool for secure, passwordless login to remote systems. In this step, we’ll generate a pair of SSH keys for the user_admin.

Command to Generate SSH Keys:
```
sudo -u user_admin ssh-keygen -t rsa -b 4096 -f /home/user_admin/.ssh/id_rsa -N ""
```
```-u``` user_admin: Runs the command as the user_admin user.
```ssh-keygen```: This command generates a new SSH key.
```-t rsa -b 4096```: Specifies the RSA encryption algorithm with a 4096-bit key length.
```-f```: Specifies the location where the key will be saved.
```-N ""```: No passphrase is set (you can modify this if extra security is required).

#### Verify SSH Key Creation:
To verify that the SSH keys were successfully created, list the contents of the .ssh directory for user_admin:

```
sudo -u user_admin ls -al /home/user_admin/.ssh 
```
You should see two files: id_rsa (the private key) and id_rsa.pub (the public key).

### Cleaning Up: Deleting Users and Groups
Once you’re done or need to start fresh, it’s essential to clean up by deleting the users and groups you created.

Commands to Delete Users:
```
sudo userdel -r user_admin
sudo userdel -r user_support
sudo userdel -r user_engineering
```
```userdel -r```: This command deletes the user and their home directory.
Commands to Delete Groups:
```
sudo groupdel groupadmin
sudo groupdel groupsupport
sudo groupdel groupengineering
```
```groupdel```: This deletes the specified group.

Removing the groupadmin Entry from ``/etc/sudoers``:
To remove the sudo privileges for the groupadmin group:

Open the sudoers file again with visudo:

```
sudo visudo
```
Delete the line: ```%groupadmin ALL=(ALL:ALL) ALL```
Alternatively, you can run the following command to remove the line automatically:

```
sudo sed -i '/^%groupadmin/d' /etc/sudoers
```

# Automating User Management Tasks with a Bash Script
Now that you’ve mastered the manual approach, let’s automate the process with a Bash script. Automation saves time and eliminates the possibility of errors, especially when managing multiple users and groups.

## Bash Script Overview
The script automates the following tasks:

1. Creating groups and users.
2. Adding sudo privileges for the groupadmin.
3. Generating SSH keys for the user_admin.
4. Verifying that everything was set up correctly.
5. Cleaning up users and groups for future re-runs.

## Script Structure (See full script in github repo)
The script is modularized, meaning each task is handled by a separate function. Below is an outline of the key sections:

```
#!/bin/bash

# Create groups and users
create_groups() { ... }
create_users() { ... }
exclude_passwd() { ... }

# Verify that groups and users were created
show_groups() { ... }
show_users() { ... }

# Grant sudo privileges to the group
add_group_to_sudoers() { ... }

# Generate SSH keys for the user
generate_ssh_keys() { ... }

# Delete users and groups
delete_accounts() { ... }

# Main function to run the exercise
run_assignment() { ... }

# Menu to choose between running the exercise or deleting accounts
show_menu() { ... }

# Execute the menu
show_menu

``` 

### Make the Script Executable
Before running the script, you need to make it executable:

```
chmod +x exercise.sh
```

### Run the Script
To run the script and capture the output in a file:

```
./exercise.sh | sudo tee exercise.txt
```

```sudo tee exercise.txt```: This writes the output to exercise.txt while displaying it in the terminal.

### Rerunning the Exercise
To reset the environment and rerun the script, select the "Delete Accounts" option from the menu. This will delete the users, groups, and their associated sudo privileges, allowing you to start fresh.

# Conclusion
This guide has shown you how to manually and programmatically manage users and groups in Linux. By mastering these tasks, you’ve taken the first step toward automating repetitive system administration tasks, ensuring efficient and error-free management.

## Key Takeaways:
1. Group and User Management: Creating and assigning users to groups organizes permissions efficiently.
Sudo Privileges: Editing the /etc/sudoers file grants or limits users' ability to execute commands with root privileges.
2. SSH Key Generation: Secure, passwordless login is critical in managing Linux systems, and generating SSH keys is an essential skill.
3. Automation: Using Bash scripts for user and group management enhances reproducibility and saves time in system administration.

Now that you have a solid understanding of these commands, you can confidently apply them in real-world scenarios or automate them using scripts!


# Summary of some linux Commands:

## Create User: 
``` 
sudo useradd -m -s /bin/bash newuser 
```
## Set Password: 
```
sudo passwd newuser
```

## Checking all users from directory of users
```
/etc/passwd
```

## Check specific User: 
```
grep newuser /etc/passwd or id newuser
```
## Switch User: 

```
su - newuser
``` 
## Create Group: 

```
sudo groupadd newgroup
```

## Add User to Group: 
```
sudo usermod -aG newgroup newuser
```
### Explanation
This user modification (usermod) helps to add user to a group,  using - ``` -aG ``` parameters where
```

  -G, --groups GROUPS           new list of supplementary GROUPS
  -a, --append                  append the user to the supplemental GROUPS
                                mentioned by the -G option without removing
                                the user from other groups

```
The output note in this explanation was generated by running the help command ``` usermod --help``` 

## Check groups from directory
 ```
 cat /etc/group
```

### Check specific group 
```
 grep mariams /etc/group
```


## Check Groups a user is in: 
```
groups newuser
```

List Users: 
```
cut -d: -f1 /etc/passwd
```

Delete User: 
```
sudo userdel -r newuser
```

## Delete Group: 
```
sudo groupdel newgroup
```

## Modify an existing user (e.g., change home directory)

``` 
sudo usermod -d /new/home/directory newuser
```

## Modify user permissions on a file

```
chmod 755 filename
```
7 = 4+2+1 where 4 is read, 2 is write
1 is execute in that order. 755 here means userpermission group permission others permissions (in that order). 7=4+2+1 for user so read(4), write(2) and execute(1), group =5 (read 4, execute 1)

