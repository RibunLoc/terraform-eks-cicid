pipeline{
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KRY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "ap-northeast-1"
    }
    stages {
        stage('Checkout SCM') {
            steps {
                script {
                    checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/vishal2505/terraform-eks-cicd.git']])
                }
            }
        }
        stage('Initializing Terraform') {
            steps {
                script {
                    dir('tf-aws-eks'){
                        sh 'terraform init -reconfigure'
                    }
                }
            }
        }
        stage{'Validating Terraform'} {
            step {
                script {
                    dir ('tf-aws-eks') {
                        sh 'terraform validate'
                    }
                }
            }
        }
        stage{'Terraform Plan'} {
            step {
                script {
                    dir('tf-aws-eks') {
                        sh 'terraform plan -var-file=variables/dev.tfvars'
                    }
                    input(message: "Are you sure to proceed?", ok: "Proceed")
                }
            }
        }
        stage('Creating/Destroying EKS Cluster') {
            steps {
                script {
                    dir('tf-aws-eks'){
                        sh 'terraform $action -var-file=variable/dev.tfvars -auto-approve'
                    }
                }
            }
        }
        stage('Deploying Nginx Application') {
            steps{
                script{
                    dir('manifest') {
                        sh 'aws eks update-kubeconfig --name my-eks-cluster'
                        sh 'kubectl create namespace eks-nginx-app'
                        sh 'kubectl apply -f deployment.yaml -n eks-nginx-app'
                        sh 'kubectl apply -f service.yaml -n eks-nginx-app'
                    }
                }
            }
        }
    }
}