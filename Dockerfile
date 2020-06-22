FROM ubuntu:bionic

COPY ./ansible /ansible
WORKDIR /ansible

# Install prerequisities for Ansible
RUN apt-get update && \
    apt-get -y install openssh-client && \
    apt-get -y install python3 python3-nacl python3-pip libffi-dev && \
    pip3 install ansible && \
    useradd -ms /bin/bash vagrant && \
    chown -R vagrant:vagrant /ansible

USER vagrant

# Run ansible to configure things
#RUN ansible-playbook /ansible/playbook.yml
