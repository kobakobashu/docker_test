# もととなるImage 
FROM pytorch/pytorch

ARG USERNAME=duser
ENV DEBIAN_FRONTEND=noninteractive
ENV WORK_PATH /workspace

# apt-get
RUN apt-get update -qq && \
        apt-get install -y \
            curl git sudo tree vim wget build-essential software-properties-common unzip && \
        apt-get install -y \
            python3 python3-pip && \
        apt-add-repository ppa:fish-shell/release-3 && \
        apt-get update && \
        apt-get install -y fish fonts-powerline && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/* && \
        rm -rf /var/cache/apk/

# python
COPY requirements.txt $WORK_PATH/docker/
ENV PIP_OPTIONS "--no-cache-dir --progress-bar off"
RUN pip3 install -U pip
RUN pip3 install ${PIP_OPTIONS} -r $WORK_PATH/docker/requirements.txt && \
        pip3 install ${PIP_OPTIONS} -U setuptools

# duser setting
ARG USER_ID
ARG GROUP_ID
RUN addgroup --gid $GROUP_ID $USERNAME && \
    adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID $USERNAME && \
    adduser $USERNAME sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER $USERNAME

#dotfiles
ENV DOTFILES_PATH /home/${USERNAME}/dotfiles
RUN git clone https://github.com/tomoino/dotfiles.git $DOTFILES_PATH
RUN chown -R ${USERNAME}:${USERNAME} $DOTFILES_PATH \
  && sudo sh $DOTFILES_PATH/init_docker.sh

# 各種命令を実行するカレントディレクトリを指定
WORKDIR /workspace