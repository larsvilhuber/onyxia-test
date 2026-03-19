# Docker image with Stata for Onyxia

## Purpose

[Onyxia (SSPCloud)](https://datalab.sspcloud.fr/) does not have Stata. This adds it to a vanilla Rstudio image, and to a very complete VSCode image.

## Automated Build (GitHub Actions)

This repository includes a GitHub Actions workflow (`.github/workflows/docker-build.yml`) that automatically builds and pushes the Docker image to Docker Hub whenever changes are pushed to the `main` branch or a new tag is created.

### Required Secrets

Configure the following secrets in your GitHub repository under **Settings → Secrets and variables → Actions → Repository secrets**:

| Secret name | Description |
|---|---|
| `DOCKERHUB_USERNAME` | Your Docker Hub username |
| `DOCKERHUB_TOKEN` | Your Docker Hub access token (create one at [hub.docker.com/settings/security](https://hub.docker.com/settings/security)) |

### Image name

The workflow pushes the image to `<DOCKERHUB_USERNAME>/onyxia-stata` with the following tags:

- `latest` — always points to the most recent build from `main`
- `YYYY-MM-DD` - date-based versions.

For the original repository, these can be found at <https://hub.docker.com/repositories/larsvilhuber>.

### Workflow triggers

- **Push to `main`**: builds and pushes the image
- **Pull request against `main`**: builds the image (but does not push)
- **Manual**: can be triggered from the Actions tab using the "Run workflow" button

## Manual Build

### Adjust versions in the Dockerfile

The Dockerfile has a few version variables at the top. Adjust as needed. The base image is a Docker container that already runs on Onyxia, we are just adding as specific version of Stata. 

### Build it

```bash
docker build -t yourspace/image-name:image-tag .
```

### Push it

```bash
docker push yourspace/image-name:image-tag
```

## Configure Onyxia

### Add the Stata license

In your terminal, run 

```bash
cat /usr/local/statanow19/stata.lic | base64 -w 0
```

and copy the output. 

### Configure in Onyxia

IN Onyxia, got to "My Secrets", create a new folder, e.g., `Stata`. 

Then add a new variable, called `STATA_LIC_BASE64`. 

Paste the base64 string you just copied. Be sure that there are no spaces in the string.

### Configure an Onyxia service

Under "Service Catalog", select the `Rstudio` service. 

- Under `Docker image`, select `Custom image`, and add the path of your new container (`yourspace/image-name:image-tag`).
- Under `Vault`, add the "path" to your "secret"  in the field `Secret`, e.g., `Stata`. This makes all variables under that secret available to the service.
- Under `Init`, in the "User initialization script" field, add the raw URL to the initialization script. Replace `main` with your branch name if different:
  ```
  https://raw.githubusercontent.com/larsvilhuber/onyxia-test/main/init.sh
  ```
  This script will automatically configure the Stata license when the service starts.

You can optionally rename and save this configuration.

Two example configurations are here, and should work, if you have configured a `Stata` vault:

- [Rstudio+Stata](https://datalab.sspcloud.fr/launcher/ide/rstudio?name=rstudio-stata&version=2.4.2&s3=region-79669f20&service.image.custom.enabled=true&service.image.custom.version=«larsvilhuber%2Fonyxia-rstudio-stata%3Alatest»&vault.secret=«Stata»&autoLaunch=true)
- [VScode+(stuff)+Stata](https://datalab.sspcloud.fr/launcher/ide/vscode-r-python-julia?name=vscode-r-python-julia-stata&version=2.5.2&s3=region-79669f20&service.image.pullPolicy=«Always»&service.image.custom.enabled=true&service.image.custom.version=«larsvilhuber%2Fonyxia-vscode-r-python-julia-stata%3Alatest»&init.personalInit=«https%3A%2F%2Fraw.githubusercontent.com%2Flarsvilhuber%2Fonyxia-test%2Fmain%2Finit.sh»&vault.secret=«Stata»&autoLaunch=true)

### Launch the service

Then launch the service. The Stata license will be automatically configured on startup using the initialization script.

**Note**: If you need to manually reconfigure the license, you can still run:
```bash
/usr/local/stata/statalic.sh
```
