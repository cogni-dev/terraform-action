FROM archlinux/base
# Arch tracks changes in their package manager at the same rate as brew on mac does or at least is very close

# This should be arch to get on latest
RUN pacman -Sy --noconfirm aws-cli jq grep git awk unzip kubectl python-pip jq yq && \
    rm -rf /var/cache/pacman/

# Install latest terraform
RUN LATEST=$(curl -s "https://releases.hashicorp.com/terraform/" | grep -Eo 'terraform_[0-9\.]+' | sed 's/terraform_//g' | head -n 1) && \
    curl -sL "https://releases.hashicorp.com/terraform/$LATEST/terraform_${LATEST}_linux_amd64.zip" -o terraform.zip && \
    unzip terraform.zip && rm terraform.zip && \
    chmod 755 /terraform && \
    mv /terraform /usr/bin/terraform

ADD *.sh /usr/local/bin/

RUN chmod 755 /usr/local/bin/*.sh && \
    chown root:root /usr/local/bin/*.sh

RUN useradd terraform && \
    mkdir /home/terraform && \
    chown terraform:terraform /home/terraform

USER terraform

ENTRYPOINT [ "/usr/local/bin/terraform_plan.sh" ]