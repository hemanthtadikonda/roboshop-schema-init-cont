FROM         dokken/centos-8
RUN          yum install unzip jq git -y
RUN          curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install && rm -rf aws*
COPY         mongo.repo /etc/yum.repos.d/mongo.repo
RUN          yum install mysql mongodb-org-shell -y
COPY         run.sh /
ENTRYPOINT   [ "bash", "/run.sh" ]

