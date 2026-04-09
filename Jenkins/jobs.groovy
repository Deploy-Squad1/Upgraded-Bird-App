// 1. BirdWatching App Deployment Pipeline 
pipelineJob('ansible-deploy-pipeline') {
    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        url('git@github.com:Deploy-Squad1/Upgraded-Bird-App.git')
                        credentials('github-key')
                    }
                    branch('main') 
                }
            }
            scriptPath('Jenkins/Jenkinsfile')
        }
    }
}

// 2. SecretSociety Helm Charts Deployment Pipeline
pipelineJob('eks-helm-deploy') {
    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        url('git@github.com:Deploy-Squad1/SecretSocietyHelmCharts.git')
                        credentials('github-key')
                    }
                    branch('main')
                }
            }
            scriptPath('Jenkinsfile') 
        }
    }
}