# Dockerfile.Lite

# https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/11.7.1/ubuntu2204/devel/cudnn8/Dockerfile
# FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu22.04
# https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/11.7.1/ubuntu2204/base/Dockerfile
FROM nvidia/cuda:11.7.1-base-ubuntu22.04
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y libgl1 libglib2.0-0 wget git git-lfs python3-pip python-is-python3 libcairo2-dev pkg-config python3-dev && rm -rf /var/lib/apt/lists/*

RUN adduser --disabled-password --gecos '' user
RUN mkdir /content && chown -R user:user /content
WORKDIR /content
USER user

RUN pip3 install --upgrade pip
RUN pip install xformers==0.0.16
RUN pip install triton==2.0.0
RUN pip install numexpr

RUN git clone -b v1.9 https://github.com/camenduru/stable-diffusion-webui
ADD --chown=user https://raw.githubusercontent.com/camenduru/stable-diffusion-webui-scripts/main/run_n_times.py /content/stable-diffusion-webui/scripts/run_n_times.py
RUN git clone -b v1.9 https://github.com/camenduru/deforum-for-automatic1111-webui /content/stable-diffusion-webui/extensions/deforum-for-automatic1111-webui
RUN git clone -b v1.9 https://github.com/camenduru/stable-diffusion-webui-images-browser /content/stable-diffusion-webui/extensions/stable-diffusion-webui-images-browser
RUN git clone -b v1.9 https://github.com/camenduru/stable-diffusion-webui-huggingface /content/stable-diffusion-webui/extensions/stable-diffusion-webui-huggingface
RUN git clone -b v1.9 https://github.com/camenduru/sd-civitai-browser /content/stable-diffusion-webui/extensions/sd-civitai-browser
RUN git clone -b v1.9 https://github.com/camenduru/sd-webui-additional-networks /content/stable-diffusion-webui/extensions/sd-webui-additional-networks
RUN git clone -b v1.9 https://github.com/camenduru/sd-webui-tunnels /content/stable-diffusion-webui/extensions/sd-webui-tunnels
RUN git clone -b v1.9 https://github.com/camenduru/batchlinks-webui /content/stable-diffusion-webui/extensions/batchlinks-webui
RUN cd stable-diffusion-webui && git reset --hard

RUN sed -i -e '''/    prepare_environment()/a\    os.system\(f\"""sed -i -e ''\"s/dict()))/dict())).cuda()/g\"'' /content/stable-diffusion-webui/repositories/stable-diffusion-stability-ai/ldm/util.py""")''' /content/stable-diffusion-webui/launch.py
RUN sed -i -e 's/fastapi==0.90.1/fastapi==0.89.1/g' /content/stable-diffusion-webui/requirements_versions.txt
RUN sed -i -e 's/    start()/    #start()/g' /content/stable-diffusion-webui/launch.py
RUN cd stable-diffusion-webui && python launch.py --skip-torch-cuda-test
RUN pip install torchmetrics==0.11.4

ADD --chown=user https://huggingface.co/ckpt/sd15/resolve/main/v1-5-pruned-emaonly.ckpt /content/stable-diffusion-webui/models/Stable-diffusion/v1-5-pruned-emaonly.ckpt

EXPOSE 7860

CMD cd /content/stable-diffusion-webui && python webui.py --xformers --listen --enable-insecure-extension-access --gradio-queue