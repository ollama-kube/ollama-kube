#!/bin/sh

#   Enable verbose mode to print each command
#   set -x


if ! kubectl get secret ssh-keys > /dev/null 2>&1; then
  kubectl create secret generic ssh-keys --from-file=id_rsa=$HOME/.ssh/id_rsa --from-file=id_rsa.pub=$HOME/.ssh/id_rsa.pub
fi


for dir in $(find . -name containerfile -exec dirname {} \;); do
  name=$(basename "$dir")
  docker build -f "$dir/containerfile" -t "sterling/$name:dev" --target dev --build-arg USER=$USER "$dir"
  docker tag "sterling/$name:dev" "localhost:5000/$name:dev"
  docker push "localhost:5000/$name:dev"
  
  # docker build -f "$dir/containerfile" -t "sterling/$name:latest" --target PROD "$dir"
  # docker push "sterling/$name:latest"
done

