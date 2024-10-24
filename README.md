This repository details a morning of learning and messing with GitHub actions, golang, and Docker. Coming from a Concourse CI background, many Actions behaviors were similar... but some where foreign.

Features:
* Build/test on PR and release on tag
* Sets version and commit info based on tag, defaults to 'testing' version and 'local' commit unless run from Github Action
* Uses goreleaser to create/upload releases
  * Cross compiles many OS/arch combinations
  * Populates release notes with `.release_info.md` file
* Builds scratch-based Docker container with the binary ONLY
* Helper script (`scripts/do_release.sh`) to tag by just incrementing 'major', 'minor', and 'patch'

Dependencies:
* To push to Docker Hub, set `DOCKERHUB_TOKEN` and `DOCKERHUB_USERNAME` repository secrets

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
  - Tip: Consider generating scratch images since these are golang binaries and have everything they need
  - Note: I intend to reuse this workflow unchanged across my projects - this is why there is a step to dynamically determine the project name early, and referenced afterwards
  - If you care about having nice Docker tags like maj.min, latest, etc... use the metadata Action and only take action when operating on a tag

