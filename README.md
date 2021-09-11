# sf-proekt-8

## Creates a VM in Yandex Cloud via Terraform
## Configures this VM with Ansible: installs SSH keys, Jenkins, Docker

## Install:

Change public key in terraform/meta.yml

Create var file
```
cat << EOF > private.tfvars
yc_token  = "<your auth token>"
cloud_id  = "<your yandex cloud id>"
folder_id = "<your yandex cloud folder id>"
EOF
```
or use private.tfvars.example

```
git clone https://github.com/jkL-snk/sf-proekt-9.git
cd ./sf-proekt-9/terraform
terraform init
terraform apply --var-file-private.tfvars
```

External ip from terraform output will be written to ansible/inventory.ini

```
cd ../ansible
ssh-agent bash
ssh-add ~/.ssh/id_rsa
ansible-playbook ssh.yaml -i inventory.ini
ansible-playbook docker.yaml -i inventory.ini
ansible-playbook jenkins.yaml -i inventory.ini
ansible-playbook reboot.yaml -i inventory.ini
ansible jenkins -i inventory.ini -a 'cat /var/lib/jenkins/secrets/initialAdminPassword' -b
```

Log in to Jenkins: <external ip>:8080 with this password.
