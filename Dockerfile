FROM python:3.10-alpine

RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

VOLUME /app/stable-diffusion-webui/extensions
VOLUME /app/stable-diffusion-webui/models
VOLUME /app/stable-diffusion-webui/outputs
VOLUME /app/stable-diffusion-webui/localizations

EXPOSE 7860

CMD ["pip", "install", "requests"]

