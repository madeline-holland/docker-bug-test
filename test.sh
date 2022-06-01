#!/bin/bash
echo "Cleaning up from prior runs"
rm out/*

docker compose up -d
docker compose exec test /bin/bash -c 'ls -alh /tmp/ > /tmp/out/before'

echo "Before:"
cat out/before

echo "Making a change to test.md"
echo aaa >> test.md
docker compose exec test /bin/bash -c 'ls -alh /tmp/ > /tmp/out/change'
cat out/change

echo "Moving test.md"
mv test.md /tmp/test.md

echo "Moving test.md back"
mv /tmp/test.md test.md

docker compose exec test /bin/bash -c 'ls -alh /tmp/ > /tmp/out/movement'
cat out/movement

echo "Checking out to undo the change"
git checkout -f -- test.md

docker compose exec test /bin/bash -c 'ls -alh /tmp/ > /tmp/out/checkout'

echo "After Git checkout"
cat out/checkout

docker compose down
