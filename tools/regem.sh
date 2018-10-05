#!/bin/bash

gem uninstall hiera-eyaml-gcpkms
rake build
gem install pkg/hiera-eyaml-gcpkms
eyaml -v
