FROM python:3.10-alpine

RUN apk update && apk add git aria2 wget

WORKDIR /content
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui /content/stable-diffusion-webui
RUN aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://civitai.com/api/download/models/11745 -d /content/stable-diffusion-webui/models/Stable-diffusion -o chilloutmix_NiPrunedFp32Fix.safetensors
RUN wget --content-disposition https://civitai.com/api/download/models/14014 -P /content/stable-diffusion-webui/models/Lora && \
    wget --content-disposition https://civitai.com/api/download/models/12050 -P /content/stable-diffusion-webui/models/Lora && \
    wget --content-disposition https://civitai.com/api/download/models/11829 -P /content/stable-diffusion-webui/models/Lora && \
    echo 'Downloaded lora models'
RUN cd /content/stable-diffusion-webui && pip install -r requirements_versions.txt

RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

VOLUME /app/stable-diffusion-webui/extensions
VOLUME /app/stable-diffusion-webui/models
VOLUME /app/stable-diffusion-webui/outputs
VOLUME /app/stable-diffusion-webui/localizations

EXPOSE 7860

CMD ["pip", "install", "requests"]

