#!/usr/bin/env bash

function exit_with_error() {
   echo "ERROR: $1"
   exit 1
}

branch="dev"
gitDirectory="/home/frontend/agis2-frontend/.git"
timestamp=`date +"%Y-%m-%d"`
release="/home/frontend/deploy/$timestamp"
wwwDirectory="/home/frontend/www"

#Remove release folder
sudo rm $release -r

printf "\n"
echo "Deploying to $release"

mkdir $release || exit_with_error "Unable to create directory $release"

git --work-tree $release --git-dir=$gitDirectory pull origin $branch
git --work-tree $release --git-dir=$gitDirectory checkout $branch -f

if [ "$?" == "1" ]; then
	exit_with_error "Git checkout failed"
fi

echo "Checked out latest files"

cd $release

if npm install --loglevel "error"; then

   echo "Updated npm dependencies"

   npm run build:prod

   for f in $release/dist/*; do
        bname=$(basename "$f")
        echo $bname
        printf "\n"
   done

   echo "Deployment complete"

else
    exit_with_error "Unable to update npm dependencies.  Check npm_debug.log"
fi

