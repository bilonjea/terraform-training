``` bash
sudo cloud-init status --long
sudo grep '\[CREDENTIALS\]' /var/log/cloud-init-output.log
sudo grep -i "CREDENTIALS" /var/log/cloud-init-output.log
sudo less /var/log/cloud-init-output.log
sudo -u student01 aws sts get-caller-identity

curl http://PUBLIC_IP:8200/v1/sys/health
curl http://PRIVATE_IP:8200/v1/sys/health

http://PUBLIC_IP:8200/ui/vault/auth

ssh-keygen -f ~/.ssh/known_hosts -R 44.218.83.196


sudo -iu student01
cat ~/.aws/credentials
aws sts get-caller-identity

terraform apply -replace='module.workstation[0].aws_instance.workstation'


docker run -d \
  --name vault \
  --restart unless-stopped \
  -p 8200:8200 \
  -e VAULT_DEV_ROOT_TOKEN_ID=training-root-token \
  -e VAULT_DEV_LISTEN_ADDRESS=0.0.0.0:8200 \
  hashicorp/vault:latest


  export VAULT_ADDR="http://10.20.1.146:8200"
  vault login -method=aws role=workstation
  vault kv get -mount=training students/student01


   ssh-keygen -f ~/.ssh/known_hosts -R 184.192.30.25

   sudo su - student01
   aws sts get-caller-identity
```
