# SystemRescue Website

## Project website
Homepage: https://www.system-rescue.org/

## Overview
This git repository contains the sources of the SystemRescue website. These
sources are used to build the static website using [Hugo](https://gohugo.io/).

## Branches
There are two long-term branches in this git repository:
* The "main" branch corresponds to the latest SystemRescue version which has
  been officially released. The website is updated automatically from the "main"
  branch when changes are merged into the "main" branch.
* The "next" branch corresponds to the latest changes which have been merged
  but are not yet part of the latest official release.

Changes should be made by raising a merge requests against the "next" branch.
After a new official release of SystemRescue, the "next" branch will be merged
into the "main" branch, so the website reflects the latest version.

This project uses GitLab CI/CD to validate changes pushed to feature branches,
and to autoamtically update the website when changes are merged into "main".

## Usage
* First you have to install [Hugo](https://gohugo.io/). As it is a golang
  project, it comes with no dependencies, hence it can be easily installed as a
  single static binary. You can either install it using a system package
  management system, or you can just download the archive file, extract it,
  and copy the static binary to a folder which is in your PATH so the shell
  can find this program.
* You can make changes in your local copy, and before you try to commit your
  changes you should make sure these changes are working as expected. This can
  be achieved easily by running "hugo server" in your shell while the git
  workspace is the current directory. You can then connect to
  http://localhost:1313 using your web browser to see how the website appears
  with your local changes.
* When you are happy with your changes, you can create a feature branch, commit
  your changes, and consider raising a merge request if you plan to contribute
  these changes.
