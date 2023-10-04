FROM kasmweb/core-ubuntu-focal:1.14.0
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########

# update apt repositories so we can grab sublime
RUN wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null && \
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list && \
    apt-get update && \
    # install firefox, sublime
    apt-get install -y firefox sublime-text && \
    # copy sublime desktop icon
    cp /usr/share/applications/sublime_text.desktop $HOME/Desktop/ && \
    chmod +x $HOME/Desktop/sublime_text.desktop && \
    chown 1000:1000 $HOME/Desktop/sublime_text.desktop && \
    # copy firefox desktop icon
    cp /usr/share/applications/firefox.desktop $HOME/Desktop/ && \
    chmod +x $HOME/Desktop/firefox.desktop && \
    chown 1000:1000 $HOME/Desktop/firefox.desktop && \
    cd /tmp && \
    # download and set up dependencies for autopsy/sleuthkit
    wget https://github.com/sleuthkit/autopsy/releases/download/autopsy-4.21.0/autopsy-4.21.0.zip && \
    wget https://raw.githubusercontent.com/sleuthkit/autopsy/develop/linux_macos_install_scripts/install_prereqs_ubuntu.sh && \
    wget https://raw.githubusercontent.com/sleuthkit/autopsy/develop/linux_macos_install_scripts/install_application.sh && \
    wget https://github.com/sleuthkit/sleuthkit/releases/download/sleuthkit-4.12.1/sleuthkit-java_4.12.1-1_amd64.deb && \
    bash install_prereqs_ubuntu.sh && \
    apt install -y /tmp/sleuthkit-java_4.12.1-1_amd64.deb && \
    bash install_application.sh -z autopsy-4.21.0.zip -i ~/autopsy -j /usr/lib/jvm/java-1.17.0-openjdk-amd64 && \
    wget https://raw.githubusercontent.com/kasmtech/workspaces-images/develop/src/ubuntu/install/cleanup/cleanup.sh && \
    bash cleanup.sh && \
    rm -rf /tmp/*


######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000