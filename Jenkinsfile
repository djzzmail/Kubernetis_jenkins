pipeline {
    environment {
        PROJECT = "jenkinscicd-345611"
        APP_NAME = "flaskhelloworld"
        CLUSTER = "jenkins-cd"
        CLUSTER_ZONE = "europe-west1"
        IMAGE_TAG = "eu.gcr.io/${PROJECT}/${APP_NAME}:${env.BUILD_NUMBER}"
        JENKINS_CRED = "${PROJECT}"
    }
    agent {
        kubernetes {
            cloud 'gcp-ro-ci-cd-gke-cluster'
            defaultContainer 'jnlp'
            yamlFile 'build/jenkins-pod.yaml'
        }
    }
    stages {
        stage('Build and Publish Docker Image') {
            steps {
                container('docker') {
                    script {
                        def app = docker.build("eu.gcr.io/${PROJECT}/${APP_NAME}")
                        docker.withRegistry('https://eu.gcr.io', "gcr:${JENKINS_CRED}") {
                            app.push("${env.BUILD_NUMBER}")
                            app.push("latest")
                        }
                    }
                }
            }
        }
        stage('Deploy to GKE Cluster') {
            steps {
                container('kubectl') {
                    sh("sed -i.bak 's#eu.gcr.io/${PROJECT}/${APP_NAME}:0.0.0#${IMAGE_TAG}#' ./k8s/deployment.yaml")
                    step([$class: 'KubernetesEngineBuilder', namespace: "default", projectId: env.PROJECT, clusterName: env.CLUSTER, zone: env.CLUSTER_ZONE, manifestPattern: 'k8s/deployment.yaml', credentialsId: env.JENKINS_CRED, verifyDeployments: false])
                    step([$class: 'KubernetesEngineBuilder', namespace: "default", projectId: env.PROJECT, clusterName: env.CLUSTER, zone: env.CLUSTER_ZONE, manifestPattern: 'k8s/service.yaml', credentialsId: env.JENKINS_CRED, verifyDeployments: true])
                }
            }
        }
    }
}
