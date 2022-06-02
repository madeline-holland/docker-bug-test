#!/bin/bash

rebuild () {
  docker compose down -v &> /dev/null
  docker compose up -d -V --quiet-pull &> /dev/null
}

docker compose up -d -V --quiet-pull &> /dev/null
echo 'Cleaning up from prior runs'
docker compose exec test /bin/bash -c "rm /tmp/out/*"
docker compose exec test /bin/bash -c "ls -ogZ /tmp/ | awk '{if(NR>1)print}' > /tmp/out/before"

echo '---'
echo 'Before:'
echo
cat out/before | awk '{if ($2==1) {$2="\033[32m"$2"\033[0m";} else {$2="\033[31m"$2"\033[0m";} print $0 }'
echo "---"
echo

echo '###'
echo 'Making a change to test.md'
echo
echo 'Before:'
docker compose exec test /bin/bash -c "ls -ogZ /tmp/ | awk '{if(NR>1)print}' > /tmp/out/change-before"
cat out/change-before | awk '{if ($2==1) {$2="\033[32m"$2"\033[0m";} else {$2="\033[31m"$2"\033[0m";} print $0 }'

echo aaa >> test.md
docker compose exec test /bin/bash -c "ls -ogZ /tmp/ | awk '{if(NR>1)print}' > /tmp/out/change"
echo

echo 'After:'
cat out/change | awk '{if ($2==1) {$2="\033[32m"$2"\033[0m";} else {$2="\033[31m"$2"\033[0m";} print $0 }'
echo "---"

rebuild

echo
echo '###'
echo 'Moving test.md out of this folder and back'
echo
echo 'Before:'
docker compose exec test /bin/bash -c "ls -ogZ /tmp/ | awk '{if(NR>1)print}' > /tmp/out/movement-before"
cat out/movement-before | awk '{if ($2==1) {$2="\033[32m"$2"\033[0m";} else {$2="\033[31m"$2"\033[0m";} print $0 }'
echo

mv test.md /tmp/test.md
mv /tmp/test.md test.md
echo 'After:'
docker compose exec test /bin/bash -c "ls -ogZ /tmp/ | awk '{if(NR>1)print}' > /tmp/out/movement"
cat out/movement | awk '{if ($2==1) {$2="\033[32m"$2"\033[0m";} else {$2="\033[31m"$2"\033[0m";} print $0 }'
echo "---"

rebuild

echo
echo '###'
echo 'Git Checkout'
echo
echo 'Before:'
docker compose exec test /bin/bash -c "ls -ogZ /tmp/ | awk '{if(NR>1)print}' > /tmp/out/checkout-before"
cat out/checkout-before | awk '{if ($2==1) {$2="\033[32m"$2"\033[0m";} else {$2="\033[31m"$2"\033[0m";} print $0 }'
echo 
echo aaa >> test.md
git checkout -f -- test.md
docker compose exec test /bin/bash -c "ls -ogZ /tmp/ | awk '{if(NR>1)print}' > /tmp/out/checkout"

echo 'After:'
echo
cat out/checkout | awk '{if ($2==1) {$2="\033[32m"$2"\033[0m";} else {$2="\033[31m"$2"\033[0m";} print $0 }'
echo '---'
docker compose down -v &> /dev/null
