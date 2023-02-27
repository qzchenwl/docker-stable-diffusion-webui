FROM ubuntu:22.10

RUN apt update && \
    apt install -y bash \
                   build-essential \
                   git \
                   curl \
                   ca-certificates \
                   python3 \
                   python3-opencv \
                   python3-pip && \
    rm -rf /var/lib/apt/lists
RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir torch==1.13.0+cpu torchvision==0.14.0+cpu --extra-index-url https://download.pytorch.org/whl/cpu

WORKDIR /content
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui /content/stable-diffusion-webui
RUN pip3 install --no-cache-dir -r /content/stable-diffusion-webui/requirements_versions.txt

RUN pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

VOLUME /content/stable-diffusion-webui/extensions
VOLUME /content/stable-diffusion-webui/models
VOLUME /content/stable-diffusion-webui/outputs
VOLUME /content/stable-diffusion-webui/localizations

EXPOSE 7860

COPY entrypoint.sh /content/entrypoint.sh
ENTRYPOINT ["/content/entrypoint.sh", "-f", "--skip-torch-cuda-test", "--precision", "full", "--no-half", "--use-cpu", "SD", "GFPGAN", "BSRGAN", "ESRGAN", "SCUNet", "CodeFormer", "--all"]
CMD ["--enable-insecure-extension-access"]

