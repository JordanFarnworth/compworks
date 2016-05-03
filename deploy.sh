#!/bin/bash
bundle exec rake assets:precompile ENV=production
git add -u
git commit -m \""$1"\"
git push $2 master -f
