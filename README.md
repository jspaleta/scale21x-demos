# scale21x-demos
Demos for SCALE 21x March 13-17 2024


## Submodules
The demos make use of a modified version of the Cilium starwars service docker image
After cloning this repo you'll need to `git submodule update` to pull in the correct commit from the `jspaleta/starwars-docker` repo
### starwars-docker
You'll want to follow the build instructions in the starwars-docker submodule and build a local image tagged as `local/starwars-docker:v0.1"
This local image will be loaded into cluster environment and force the basis of demo services.

## Demo Environments

### imperial-gateway
This environment uses Cilium's implementation of Gateway API to implement a shared gateway in the cluster.
HTTPRoutes for both the deathstar and eye-of-palpatine namespaces are used to redirect landing request traffic to a new
centrally managed landing request service.

You'll need to manually create DNS records in your environment for the hostnames references in the shared Gateway resource.

### imperial-clustermesh
This environment uses Linkerd's experimental implementation of the GAMMA initative's extension of Gateway API to support service-mesh HTTPRoutes.
Service-mesh HTTPRoutes refer to Service resources as the ParentRef instead of a Gateway resource. The installed service-mesh controller will parse the service-mesh HTTPRputes and redirect traffic

Examples of both consumer and producer routes are provided for the lrequest-v1 service.

Note: Linkerd's implementation currently has a character limit associated with namespace + HTTPRoute name. If strings are "too long" the HTTPRoute will fail to work.
It's experimental, I'm just excited it works at all and I can build a demo using it.

## Kind Cluster
These demos were developed for Kind cluster using Kubernetes 1.29.2 node images.  
To reduce live demo bring up time, the install scripts for each cluster environment includes instructions to pre-load local copies of docker images into the kind cluster.

