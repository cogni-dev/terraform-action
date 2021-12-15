FROM archlinux
# Arch tracks changes in their package manager at the same rate as brew on mac does or at least is very close

# This should be arch to get on latest
RUN pacman -Syu --noconfirm aws-cli grep git awk unzip kubectl jq yq curl && \
    rm -rf /var/cache/pacman/

# Installing tfswitch
RUN curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash

# Installing latest stable versions of 0.11, 0.12, 0.13, 0.14, 0.15, 1.0
RUN tfswitch -s 0.11; tfswitch -s 0.12; tfswitch -s 0.13; tfswitch -s 0.14; tfswitch -s 0.15; tfswitch -s 1.0

# check the version on output for visibility as to what was installed
RUN terraform version

ADD *.sh /usr/local/bin/

RUN chmod 755 /usr/local/bin/*.sh && \
    chown root:root /usr/local/bin/*.sh

ENTRYPOINT [ "/usr/local/bin/terraform_plan.sh" ]
