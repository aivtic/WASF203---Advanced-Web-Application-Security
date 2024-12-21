### Practical Assignment Solution: User, Group, and Permission Management Guide

---

### **Objective**:  
This guide provides step-by-step instructions to complete a practical assignment on **user, group, and permission management** in a Linux system. 

---

### **1. User Management**

#### **Task 1: Create new users and set their passwords**
1. Open a terminal or SSH into the Linux system.
2. To create users, use the `useradd` command and set their passwords using the `passwd` command:
   ```bash
   sudo useradd john
   sudo passwd john   # Enter john123

   sudo useradd jane
   sudo passwd jane   # Enter jane123

   sudo useradd bob
   sudo passwd bob    # Enter bob123

   sudo useradd alice
   sudo passwd alice  # Enter alice123

   sudo useradd mike
   sudo passwd mike   # Enter mike123
   ```
   After setting the passwords, **login to john** and **jane** using:
   ```bash
   su - john
   su - jane
   ```

#### **Task 2: Modify the users to change full names and add comments**
- Use the `usermod` command to modify each user's full name and comment.
   ```bash
   sudo usermod -c "Marketing Team" -f "John Doe" john
   sudo usermod -c "Sales Team" -f "Jane Smith" jane
   sudo usermod -c "IT Department" -f "Bob Johnson" bob
   sudo usermod -c "HR Department" -f "Alice Brown" alice
   sudo usermod -c "Finance Team" -f "Mike Davis" mike
   ```

#### **Task 3: Delete the following users**
- Use the `userdel` command to remove `bob` and `alice` users:
   ```bash
   sudo userdel bob
   sudo userdel alice
   ```

---

### **2. Group Management**

#### **Task 1: Create new groups with specific Group IDs**
- Use the `groupadd` command to create the groups:
   ```bash
   sudo groupadd -g 500 marketing
   sudo groupadd -g 501 sales
   sudo groupadd -g 502 IT
   sudo groupadd -g 503 HR
   sudo groupadd -g 504 finance
   ```

#### **Task 2: Add users to their respective groups**
- Use the `usermod` command to add users to the groups:
   ```bash
   sudo usermod -aG marketing john
   sudo usermod -aG marketing jane

   sudo usermod -aG sales mike
   sudo usermod -aG sales jane

   sudo usermod -aG IT bob
   sudo usermod -aG IT admin

   sudo usermod -aG HR alice
   sudo usermod -aG HR admin

   sudo usermod -aG finance mike
   sudo usermod -aG finance admin
   ```

#### **Task 3: Remove users from groups**
- Use the `gpasswd` command or `vigr` editor to remove `jane` from `marketing` and `sales` groups:
   ```bash
   sudo gpasswd -d jane marketing
   sudo gpasswd -d jane sales
   ```

#### **Task 4: Delete groups**
- Use the `groupdel` command to delete the specified groups:
   ```bash
   sudo groupdel HR
   sudo groupdel finance
   ```

---

### **3. Permission Management**

#### **Task 1: Create a new directory "projects" and set permissions**
1. Create the directory:
   ```bash
   sudo mkdir /projects
   ```
2. Set permissions using the **octal method** (`755`):
   ```bash
   sudo chmod 755 /projects
   ```

#### **Task 2: Change directory permissions using symbolic method**
   ```bash
   sudo chmod u=rwx,g=rx,o=rx /projects
   sudo chmod u=rwx,g=rw,o=--- /projects
   ```

#### **Task 3: Create files with different permissions**
1. Create files:
   ```bash
   sudo touch /projects/report.txt
   sudo touch /projects/salesdata.csv
   sudo touch /projects/marketingplan.docx
   ```
2. Set permissions:
   ```bash
   sudo chmod 644 /projects/report.txt
   sudo chmod 755 /projects/salesdata.csv
   sudo chmod 664 /projects/marketingplan.docx
   ```

#### **Task 4: Change ownership of files**
1. Change ownership using `chown`:
   ```bash
   sudo chown john:marketing /projects/report.txt
   sudo chown mike:sales /projects/salesdata.csv
   sudo chown admin:marketing /projects/marketingplan.docx
   ```

#### **Task 5: Create a new directory "archives" with the permission "drwxr-xr-x"**
   ```bash
   sudo mkdir /archives
   sudo chmod 755 /archives
   ```

---

### **4. Bulk User Creation**

#### **Task 1: Create 10 new users from a file "users.txt"**
1. Prepare a `users.txt` file with the following format:
   ```
   username,password,uid,gid,home,shell
   john,john123,1001,500,/home/john,/bin/bash
   jane,jane123,1002,501,/home/jane,/bin/bash
   # Add 8 more users in the same format
   ```

2. Use a script or loop to add users:
   ```bash
   while IFS=, read -r username password uid gid home shell
   do
      sudo useradd -u "$uid" -g "$gid" -d "$home" -s "$shell" "$username"
      echo "$username:$password" | sudo chpasswd
   done < users.txt
   ```

#### **Task 2: Verify users were created**
   ```bash
   cat /etc/passwd | grep username
   ```

#### **Task 3: Add users to their respective groups**
   ```bash
   sudo usermod -aG group_name username
   ```

---

### **5. Submission**

For submission, prepare a report that contains the following:

1. **Commands used for each task**: Include all commands executed during the assignment.
2. **Output of verification commands**: For example, use the `id` command to verify group membership:
   ```bash
   id username
   ```
3. **Screenshots of the terminal/command prompt** showing the execution of each task.

**Total Marks**: 20 marks (You should ensure every step is completed correctly to receive full credit).

Good luck!