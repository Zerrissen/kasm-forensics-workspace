FROM kasmweb/core-ubuntu-focal:1.14.0
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########

RUN apt-get update
RUN apt-get install -y autopsy firefox sublime-text

WORKDIR /tmp
RUN wget https://raw.githubusercontent.com/kasmtech/workspaces-images/develop/src/ubuntu/install/cleanup/cleanup.sh && \
    bash cleanup.sh && \
    rm -rf cleanup.sh


######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000