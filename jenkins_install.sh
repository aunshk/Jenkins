# Jenkins installation in RHEL8
#!/bin/bash
set -e
set -x

inst_jenkis()
    {
            echo "##### Installing jenkins #####"
            sudo yum install -y jenkins -y
            echo "##### Checking 8080 port is available or not #####"
            check_port_occupied=$(sudo netstat -tulpn | grep 8080 | awk '{print $7}')
                if [[  -z "$check_port_occupied" ]]
                then 
                    echo "##### Allowing port 8080 in firewall #####"
                    sudo firewall-cmd --permanent --add-port=8080/tcp
                    sudo firewall-cmd --reload
                    echo "##### Starting Jenkins #####"
                    sudo systemctl start jenkins
                    sudo systemctl enable jenkins
                    echo "##### Jenkins installation is completed. you can access it using 'http://<Server-IP>:8080' #####"
                    echo "Jenkins temporary password is : $(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)"
                else
        
                    echo "##### There is an another application running on port 8080. you need to do following steps to start genkins #####"
                    echo -e "1. change genkins port \n 2. Allow port in firewall using 'sudo firewall-cmd --permanent --add-port=8080/tcp'  \n 3. reload firewall using 'sudo firewall-cmd --reload' \n 4. check jenkins status using 'sudo systemctl status jenkins' \n 5. access jenkins on 'http://<Server-IP>:<port>'"
             
                fi

    }
 

echo "##### Updating the system packages #####"
sudo yum update -y

echo "##### installing dependencies #####"
sudo yum install wget -y

echo "##### Adding jenkins repo #####"
sudo wget http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo -O /etc/yum.repos.d/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key

echo "##### Installing java 11 #####"
sudo  yum install -y java-11-openjdk-devel
check_java=$(java --version | awk '{print $2}'  | head -n 1 | cut -d "." -f 1)

echo "##### Checking supported java version ######"
if [[ check_java -ge 11 ]]
then 
    inst_jenkis
else
    echo "unsupported java version"
    echo "$check_java"    
fi




#######################################

# unistall jenkins
#sudo yum remove -y jenkins -y
#sudo  yum remove -y java-11-openjdk-devel

#start jenkins with different port
#cd /usr/share/java/
#java -jar jenkins.war --httpPort=8081


