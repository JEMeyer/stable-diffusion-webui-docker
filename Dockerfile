FROM nvidia/cuda:12.3.2-devel-ubuntu22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    git \
    python3 \
    python3-venv \
    libgl1 \
    libglib2.0-0

# Set the working directory
WORKDIR /app

# Download auto-install script
RUN wget -q https://raw.githubusercontent.com/AUTOMATIC1111/stable-diffusion-webui/master/webui.sh

# Expose the port
EXPOSE 7861

# Create a non-root user
RUN useradd -m appuser

# Switch to the non-root user
USER appuser

# Set the entrypoint to run
ENTRYPOINT ["bash", "webui.sh"]
