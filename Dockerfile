FROM python:3.10-alpine

RUN apk update && apk add git aria2 wget

WORKDIR /content
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui /content/stable-diffusion-webui
RUN aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://civitai.com/api/download/models/11745 -d /content/stable-diffusion-webui/models/Stable-diffusion -o chilloutmix_NiPrunedFp32Fix.safetensors
RUN wget -qq --content-disposition https://civitai.com/api/download/models/14014 -P /content/stable-diffusion-webui/models/Lora && \
    wget -qq --content-disposition https://civitai.com/api/download/models/12050 -P /content/stable-diffusion-webui/models/Lora && \
    wget -qq --content-disposition https://civitai.com/api/download/models/11829 -P /content/stable-diffusion-webui/models/Lora && \
    echo 'Downloaded lora models'
RUN pip install torch==1.13.0+cpu torchvision==0.14.0+cpu && \
    pip install -r /content/stable-diffusion-webui/requirements_versions.txt

RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

VOLUME /content/stable-diffusion-webui/extensions
VOLUME /content/stable-diffusion-webui/models
VOLUME /content/stable-diffusion-webui/outputs
VOLUME /content/stable-diffusion-webui/localizations

EXPOSE 7860

ENTRYPOINT ["/content/stable-diffusion-webui/webui.sh", "--skip-torch-cuda-test", "--precision", "full", "--no-half", "--use-cpu", "SD", "GFPGAN", "BSRGAN", "ESRGAN", "SCUNet", "CodeFormer", "--all"]
CMD ["--enable-insecure-extension-access"]

