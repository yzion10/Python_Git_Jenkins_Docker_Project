# Python_Git_Jenkins_Docker_Project

**Release date: 08/06/2023**

**This project written in:**

python language

Groovy language for pipeline scripts

yaml language for docker-compose.yml file

**prerequisites installations before running this project:**
python3, java, jenkins, Docker, Git

**It combined the following files:**

db_connector.py - This file connect to a remote MySql and implements a couple of methods (INSERT,SELECT,UPDATE,DELETE)

rest_app.py - This file defines routes with rest api for create, read, update, and delete user from/to the remote MySQL.
he start a flask server (localhost) that will run inside a container that create from docker image.

backend_testing.py - testing rest_app.py file

clean_environment.py - This file stop flask servers (localhost) from rest_app.py file.
it protected with error handling in case servers are not responding

templates - contains html file for render_template in rest_app.py

Dockerfile - An image will be built based on what we defined in the Dockerfile

docker-compose.yml - this file will run the container based on what we defined in the docker-compose.yml

docker_backend_testing.py - test the flask server (rest_app.py) that running inside the container.
the test will running outside the container and will try to send/get/put/delete resuests to the flask that is inside the container.

requirements.txt - A file wich include the requirements to install before executing *.py files

jenkinsfile - A jenkins pipeline script (in groovy) which connect to git repository and execute the following steps:
1. Checkout Git Repo holding this project
2. Run rest_app.py - start a flask server locally
3. Run backend_testing.py - test flask server locally
4. Run clean_environment.py - down flask server locally
5. Build docker Image locally
6. Push the docker Image To DockerHub
7. Set compose image version – setting the version inside the .env file for docker-compose (according the pipeline build number)
8. Run docker compose - will run in detach mode (run the container based on what we defined in the docker-compose.yml)
9. Test dockerized app - will run the docker_backend_testing.py
10. Clean container - will call docker-compose down and delete local image

*************************************************************************************************************************
A simple batch commands to test this project locally (without pipeline) on cmd. (run it according to this steps):
1. docker build -t yzion10/dockerapp:1 .
2. docker push yzion10/dockerapp:1
3. echo IMAGE_TAG=1 > .env
4. docker-compose -f docker-compose.yml up -d --build
5. python docker_backend_testing.py
6. docker-compose down
7. docker image rmi yzion10/dockerapp:1
*************************************************************************************************************************

