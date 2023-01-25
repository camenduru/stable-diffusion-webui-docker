# https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/11.7.1/ubuntu2204/devel/cudnn8/Dockerfile
FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu22.04
ENV DEBIAN_FRONTEND noninteractive

WORKDIR /content

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y libgl1 libglib2.0-0 wget git git-lfs python3-pip python-is-python3 && pip3 install --upgrade pip
RUN pip install https://github.com/camenduru/stable-diffusion-webui-colab/releases/download/0.0.16/xformers-0.0.16+814314d.d20230118-cp310-cp310-linux_x86_64.whl
RUN pip install --pre triton
RUN pip install numexpr

RUN git clone -b v1.6 https://github.com/camenduru/stable-diffusion-webui && cd stable-diffusion-webui && sed -i -e 's/    start()/    #start()/g' launch.py && python launch.py --skip-torch-cuda-test

ADD https://raw.githubusercontent.com/camenduru/stable-diffusion-webui-scripts/main/run_n_times.py /content/stable-diffusion-webui/scripts/run_n_times.py
RUN git clone https://github.com/camenduru/deforum-for-automatic1111-webui /content/stable-diffusion-webui/extensions/deforum-for-automatic1111-webui
RUN git clone https://github.com/yfszzx/stable-diffusion-webui-images-browser /content/stable-diffusion-webui/extensions/stable-diffusion-webui-images-browser
RUN git clone https://github.com/camenduru/stable-diffusion-webui-huggingface /content/stable-diffusion-webui/extensions/stable-diffusion-webui-huggingface
RUN git clone https://github.com/camenduru/sd-civitai-browser /content/stable-diffusion-webui/extensions/sd-civitai-browser

ADD https://huggingface.co/ckpt/anything-v3-vae-swapped/resolve/main/anything-v3-vae-swapped.ckpt /content/stable-diffusion-webui/models/Stable-diffusion/anything-v3-vae-swapped.ckpt

RUN adduser --disabled-password --gecos '' user
RUN chown -R user:user /content
RUN chmod -R 777 /content
USER user

EXPOSE 7860

CMD cd /content/stable-diffusion-webui && python webui.py --xformers --listen --enable-insecure-extension-access
