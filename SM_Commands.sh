secret=$(aws secretsmanager get-secret-value --secret-id MyFirstSecret | jq .SecretString | jq fromjson)   
echo $secret
user=$(echo $secret | jq -r .username)
echo $user
password=$(echo $secret | jq -r .password) 
endpoint=$(echo $secret | jq -r .host)     
port=$(echo $secret | jq -r .port)         
sudo yum install mysql -y
