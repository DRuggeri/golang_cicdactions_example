This repository details a morning of learning and messing with GitHub actions, golang, and Docker. Coming from a Concourse CI background, many Actions behaviors were similar... but some where foreign.

I've learned a few things in building the workflow file.
- Build/Test a go project
  - Using the available setup-go action was simple and permits easily running your test suite across multiple versions and OSs
  - Initial investigation did not indicate a way to run test suites for an OS across multiple architectures. This is probably not an issue if you are building against all of these architectures for release later on, as the only failures I've found are caused by use of system calls unavailable on certain os/arch combinations (which would fail compile).
- Release the result
  - After much monkeying with [goreleaser](https://github.com/goreleaser/goreleaser) I've decided I like it
  - Tip: If you don't care for building tar/zip files, set archives format to `binary`
  - Tip: The goreleaser configuration contained herein will set Version and Commit variables. This allows you to pull information in from the tags/commits in the repo during build rather than having to hard-code version info in your source code
- Push to the Docker registry
  - This was the most difficult part... the Docker and GitHub action doco leaves a bit to be desired
  - To push to GHCR and Docker, you will need to set the image names manually if your ID on the two systems differ
  - Tip: You **CAN NOT** use a secret for DOCKERHUB_USERNAME. It will get masked by GitHub Actions and eaten along the pipeline. Sign of the problem: `failed with: error: invalid tag "***/:v0.0.4": invalid reference format`. In this case, druggeri (my DockerHub ID) was masked.
  - Tip: Consider generating scratch images since these are golang binaries and have everything they need
  - Note: I intend to reuse this workflow unchanged across my projects - this is why there is a step to dynamically determine the project name early, and referenced afterwards
  - If you care about having nice Docker tags like maj.min, latest, etc... use the metadata Action and only take action when operating on a tag
