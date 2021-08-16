version=$(cat lib/izi_lightup/version.rb | grep 'VERSION' | sed -e "s:.* = '::" | sed -e "s:'::")
echo "Release version: $version"
tagged=$(git tag | grep "v$version")

# ruby uglify.rb
ruby uglify.rb
git add "app/assets/javascripts/crit-utils/*.min.js"
git commit -m "refresh uglified utils"

if [ "$tagged" != "v$version" ]
then
  echo "Git release v$version not created, creating one..."
  git tag -a "v$version" -m "release v$version"
  git push origin "v$version"
  gem build *.gemspec && gem push *.gem && rm *gem
else
  echo "Release already exists!"
fi
