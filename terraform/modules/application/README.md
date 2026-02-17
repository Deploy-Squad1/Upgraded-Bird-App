This folder contains a reusable module for deploying EC2 instances to host a load balancer and other services needed to serve a web application.
By default, these services include an Auto Scaling group for application services, a database, a Consul server for service discovery and a Jenkins server for configuring all the instances.

A load balancer is deployed into a public subnet and listens for requests over HTTPS. All the other servers are deployed into a private subnet.

To use this module, include it in your Terraform configuration using the `module` block:
```
module "example" {
    source = "../path/to/module"

    [
    input_var1 = value1
    input_var2 = value2
    ...
    ]
}
```
*See the `variables.tf` file to see input variables that need to be defined*


The module supplies:
- elastic IP for the loadbalancer
- one security group that's attached to a loadbalancer
- one security group that's attached to all the services in the private subnet
- SSH keypair: The public key is uploaded to all the instances; the private key is saved locally. This key is needed for Ansible to later configure the instances. 
- ssm profile: This enables connection over AWS Systems Manager.
You will be able to connect to an instance using AWS CLI:
`aws ssm start-session --target instance-id`

To further configure the machines, you will need to log in to the Jenkins web interface.
Use `aws ssm start-session --target id_of_jenkins_machine --document-name AWS-StartPortForwardingSession --parameters '{"portNumber":["8080"],"localPortNumber":["9999"]}` to forward the Jenkins 8080 port to a chosen (e.g., 9999) port on your machine.