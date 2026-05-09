# Jenkins5_Task2_DownStream_Project
1. Create two project make manage_services as downstream project for devops project
devops_project
ssh -o StrictHostKeyChecking=no sarah@stapp01 "
cd /var/www/html && git pull origin master
"
manage_services
ssh -o StrictHostKeyChecking=no sarah@stapp01 "
sudo systemctl restart httpd
"

# Jenkins5_Task3_Create_pipeline_with_two_stages
```bash
pipeline {
    agent {
        label 'stapp01'
    }

    stages {
        stage('Build') {
            steps {
                git credentialsId: 'sarah-gitea', url: 'https://3000-port-weznv4xnyj3jpfgw.labs.kodekloud.com/sarah/mr_job.git'
                sh '''
                docker build -t stregi01.stratos.xfusioncorp.com:5000/nginx:latest .
                docker push stregi01.stratos.xfusioncorp.com:5000/nginx:latest
                '''
            }
        }
        stage('Deploy') {
            steps {
                sh '''
                docker rm -f nginx-app || true
                docker run -d --name nginx-app -p 8080:80 stregi01.stratos.xfusioncorp.com:5000/nginx:latest
                '''
            }
        }
    }
}
```
# Jenkins4_Task4_Multistage_pipeline
```bash
pipeline {
    agent {
        label 'stapp01'
    }

    stages {
        stage('Deploy') {
            steps {
               git credentialsId: 'sarah-gitea', url: 'https://3000-port-viroqdlo3g2wr7fm.labs.kodekloud.com/sarah/web.git', branch: 'master'
                sh '''
                sudo rm -rf /var/www/html/*
                sudo cp -r * /var/www/html/
                sudo systemctl restart httpd
                '''
            }
        }
        stage('Test') {
            steps {
               sh '''
               TOKEN=$(cat /var/www/html/index.html)
                curl -s --fail http://stlb01:8091 | grep "$TOKEN"
                '''
            }
        }
    }
}
```


