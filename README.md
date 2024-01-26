# Kubernetes Assignment

## Environment

Please use either Docker Desktop Kubernetes (Available for [Mac](https://docs.docker.com/docker-for-mac/kubernetes/) and [Windows](https://docs.docker.com/docker-for-windows/kubernetes/)) or [Minikube](https://kubernetes.io/docs/setup/minikube/) for this assignment. You do not need to automate the deployment of the Kubernetes environment.

## Part 1

We would like to deploy our [Java application](https://tomcat.apache.org/tomcat-8.0-doc/appdev/sample/) to K8s, it needs to run in Tomcat 8 and should be available for other pods in the cluster to use (via HTTP) after deployment.

### Answer

#### Local Development
I have created a Dockerfile to build an image with the mentioned Java App using tomcat8 image based on alpine.
To build the image run at the root of the directory
```
docker build -t tomcat-app:v1 -f Dockerfile .
```
To run locally the container to test run
```
docker run -p 8080:8080 --name test_tomcat-app tomcat-app:v1
```
Check if you can access the app at http://localhost:8080/sample/

#### K8s deployment
Now, that the container is ready
We have to deploy the container to a k8s cluster
Note: I assume you have kubectl configured and authenticated with the k8s cluster that you are trying to deploy to.

- We create a namespace for us just to keep it clean
    ```
    kubectl apply -f .\k8s\1-namespace.yaml
    ```
- We create a deployment to create the pod
    ```
    kubectl apply -f .\k8s\2-deployment.yaml
    ```
- We create a service to connect to the pod (as later we can have multiple pods)
    ```
    kubectl apply -f .\k8s\3-service.yaml
    ```
You can now check the application through the nodePort (provided you have network access to the Worker Nodes): http://kubernetes.docker.internal:30090/sample/

## Part 2

Our application is now ready for production and should be usable by the world. Deploy an ingress into the environment and let people access our service via port 8080. What else would you consider when going to production? Make any appropriate changes and/or comments in README

### Answer

#### Deploy Ingress
- We create a Service of type ClusterIP
    ```
    kubectl apply -f .\k8s\4-service-for-ingress.yaml
    ```
- We create a Ingress to connect the service to the outside (local machine) world
    ```
    kubectl apply -f .\k8s\5-ingress.yaml
    ```

Now you should be able to access the website through the ingress controller of your cluster

#### Production Considerations
- Create a TLS Secret with a certificate and allow access to the app on port 443 over SSL
- Consider applying ModSecurity on Ingress controller to prevent attacks
- Consider putting in a HPA for automatic load scaling (https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)

## Part 3

The world loves our app but its a little unstable and occasionally crashes under heavy load. What can you do to make the system more robust? Include code which implements your solution. In the README describe how you would tell that the app is more stable going forwards. 

### Answer

Since as in the current situation, I do not have access to the code with which that sample application was written. I would
- Monitor the logs of the pods and see what causes the Pod to crash (Could be memory leak, buggy code, etc)
- Since I have made the pod as deployment, K8s will always maintain a running copy of the pod, we specify replicas and then even if one pod is killed, the other pods are running to take the traffic
- After observation, if I see that there is high traffic and simply the pods are dying because of high CPU/memory; I would implement a HPA for automatic load scaling with Resource parameters that I have observed and gathered through studying the logs and usage patterns

## Bonus Task (optional, for senior engineers)

Create a Terraform project that:

- deploys a centos AMI to a new AWS VPC
- I want to be able to curl http://google.com from inside the AMI
- (you choose the rest of the details, if any)

### Answer

Since I do not have much knowledge on AWS and GCP, but I am comfortable with Azure, I am going to create an Azure Vm with CentOS on a vNet and associate a NSG on it to allow SSH

Prerequiste:
- Create SPN: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret
- Replace the deafult values in the "terraform\variables.tf" with the correct values that you want for the resources or you can leave them as is, as per my preference :)
- Add terrform.exe location to the $PATH env variable
- Then change PWD to "terraform" in the current repository

Steps:
- Assuming you have a SPN with Contributer rights on your Subcription fill replace the values of each of the 4 lines and run then in Powershell
    ```
    $env:ARM_CLIENT_ID = "ReplaceMe"
    $env:ARM_CLIENT_SECRET = "ReplaceMe"
    $env:ARM_TENANT_ID = "ReplaceMe"
    $env:ARM_SUBSCRIPTION_ID = "ReplaceMe"
    ```
- Run
    ```
    terraform init
    ```
    Check if init is successful
- Run
    ```
    terraform plan
    ```
    Check if the plan appears
- Run
    ```
    terraform.exe apply -auto-approve
    ```
    Your VM should be ready

- Run
    ```
    ssh manish@74.235.253.177
    ```

- Enter the password that you have selected, otherwise the password is "Password1234!"

- In the terminal run
    ```
    curl http://google.com
    ```
    Output
    ```
        [manish@manishvmtest ~]$ curl http://google.com
        <HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
        <TITLE>301 Moved</TITLE></HEAD><BODY>
        <H1>301 Moved</H1>
        The document has moved
        <A HREF="http://www.google.com/">here</A>.
        </BODY></HTML>
        [manish@manishvmtest ~]$ exit
        logout
        Connection to 74.235.253.177 closed.
    ```

- After the activity you can cleanup the resources by
    ```
    terraform destroy
    ```