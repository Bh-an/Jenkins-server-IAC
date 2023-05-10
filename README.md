# Setting up Jenkins Infrastructure using Ansible

### To set variables according to user, run:

```
bash setvars.sh user
```
accepted users:
- raj
- bhan

*note: The script is not executable and the usage of bash is required*

### For Jenkins Infrastructure Deployment:

Run:

```
export ANSIBLE_HOST_KEY_CHECKING=False

ansible-playbook setup_playbook.yml --extra-var "env=username"
```

*for only network set up, set instance_flag=no*
```
ansible-playbook setup_playbook.yml --extra-var "instance_flag=no"
```
*note: after network setup, instance can be deployed by running the playbook without any flags*

To configure jenkins and install plugins:

Change the path to your private key in configure_jenkins.yml and set vars in role jenkins_configuration

Then run:

```
export ANSIBLE_HOST_KEY_CHECKING=False

ansible-playbook configure_jenkins.yml --extra-var "env=username"
```

### To launch Jenkins Infrastructure using a specific AWS Named Profile and in Debug mode, use:
```
AWS_PROFILE={{named_profile}} ANSIBLE_DEBUG=true ansible-playbook setup_playbook.yml
```

### For jenkins instance termination, run:
```
ansible-playbook termination_playbook.yml --extra-var "key=app" --extra-var "value=jenkins"  --extra-var "env=username"
```
*for only network/instance teardown, set instance_flag=no/network_flag=no*

*note: network cannot be torn down before instance*


### For Assignment 5:
- Change vars in infra_setup
- Change vars in jenkins_config
- Change vars in configure_jenkins.yml

### Command Examples:
```
ansible-playbook setup_playbook.yml --extra-var "env=raj"
ansible-playbook configure_jenkins.yml --extra-var "env=raj" --ask-vault-pass
ansible-playbook termination_playbook.yml --extra-var "key=app" --extra-var "value=jenkins"  --extra-var "env=raj"
```