# Docker image R + Stata for Onyxia

## Purpose

Onyxia does not have Stata. This adds it.

## Build

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

You can optionally rename and save this configuration.

### Launch the service.

Then launch the service. Once logged in, open a terminal in Rstudio, and run

```bash
/home/onyxia/work/statalic.sh
```
