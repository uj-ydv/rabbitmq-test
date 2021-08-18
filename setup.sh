sudo su

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash

rpm --import https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc

rpm --import https://packagecloud.io/rabbitmq/erlang/gpgkey

rpm --import https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey

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


# #vi /etc/hosts

# #service rabbitmq-server stop
# #service rabbitmq-server status

# rabbitmqctl add_user guest1 guest1

# rabbitmqctl set_user_tags guest1 administrator

# rabbitmqctl set_permissions -p / guest1 ".*" ".*" ".*"

# #######Clustering after VM's have RabbitMQ#######
# ##Setup /etc hosts
# #On all nodes############################
# rabbitmqVM2 20.92.161.159
# rabbitmqVM1 20.92.161.93
# ############################
# sudo rabbitmqctl stop_app
# sudo rabbitmqctl reset
# sudo rabbitmqctl join_cluster rabbit@*master node hostname*
# sudo rabbitmqctl start_app

# ##<<<<---------------------------------------------------/etc/yum.repos.d/rabbitmq.repo------------------------->>>>>>####
# # In /etc/yum.repos.d/rabbitmq.repo

# ##
# ## Zero dependency Erlang
# ##

# [rabbitmq_erlang]
# name=rabbitmq_erlang
# baseurl=https://packagecloud.io/rabbitmq/erlang/el/8/$basearch
# repo_gpgcheck=1
# gpgcheck=1
# enabled=1
# # PackageCloud's repository key and RabbitMQ package signing key
# gpgkey=https://packagecloud.io/rabbitmq/erlang/gpgkey
#        https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc
# sslverify=1
# sslcacert=/etc/pki/tls/certs/ca-bundle.crt
# metadata_expire=300

# [rabbitmq_erlang-source]
# name=rabbitmq_erlang-source
# baseurl=https://packagecloud.io/rabbitmq/erlang/el/8/SRPMS
# repo_gpgcheck=1
# gpgcheck=0
# enabled=1
# # PackageCloud's repository key and RabbitMQ package signing key
# gpgkey=https://packagecloud.io/rabbitmq/erlang/gpgkey
#        https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc
# sslverify=1
# sslcacert=/etc/pki/tls/certs/ca-bundle.crt
# metadata_expire=300

# ##
# ## RabbitMQ server
# ##

# [rabbitmq_server]
# name=rabbitmq_server
# baseurl=https://packagecloud.io/rabbitmq/rabbitmq-server/el/8/$basearch
# repo_gpgcheck=1
# gpgcheck=0
# enabled=1
# # PackageCloud's repository key and RabbitMQ package signing key
# gpgkey=https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey
#        https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc
# sslverify=1
# sslcacert=/etc/pki/tls/certs/ca-bundle.crt
# metadata_expire=300

# [rabbitmq_server-source]
# name=rabbitmq_server-source
# baseurl=https://packagecloud.io/rabbitmq/rabbitmq-server/el/8/SRPMS
# repo_gpgcheck=1
# gpgcheck=0
# enabled=1
# gpgkey=https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey
# sslverify=1
# sslcacert=/etc/pki/tls/certs/ca-bundle.crt
# metadata_expire=300
# ##>>>>