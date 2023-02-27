FROM python:3.10-alpine

RUN apk update && apk add git aria2 wget

WORKDIR /content
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui /content/stable-diffusion-webui
RUN aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://civitai.com/api/download/models/11745 -d /content/stable-diffusion-webui/models/Stable-diffusion -o chilloutmix_NiPrunedFp32Fix.safetensors
RUN wget -qq --content-disposition https://civitai.com/api/download/models/14014 -P /content/stable-diffusion-webui/models/Lora && \
    wget -qq --content-disposition https://civitai.com/api/download/models/12050 -P /content/stable-diffusion-webui/models/Lora && \
    wget -qq --content-disposition https://civitai.com/api/download/models/11829 -P /content/stable-diffusion-webui/models/Lora && \
    echo 'Downloaded lora models'
RUN pip install -r /content/stable-diffusion-webu/requirements_versions.txt

RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

VOLUME /app/stable-diffusion-webui/extensions
VOLUME /app/stable-diffusion-webui/models
VOLUME /app/stable-diffusion-webui/outputs
VOLUME /app/stable-diffusion-webui/localizations

EXPOSE 7860

CMD ["pip", "install", "requests"]

