# POV-Ray Docker Image

This repository packages the official POV-Ray 3.7 Unix build inside a Docker
image so you can render scenes without installing toolchains or dependencies on
your host. The Dockerfile reproduces the documented build steps and clones the
upstream `3.7-stable` branch directly from GitHub.


## Build the image

```bash
docker build \
  -t povray:3.7 \
  --build-arg COMPILED_BY="EvilSpudBoy" \
  .
```

Available build arguments:

| Arg | Purpose | Default |
| --- | --- | --- |
| `POVRAY_REPO` | Git URL to clone | `https://github.com/POV-Ray/povray.git` |
| `POVRAY_REF`  | Branch/tag/commit to checkout | `3.7-stable` |
| `COMPILED_BY` | Populates the mandatory `COMPILED_BY` configure flag | `EvilSpudBoy` |


## Rendering scenes

`povray` is the container entrypoint, so CLI flags go directly to the renderer.
Typical usage binds a directory that contains your `.pov` files:

```bash
docker run --rm \
  -v "$PWD":/scenes \
  -w /scenes \
  povray:3.7 \
  +Imyscene.pov \
  +Ooutput.png \
  +W800 +H600 +FN
```

### Streaming via stdin/stdout

POV-Ray accepts scenes on stdin (`+I-`) and writes image data to stdout (`+O-`),
so the container works nicely in pipelines:

```bash
cat test/sample.pov | docker run --rm -i povray:3.7 \
  +I- +O- +FN +W320 +H240 > sample.png
```

## Example helper

`examples/render.sh` wraps the volume mount workflow shown above. Use it when
you want a quick render from the current directory:

```bash
./examples/render.sh myscene.pov output.png
```

## Tests

`test/test.sh` builds the image (tag defaults to `povray:test`) and renders
`test/sample.pov` through stdin/stdout into `test/output.png`. This script is a
convenient smoke test or CI hook:

```bash
./test/test.sh
```

Feel free to adapt it for your own CI/CD setup.
