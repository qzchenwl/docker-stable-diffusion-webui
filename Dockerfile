FROM huggingface/transformers-pytorch-cpu:4.18.0

RUN apt update && apt install -y git aria2 wget

WORKDIR /content
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui /content/stable-diffusion-webui
RUN python3 -m pip install --no-cache-dir -r /content/stable-diffusion-webui/requirements_versions.txt

RUN python3 -m pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

VOLUME /content/stable-diffusion-webui/extensions
VOLUME /content/stable-diffusion-webui/models
VOLUME /content/stable-diffusion-webui/outputs
VOLUME /content/stable-diffusion-webui/localizations

EXPOSE 7860

COPY entrypoint.sh /content/entrypoint.sh
ENTRYPOINT ["/content/entrypoint.sh", "-f", "--skip-torch-cuda-test", "--precision", "full", "--no-half", "--use-cpu", "SD", "GFPGAN", "BSRGAN", "ESRGAN", "SCUNet", "CodeFormer", "--all"]
CMD ["--enable-insecure-extension-access"]

