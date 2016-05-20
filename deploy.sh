#!/bin/bash
git add -u
git commit -m \""$1"\"
git push $2 master -f

git add -A
git reset --hard

bundle exec rake assets:precompile ENV=production
git add -A
git commit -m 'assets'
git push $2 master
