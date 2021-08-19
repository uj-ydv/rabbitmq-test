sudo su

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash

rpm --import https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc

rpm --import https://packagecloud.io/rabbitmq/erlang/gpgkey

rpm --import https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey

yum install wget

wget https://raw.githubusercontent.com/uj-ydv/rabbitmq-test/main/rabbitmq.repo

cat rabbitmq.repo > /etc/yum.repos.d/rabbitmq.repo

mkdir -p /var/lib/rabbitmq

echo -n "PTNJKSXVOFQXIIRAOPXD" > /var/lib/rabbitmq/.erlang.cookie

chmod 700 /var/lib/rabbitmq/.erlang.cookie

yum update -y

yum -q makecache -y --disablerepo='*' --enablerepo='rabbitmq_erlang' --enablerepo='rabbitmq_server'

yum install socat logrotate -y

yum install --repo rabbitmq_erlang --repo rabbitmq_server erlang rabbitmq-server -y

chkconfig rabbitmq-server on

yum -y install initscripts

firewall-cmd --permanent --add-port={4369,25672,15672,5672,5671,15671}/tcp

firewall-cmd --reload

echo "loopback_users.guest = false\ntotal_memory_available_override_value = 2147483648\nlisteners.tcp.default = 5672\nmanagement.tcp.port = 15672" > /etc/rabbitmq/rabbitmq.conf

rabbitmq-plugins enable rabbitmq_management rabbitmq_federation rabbitmq_federation_management

service rabbitmq-server start

#echo "listeners.ssl.default = 5671\nssl_options.cacertfile = /etc/rabbitmq-tls/ca_certificate.pem\nssl_options.certfile = /etc/rabbitmq-tls/server_certificate.pem\nssl_options.keyfile = /etc/rabbitmq-tls/server_key.pemssl_options.verify = verify_peer\nssl_options.fail_if_no_peer_cert = true