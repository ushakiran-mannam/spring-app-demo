def dockerPublisherName = "ushakiran20"
def dockerRepoName = "spring-app"
def customLocalImage = "spring-image-demo"
def gitBranch

properties([pipelineTriggers([githubPush()])])
pipeline {
    agent {
        node {
            label 'aws_node_two'
        }
    }

    stages {
        stage('Build') {
            steps {
                script {

                    gitBranch=getBranchName "${GIT_BRANCH}"

                    if (gitBranch.contains('release') || gitBranch == 'master'){
                        sh "docker rmi ${customLocalImage} || true"
                        sh "docker build -t ${customLocalImage} ."
                    } else {
                        echo "It is not release or master branch"
                    } 
                }
            }
        }

        stage('Push') {
            steps {
                script {
                    if (gitBranch.contains('release')){
                        def buildTag = "build-${BUILD_NUMBER}"
                        def gitUrl = "https://${env.GITHUB_USERNAME}:${env.GITHUB_PASSWORD}@github.com/ushakiran-mannam/spring-app-demo.git"
                        sh "git tag ${buildTag}"
                        sh "git push ${gitUrl} ${buildTag}"
                        def ECR_REGISTRY = env.ECR_REGISTRY
                        def ECR_REPO = env.SIMPLE_JAVA_ECR_REPO

                        sh """
                            docker tag ${customLocalImage} ${ECR_REGISTRY}/${ECR_REPO}:${buildTag}
                            docker tag ${customLocalImage} ${ECR_REGISTRY}/${ECR_REPO}:latest
                            echo "${ECR_REGISTRY}/${ECR_REPO}"
                            docker push ${ECR_REGISTRY}/${ECR_REPO}
                        """
                    } else if (gitBranch == 'master') {
                        sh "docker tag ${customLocalImage} ${dockerPublisherName}/${dockerRepoName}:build-${BUILD_NUMBER}"
                        sh "docker tag ${customLocalImage} ${dockerPublisherName}/${dockerRepoName}:latest"
                        withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'docker-hub-credentials',
                        usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {

                        sh """
                            echo uname=$USERNAME pwd=$PASSWORD
                            docker login -u $USERNAME -p $PASSWORD
                            docker push ${dockerPublisherName}/${dockerRepoName}

                            """
                    }
                     } else 
                    {       echo "Its not feature or release branch "

                    }
                }
            }
        }
    }
}

String getBranchName(String inputString) {
    return inputString.split("/")[1]
}
