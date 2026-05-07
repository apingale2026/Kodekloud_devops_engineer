# Jenkins3_Task1_Install_Agent/Slave Nodes
1. On each slave node java must be installed 
2. Install ssh ssh build agent plugins
3. Add credentials for each node agent 
3. In manage Jenkins -> Nodes-> Create nodes -> add labels -> select Launch agent via SSH -> add remote directory
4. Add SSH host and credentials to connect 
5. launch agent and agent must be connected and online 

# Jenkins3_Task2_Update_job_level_permission_and_inherit permission from parent 
1. Install Matrix based authorization plugins 
2. Click on existing job Package --> click on configure--> select "Enable project based security" 
3. In that select inheritance strategy "Inherit permission from parent ACL"-> grant specific permission to given users 


# Jenkins3_Task3_cloneDokerfileFromGit_AndBuildDockerImageOnAppserver1_AndPushToRegitry
1.Install ssh,git,pipeline plugin 
2.Configure credentials for gitea and stapp01
3.Configure stapp01 as Node agent
4.Create pipeline job as below
```bash
pipeline {
    agent {
        label 'stapp01'
    }

    stages {
        stage('Build') {
            steps {
        git credentialsId: 'gitea', url: 'https://3000-port-6n7nlgzytzx7jfgq.labs.kodekloud.com/sarah/web.git'
        sh '''
          docker build -t stregi01.stratos.xfusioncorp.com:5000/nginx:latest .
          docker push stregi01.stratos.xfusioncorp.com:5000/nginx:latest
        '''
            }
        }
    }
}
```

# Jenkins3_Task4_Deploy_to_appserver1
1.Install ssh,git,pipeline plugin 
2.Configure credentials for gitea and stapp01
3.Configure stapp01 as Node agent
4.Create pipeline job as below
```bash
pipeline {
    agent {
        label 'stapp01'
    }

    stages {
        stage('Deploy') {
            steps {
                git credentialsId: 'gitea', url: 'https://3000-port-rtpxcjsb6nfqk7bw.labs.kodekloud.com/sarah/web_app.git'
                sh "rm -rf /var/www/html/*"
                sh "cp -r * /var/www/html/"
            }
        }
    }
}
```
# Jenkins3_Task5_Deploy_to_appserver1_based_on_branch_conditional 
pipeline {
    agent {
        label 'stapp01'
    }
    parameters {
      string(name: 'BRANCH', defaultValue: 'master')
    }

    stages {
        stage('Deploy') {
            steps {
               script {
                   if (params.BRANCH == 'master') {
                   git branch: 'master', credentialsId: 'sarah-gitea', url: 'https://3000-port-zs5pcfvfvim3zlkd.labs.kodekloud.com/sarah/web_app.git'
                   }
                   else if (params.BRANCH == 'feature') {
                   git branch: 'feature', credentialsId: 'sarah-gitea', url: 'https://3000-port-zs5pcfvfvim3zlkd.labs.kodekloud.com/sarah/web_app.git'
                   else {
                       error "Invalid Branch Value"
                   }
                 }
                  
                  sh "cp -r /home/sarah/jenkins_agent/workspace/nautilus-webapp-job/* /var/www/html/"
               
            }
        }
    }
}



