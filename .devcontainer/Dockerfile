FROM mcr.microsoft.com/devcontainers/python:3.12

LABEL org.opencontainers.image.description DESCRIPTION="Microsoft Python 3.12 Dev Container, tailored for League projects"

ARG VNC_RESOLUTION=600x600x16

# [Optional] Allow the vscode user to pip install globally w/o sudo
ENV PIP_TARGET=/usr/local/pip-global
ENV PYTHONPATH=${PIP_TARGET}:${PYTHONPATH}
ENV PATH=${PIP_TARGET}/bin:${PATH}

RUN mkdir -p ${PIP_TARGET} \
     && chown vscode:root ${PIP_TARGET} \
     && echo "if [ \"\$(stat -c '%U' ${PIP_TARGET})\" != \"vscode\" ]; then chown -R vscode:root ${PIP_TARGET}; fi" \
         | tee -a /root/.bashrc /home/vscode/.bashrc /root/.zshrc >> /home/vscode/.zshrc 

# copy dependency sync script for session and package management
COPY ./.devcontainer/sync_deps.py /workspaces/session/post-start/

# copy requirements list into layer of dev image
COPY requirements.txt /workspaces/session/
RUN python -m pip install --upgrade pip
RUN pip --disable-pip-version-check --no-cache-dir install -r /workspaces/session/requirements.txt

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update \
#     && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# Create directories for extensions
RUN mkdir -p /app/extensions
RUN mkdir -p /vscode/extensionsCache/


USER vscode

# Stave student from being confused by Git asking to make this decision. 
RUN git config --global pull.rebase true

# newline after very long shell prompt
RUN echo 'export PS1="${PS1}\n$ "' >> ~/.bashrc
USER root
