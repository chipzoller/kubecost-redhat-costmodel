# Setup args for the Kubecost source image for content extraction
ARG BASE_REGISTRY=gcr.io
ARG BASE_IMAGE=kubecost1/cost-model
ARG BASE_TAG=prod-1.105.2

# Use the upstream Kubecost frontend image to extract content
FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} as base

# Use Red Hat's go-toolset image based on UBI9.
# See https://catalog.redhat.com/software/containers/ubi9/618326f8c0d15aff4912fe0b
FROM registry.access.redhat.com/ubi9:latest

# Apply labels to final layer
LABEL org.opencontainers.image.title="Kubecost Cost Model"
LABEL org.opencontainers.image.description="Backend container for Kubecost"
LABEL org.opencontainers.image.base.name="registry.access.redhat.com/ubi9:latest"
# LABEL org.opencontainers.image.base.digest="sha256:f969e6a4fe53663f3fc8d0ddc17ec2fc3def2af8e68ce7061f016a598798f474"
LABEL org.opencontainers.image.vendor="Stackwatch"

# Copy contents from Kubecost Cost Model base
COPY --from=base /go/bin/app /go/bin/app
COPY --from=base /models /models
COPY --from=base /static /static
COPY --from=base /assets /assets
COPY --from=base /certs /certs

COPY LICENSE /licenses/LICENSE

USER 1001

ENTRYPOINT ["/go/bin/app"]