
pipeline
{
    options
    {
        buildDiscarder(logRotator(numToKeepStr: '20', daysToKeepStr: '5'))
    }

    environment
    {
        JOB1_SUCCESS = false
        imageTag = env.BUILD_NUMBER

        rest_app = 'rest_app.py'
        backend_testing = 'backend_testing.py'
        clean_environemnt = 'clean_environemnt.py'
        build_Image = 'Build Docker image - locally'
        push_Image = 'Push Docker image - to DockerHub'
        set_compose_version = 'Set compose image version'
        run_docker_compose = 'Run docker-compose up -d'
        test_dockerized_app = 'Test dockerized app - using docker_backend_testing.py'
        clean_container = 'Clean Container environment'
    }

    agent any

    stages
    {
        stage('checkout Git Repo')
        {
            steps
            {
                script
                {
                     properties([pipelineTriggers([pollSCM('H/30 * * * *')])])
                }

                git 'https://github.com/yzion10/Python_Git_Jenkins_Docker_Project.git'
            }
        }
        stage('Run ${env.rest_app}')
        {
            steps
            {
                script
                {
                    def isSuccess = false

                    try
                    {
                        bat "start /min python.exe ${env.rest_app}"
                        isSuccess = true
                    }
                    catch (Exception e)
                    {
                        isSuccess = false
                        echo "${env.rest_app} Error: ${e.getMessage()}"
                    }
                    finally
                    {
                        env.JOB1_SUCCESS = isSuccess
                    }
                }
            }
        }
        stage('Run ${env.backend_testing}')
        {
            when
            {
                expression
                {
                    env.JOB1_SUCCESS
                }
            }
            steps
            {
                script
                {
                    try
                    {
                        bat "python.exe ${env.backend_testing}"
                    }
                    catch (Exception e)
                    {
                        echo "${env.backend_testing} Error: ${e.getMessage()}"
                    }
                }
            }
        }
        stage('Run ${env.clean_environemnt}')
        {
           when
            {
                expression
                {
                    env.JOB1_SUCCESS
                }
            }
            steps
            {
                script
                {
                    try
                    {
                        bat "python.exe ${env.clean_environemnt}"
                    }
                    catch (Exception e)
                    {
                        echo "${env.clean_environemnt} Error: ${e.getMessage()}"
                    }
                }
            }
        }

        stage(${env.build_Image})
        {
            steps
            {
                script
                {
                    bat 'docker build -t yzion10/dockerapp:${imageTag} .'
                }
            }
        }

        stage(${env.push_Image})
        {
            steps
            {
                script
                {
                    bat 'docker push yzion10/dockerapp:${imageTag}'
                }
            }
        }

        stage(${env.set_compose_version})
        {
            steps
            {
                script
                {
                    bat 'echo IMAGE_TAG=${imageTag} > .env'
                }
            }
        }

        stage(${env.run_docker_compose})
        {
            steps
            {
                script
                {
                    // Run the container using the .env file to get from him the IMAGE_TAG
                    bat 'docker-compose -f docker-compose.yml up -d --build'
                    //bat 'docker-compose up -d'
                }
            }
        }

        stage(${env.test_dockerized_app})
        {
            steps
            {
                script
                {
                    bat 'pip install requests'
                    bat 'pip install pymysql'
                    bat 'python.exe docker_backend_testing.py'
                }
            }
        }

        stage(${env.clean_container})
        {
            steps
            {
                script
                {
                    bat 'docker-compose down'
                    bat 'docker image rmi yzion10/dockerapp:${imageTag}'
                }
            }
        }
    }
    post
    {
        failure
        {
            emailext subject: 'Pipeline Failed',
                     body: 'The Jenkins pipeline failed (Python_Git_Jenkins_Docker_Project)',
                     to: 'yzion10@gmail.com',
                     from: 'yzion10@gmail.com'
        }
    }
}