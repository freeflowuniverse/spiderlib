set -ex
rm -rf _docs
rm -rf docs
set +ex
v fmt -w src
set -ex


pushd src
v doc -m . -f html -readme -comments -no-timestamp -o ../
popd

mv _docs docs
open docs/index.html
