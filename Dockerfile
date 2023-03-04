FROM ubuntu:22.10

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y bash \
                   build-essential \
                   git \
                   curl \
                   ca-certificates \
                   python3 \
                   python3-venv \
                   python3-opencv \
                   python3-pip && \
    rm -rf /var/lib/apt/lists

RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui /content/stable-diffusion-webui

SHELL ["/bin/bash", "-c"]
WORKDIR /content/stable-diffusion-webui
RUN python3 -m venv venv && \
    source venv/bin/activate && \
    pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir torch==1.12.1 torchvision==0.13.1 && \
    python3 launch.py --skip-torch-cuda-test --exit

RUN pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

VOLUME /content/stable-diffusion-webui/extensions
VOLUME /content/stable-diffusion-webui/models
VOLUME /content/stable-diffusion-webui/outputs
VOLUME /content/stable-diffusion-webui/localizations

EXPOSE 7860

COPY entrypoint.sh /content/entrypoint.sh
COPY download-chilloutmix-model.sh /content/download-chilloutmix-model.sh

ENTRYPOINT ["/content/entrypoint.sh"]
CMD ["--listen", "--skip-install", "-f", "--skip-torch-cuda-test", "--skip-version-check", "--no-half", "--use-cpu", "all"]

