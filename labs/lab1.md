# Lab 1: Advanced SQL Injection Exploitation

## Objective
This lab focuses on identifying, exploiting, and mitigating SQL injection vulnerabilities in web applications. Students will also learn advanced techniques such as blind SQL injection and time-based exploitation.

---

## Prerequisites
- Understanding of basic SQL commands (SELECT, INSERT, UPDATE, DELETE).
- Familiarity with web application architecture.
- Tools installed:
  - **Burp Suite** (Community or Professional Edition).
  - **OWASP Juice Shop** or **DVWA** (Damn Vulnerable Web Application).
  - Web browser with developer tools (e.g., Chrome, Firefox).

---

## Tools Required
1. Burp Suite
2. SQLMap
3. Local environment with a vulnerable application (Juice Shop or DVWA)

---

## Setup Instructions
1. **Download and Install DVWA**:
   - Clone the DVWA repository:
     ```bash
     git clone https://github.com/digininja/DVWA.git
     ```
   - Set up the environment (e.g., PHP server and database).
   - Access DVWA at `http://localhost/DVWA`.
   - Login with the default credentials (admin/password).
   - Set security level to "Low" in DVWA settings.

2. **Configure Burp Suite**:
   - Set up a proxy and configure your browser to route traffic through Burp Suite.

---

## Tasks

### Task 1: Identifying SQL Injection
1. Navigate to the **Login** page of DVWA.
2. Enter the following credentials:
   - Username: `admin' --`
   - Password: `anything`
3. Observe if you are logged in without providing the correct password.

**Question**: Why does the above input work?

---

### Task 2: Exploiting SQL Injection
1. Go to the **Search Products** page.
2. In the search field, input the following payload:
   ```sql
   ' OR 1=1 --
   ```
3. Observe if all records from the database are displayed.
4. Capture the request in **Burp Suite** and modify it to use a UNION-based payload:
   ```sql
   ' UNION SELECT null, database(), user() --
   ```

**Expected Result**: The database name and user should appear in the output.

---

### Task 3: Blind SQL Injection
1. Switch the DVWA security level to "Medium."
2. Use a **time-based SQL injection payload** on the login page:
   ```sql
   ' OR IF(1=1, SLEEP(5), 0) --
   ```
3. Observe the delay in response time to confirm the vulnerability.

---

### Task 4: Mitigation
1. Implement input sanitization using prepared statements in PHP.
2. Test your code by re-running the above SQL injection payloads.
3. Document your findings and how the vulnerabilities were mitigated.

---

## Submission
- Provide a detailed report including:
  1. Screenshots of each step.
  2. Explanation of why each payload works.
  3. Mitigation strategies implemented and tested.
- Submit your report as a PDF file to the course portal.

---

## Notes
- Be ethical. Only perform SQL injection on applications you own or are authorized to test.
- If you face challenges, refer to the [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/).

*Happy Hacking!*
