#!/bin/bash

git config --global user.name "jeyhun-gadirov"
git config --global user.email "jeyhun.gadirov@epicgames.com"
echo "Host *" > ~/.ssh/config
echo "    StrictHostKeyChecking no" >> ~/.ssh/config
echo "IdentityFile ~/.ssh/id_rsa" >> ~/.ssh/config

git fetch
a="origin/release"
list_1=`git branch -r`
count=0
for t in $list_1; do
        if [ ${t[@]::14} = $a ]; then
                array_[$count]=$t
                count=$(( $count + 1 ))
        fi
done
for i in ${array_[@]}; do
        if [ "${i[@]: -1} -ne 0" ]; then
                count=${i[@]: -1}
                array_[$count]=$i
                j=$(( $j + 1))
        elif [ ${i[@]: -1} -eq 0 ]; then
                count=${i[@]: -2}
                array_[$count]=$i
                j=$(( $j + 1))
        fi
done
current_release_branch=${array_[@]: -1}
current_count=`echo  ${current_release_branch[@]: -1}`
new_count=$(( $current_count + 1 ))
if [ "$current_count -ne 0" -a  "${#current_release_branch} = 19"  ]; then
        new_release_branch=`echo "$current_release_branch"  | sed s/./$new_count/19`
elif [  "$current_count -eq 0" -a  "${#current_release_branch} = 20" ]; then
        new_count=1
        new_release_branch=`echo "$current_release_branch"  | sed s/./$new_count/20`
elif [ "$current_count -ne 0" -a  "${#current_release_branch} = 20" -a "$current_count -ne 9"  ]; then
        new_release_branch=`echo "$current_release_branch"  | sed s/./$new_count/20`
elif [ "$current_count -eq 9" -a  "${#current_release_branch} = 20"  ]; then
        count19="${current_release_branch[@]:18:1}"
        new_release_branch=`echo "$current_release_branch"  | sed s/./$(( $count19 + 1 ))/19 | sed s/./0/20`
fi

if [ ${#new_release_branch} = 19 ]; then
        new_release_branch=${new_release_branch[@]: -12}
        tag_vers=${current_release_branch[@]: -5}
else
        new_release_branch=${new_release_branch[@]: -13}
        tag_vers=${current_release_branch[@]: -6}
fi


if [ ${#current_release_branch} = 19 ]; then
        current_release_branch=${current_release_branch[@]: -12}
else
        current_release_branch=${current_release_branch[@]: -13}
fi


remote_repo=$(git remote -v | head -n 1 | cut -f1)

echo "New Release Branch is:  $new_release_branch"
commit_merge01="Merge $current_release_branch branch to master branch."
commit_merge02="Merge master branch to develop branch."
tag="r$tag_vers"

git checkout  $current_release_branch
git pull origin $current_release_branch
git checkout master
git pull origin master
git merge -m "$commit_merge01" $current_release_branch
git fetch --tags
git tag $tag
git push origin master
#git push -d origin $current_release_branch
#git branch -d $current_release_branch
git push $remote_repo $tag
git checkout develop
git pull origin develop
git merge -m "$commit_merge02" master
git push origin develop
echo " Master merged to develop"
-----------------------------------------------------------------------------------------------------------------------------
git checkout -b $new_release_branch
countt=$(echo " ${new_release_branch[@]: -1} ")
if [ $countt -ne 0 ];
then
PACKAGE_VERSION=$(cat package.json | grep version | head -1 | awk -F: '{ print $2 }' | sed 's/[\",]//g' | tr -d '[[:space:]]')
NEW_VERSION="0.0.0"
NEW_VERSION=$(echo $NEW_VERSION  | sed s/./$(( $countt + 0 ))/3 | sed s/./0/5)
sed -i "s/\"version\": \"$PACKAGE_VERSION\"/\"version\": \"$NEW_VERSION\"/g" package.json
else
countt=$(echo " ${new_release_branch[@]: -2} ")
PACKAGE_VERSION=$(cat package.json | grep version | head -1 | awk -F: '{ print $2 }' | sed 's/[\",]//g' | tr -d '[[:space:]]')
NEW_VERSION="0.0.0"
NEW_VERSION=$(echo $NEW_VERSION  | sed s/./$(( $countt + 0 ))/3 | sed s/./0/6)
sed -i "s/\"version\": \"$PACKAGE_VERSION\"/\"version\": \"$NEW_VERSION\"/g" package.json
fi;
git add package.json
git commit -m "Icrease minor version of package.json file"
git push --set-upstream origin $new_release_branch
