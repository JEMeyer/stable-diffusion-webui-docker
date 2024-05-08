# AUTOMATIC1111's Stable Diffusion WebUI Docker Publisher

This repository automatically publishes Docker images for the [Stable Diffusion WebUI](https://github.com/AUTOMATIC1111/stable-diffusion-webui) project whenever updates are pushed to its master branch.

## Images

Two Docker images are published to the GitHub Container Registry for each update:

- `ghcr.io/jemeyer/stable-diffusion-webui:latest` - Image tagged with `latest` pointing to the most recent commit.
- `ghcr.io/jemeyer/stable-diffusion-webui:VERSION` - Image tagged with the specific released version from the source repo.
- `ghcr.io/jemeyer/stable-diffusion-webui:hash_COMMIT_HASH` - Image tagged with the specific commit hash of the source repository. Used for ad-hoc builds

## Usage

### Docker Run

To use the most recent ComfyUI image, pull the `latest` tag:

```bash
docker run -p 8188:8188 ghcr.io/jemeyer/stable-diffusion-webui
```

This will start the server and make it accessible at <http://localhost:8188>.

#### GPU Configuration

If you have an NVIDIA GPU and want to use it with the UI, you can pass the --gpus flag to docker run:

- To use all available GPUs:

```bash
docker run --gpus all -p 8188:8188 ghcr.io/jemeyer/stable-diffusion-webui
```

- To use a specific number of GPUs:

```bash
docker run --gpus 2 -p 8188:8188 ghcr.io/jemeyer/stable-diffusion-webui
```

- To use a specific GPU by its device ID (e.g., GPU 2):

```bash
docker run --gpus device=2 -p 8188:8188 ghcr.io/jemeyer/stable-diffusion-webui
```

Note that you need to have the NVIDIA Container Toolkit installed on your host for GPU passthrough to work.

### Docker Compose

You can also use Stable Diffusion WebUI with Docker Compose. Here's an example docker-compose.yml file:

```yaml
services:
  stable-diffusion-webui:
    image: ghcr.io/jemeyer/stable-diffusion-webui:latest
    ports:
      - 8188:8188
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
```

This configuration will start a container using the latest image and make it accessible at <http://localhost:8188>. It also configures the container to use 1 GPU.

To use a specific GPU, you can use the device_ids property instead of count:

```yaml
reservations:
  devices:
    - driver: nvidia
      device_ids: ["2"]
      capabilities: [gpu]
```

To use all available GPUs, set count to `all`.

Start the container with:

```bash
docker-compose up -d
```

## Update Schedule

This repository checks for updates to the AUTOMATIC1111 master branch on a daily basis. If a new commit has been pushed, a new docker image will be created. If an image for that commit doesn't already exist, a new Docker image will be built and published under the tags `latest`, `hash_<COMMIT>`, and `<VERSION>`, where the version tag will match the release versions on the main repo.

## Contributing

If you encounter any issues with the published Docker images, please open an issue in this repository.

Pull requests to improve the Docker image build process or the GitHub Actions workflow are welcome!

## License

This project is licensed under the GPL-3.0 License - see the [LICENSE](https://github.com/jemeyer/stable-diffusion-webui-docker/blob/main/LICENSE) file for details.
