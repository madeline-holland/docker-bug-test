#!/bin/bash
rm out/before
rm out/after

docker compose up -d
docker compose exec test /bin/bash -c 'ls -alh /tmp/ > /tmp/out/before'

echo "Before:"
cat out/before

echo aaa >> test.md



git checkout -f -- test.md

docker compose exec test /bin/bash -c 'ls -alh /tmp/ > /tmp/out/after'

echo "After"
cat out/after
