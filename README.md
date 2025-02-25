To test a **WAF (Web Application Firewall)** and **ACL (Access Control List)** to prevent a specific IP address from accessing your HTTPD web app on an EC2 instance, follow these steps:

---

### **1. Set Up Your Environment**
1. **EC2 Instance**:
   - Launch an EC2 instance with an HTTPD web server (Apache) installed.
   - Ensure the instance is accessible via its public IP or DNS.

2. **Security Group**:
   - Configure the security group attached to the EC2 instance to allow HTTP (port 80) and HTTPS (port 443) traffic from all IPs (for testing purposes).

3. **WAF and ACL**:
   - Use **AWS WAF** to create rules to block specific IP addresses.
   - Use **Network ACLs** (optional) to block traffic at the subnet level.

---

### **2. Set Up AWS WAF**
AWS WAF allows you to create rules to block specific IP addresses.

#### **Steps to Create a WAF Rule**:
1. **Create a Web ACL**:
   - Go to the **AWS WAF & Shield** console.
   - Click **Create web ACL**.
   - Select the region where your EC2 instance is running.
   - Associate the Web ACL with a CloudFront distribution or an Application Load Balancer (ALB). If you don't have an ALB, you can set one up in front of your EC2 instance.

2. **Add a Rule to Block an IP**:
   - In the Web ACL, click **Add rules** and then **Add my own rules**.
   - Create a rule to block a specific IP address:
     - Rule type: **IP match**.
     - IP version: **IPv4**.
     - IP address: Enter the IP address you want to block (e.g., `192.0.2.0`).
     - Action: **Block**.

3. **Associate the Web ACL**:
   - Associate the Web ACL with your ALB or CloudFront distribution.

4. **Test the WAF**:
   - Try accessing your web app from the blocked IP address. The request should be blocked.
   - Use a different IP address to confirm that access is allowed.

---

### **3. Set Up Network ACLs (Optional)**
Network ACLs act as a firewall at the subnet level. You can use them to block traffic from specific IP addresses.

#### **Steps to Create a Network ACL Rule**:
1. **Go to VPC Console**:
   - Navigate to the **VPC** section in the AWS Management Console.
   - Select **Network ACLs**.

2. **Create a Network ACL**:
   - Click **Create Network ACL**.
   - Associate it with the subnet where your EC2 instance is running.

3. **Add Inbound Rules**:
   - Add a rule to deny traffic from the specific IP address:
     - Rule number: `100` (or any number lower than the default `*` rule).
     - Type: `HTTP (80)` or `All traffic`.
     - Protocol: `TCP`.
     - Source: Enter the IP address to block (e.g., `192.0.2.0/32`).
     - Action: `DENY`.

4. **Add Outbound Rules**:
   - Ensure outbound traffic is allowed for legitimate requests.

5. **Test the Network ACL**:
   - Try accessing your web app from the blocked IP address. The request should be blocked.
   - Use a different IP address to confirm that access is allowed.

---

### **4. Test the Setup**
1. **From the Blocked IP**:
   - Use the blocked IP address to try accessing your web app. You should receive a `403 Forbidden` error or be unable to connect.

2. **From a Different IP**:
   - Use a different IP address to confirm that access is allowed.

3. **Check Logs**:
   - For WAF: Check the AWS WAF logs in CloudWatch to see if the blocked requests are logged.
   - For Network ACLs: Check VPC Flow Logs to monitor traffic.

---

### **5. Automate Testing**
- Use tools like `cURL` or scripts to simulate requests from different IPs:
  ```bash
  # Simulate a request from a blocked IP
  curl -X GET http://your-ec2-public-ip --interface eth0:1

  # Simulate a request from an allowed IP
  curl -X GET http://your-ec2-public-ip
  ```

---

### **6. Fine-Tune and Monitor**
- **Adjust Rules**: If legitimate traffic is blocked, adjust the WAF or ACL rules.
- **Monitor Logs**: Regularly monitor logs to ensure the rules are working as expected.

---

By following these steps, you can effectively test and configure AWS WAF and Network ACLs to block specific IP addresses from accessing your HTTPD web app on an EC2 instance.