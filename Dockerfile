FROM continuumio/miniconda3 

WORKDIR /app 

# Update Conda
RUN conda update -n base -c defaults conda 

# create the conda environment
RUN conda create -n tranad python=3.7


# make run commands use the new environment
SHELL ["conda", "run", "-n", "tranad", "/bin/bash", "-c"]

# install the requiremd dependencies from requirements.txt using pip
COPY requirements.txt .
COPY requirements_second.txt .
RUN pip install -r requirements.txt
RUN pip install -r requirements_second.txt
RUN pip3 install torch==1.8.1+cpu torchvision==0.9.1+cpu torchaudio===0.8.1 -f https://download.pytorch.org/whl/torch_stable.html

# copy rest of the application code to the working directory
COPY . .

# activate the environment and run the training
CMD conda run -n tranad /bin/bash -c "python3 preprocess.py SMAP && python3 main.py --model TranAD --dataset SMAP --retrain"
