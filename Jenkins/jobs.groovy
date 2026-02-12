pipelineJob('ansible-deploy-pipeline') {
    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        url('git@github.com:Deploy-Squad1/Upgraded-Bird-App.git')
                        credentials('github-key')
                    }
                    branch('DS-78-Provide-DNS-and-Enable-HTTPS-the-entire-infrastructure') 
                }
            }
            scriptPath('Jenkins/Jenkinsfile')
        }
    }
}
