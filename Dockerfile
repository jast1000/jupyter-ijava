# Download de ubuntu image
FROM ubuntu

# Create the jypyter user
RUN useradd -ms /bin/bash jupyter

# Create the work directory
RUN mkdir /home/jupyter/work

# Update all!!
RUN apt update

# Install python, java and other tools
RUN apt install -y unzip wget python3-pip python3-dev openjdk-11-jdk

# Update pip
RUN pip3 install --upgrade pip

# Install virtualenv
RUN pip install virtualenv

# Set the working dir
WORKDIR /opt

# Create a env
RUN virtualenv jupyter_ijava

# Set the working dir to install jupyter
WORKDIR /opt/jupyter_ijava

# Prepare the env
RUN /bin/bash -c "source bin/activate"

# Install jupyter
RUN pip install jupyter

# Download ijava kernel
RUN wget https://github.com/SpencerPark/IJava/releases/download/v1.3.0/ijava-1.3.0.zip

# Unzip the file
RUN unzip ijava-1.3.0.zip

# Install the kernel
RUN python3 install.py --sys-prefix

# Add the entrypoint file to start the container
ADD entrypoint.sh /usr/local/bin

# Set the permissions to entrypoint file
RUN chmod +x /usr/local/bin/entrypoint.sh

# Change the current user
USER jupyter
WORKDIR /home/jupyter

# Set the available ports 
EXPOSE 8888

# Set the volumes
VOLUME ["/home/jupyter"]

# Execute jupyter with parameters
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]