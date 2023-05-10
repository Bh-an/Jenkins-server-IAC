# Jenkins server and supporting infrastructure using Ansible

- Creates a VPC in an AWS count along with related resources like subnets, route tables, gateways etc
- Sets up an EC2 instance from a custom ami with jenkins and supporting sorftware installed (to see how to make custom ami using packer: [repo link](https://github.com/Bh-an/jenkins-ami-build "Jenkins AMI build repo"))
- Configures a jenkins ec2 server:
  - Enables certbot ssl verification
  - Procures intitial jenkins password 
  - Sets docker and github authectications as jenkins secrets
  - Adds 2 job pipelines (for - [publishing helm-chart releases](TBA "Webapp helm chart"); [updating kube-cluster's helm-chart with pushes to webapp](TBA "Webapp"))
    *Note: Webhooks need to be configured for repos for jobs to be triggered: <jenkins-server-url>/github-webhook/*
  - Installs relevant plugins and software

## Usage

### Setup configuration and variables:

- Change the variables in roles/vars/common-vars.yml as needed
- Ensure existence of keypair in aws account and private key on system
- Change or create user-data.sh to contain your server name
- Create a file <username>.yml in roles/vars/ containing config specific values (use existing refrences)
- Go through and make changes as needed to jenkins configuration in roles/jenkins_configuration/tasks/main.yml

*make sure relevant domain records and resources present in common_vars exist in your aws account*

### Jenkins Infrastructure Deployment:

```
export ANSIBLE_HOST_KEY_CHECKING=False

ansible-playbook setup_playbook.yml --extra-var "env=username"
```

*for only network set up, set instance_flag to no*
```
ansible-playbook setup_playbook.yml --extra-var "instance_flag=no env=username"
```
*note: after network setup, instance can be deployed by running the playbook again without any flags*

### Configure jenkins and install plugins:

```
ansible-playbook configure_jenkins.yml --extra-var "env=username"
```

To launch Jenkins Infrastructure using a specific AWS Named Profile and in Debug mode, use:
```
AWS_PROFILE={{named_profile}} ANSIBLE_DEBUG=true ansible-playbook setup_playbook.yml
```

### Tearing down infrastructure:
```
ansible-playbook termination_playbook.yml --extra-var "key=app value=jenkins env=username"
```
*for only instance teardown, set network_flag=no*
  
