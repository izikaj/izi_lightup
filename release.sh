version=$(cat lib/izi_lightup/version.rb | grep 'VERSION' | sed -e "s:.* = '::" | sed -e "s:'::")
echo "Release version: $version"
tagget=$(git tag | grep "v$version")

if [ "$tagget" != "v$version" ]
then
  echo "Git release v$version not created, creating one..."
  git tag -a "v$version" -m "release v$version"
  git push origin "v$version"
  gem build *.gemspec && gem push *.gem && rm *gem
else
  echo "Release already exists!"
fi
