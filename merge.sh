#!/bin/bash

branch="release/v"
array_=()
list=`git branch`
j=0
for i in $list; do
        if [ "$branch = ${i[@]::9}" -a ${i[@]: -1} -ne 0 ]; then
                count=${i[@]: -1}
                array_[$count]=$i
                j=$(( $j + 1))
        elif [ "$branch = ${i[@]::9}" -a "${i[@]: -1} -eq 0" ]; then
                count=${i[@]: -2}
                array_[$count]=$i
                j=$(( $j + 1))
        fi
done
current_release_branch=${array_[@]: -1}
current_count=`echo  ${current_release_branch[@]: -1}`
new_count=$(( $current_count + 1 ))
if [ "$current_count -ne 0" -a  "${#current_release_branch} = 12"  ]; then
        new_release_branch=`echo "$current_release_branch"  | sed s/./$new_count/12`
        echo "New release branch is: $new_release_branch"
elif [  "$current_count -eq 0" -a  "${#current_release_branch} = 13" ]; then
        new_count=1
        new_release_branch=`echo "$current_release_branch"  | sed s/./$new_count/13`
        echo $new_release_branch
elif [ "$current_count -ne 0" -a  "${#current_release_branch} = 13" -a "$current_count -ne 9"  ]; then
        new_release_branch=`echo "$current_release_branch"  | sed s/./$new_count/13`
        echo "New release branch is: $new_release_branch"
elif [ "$current_count -eq 9" -a  "${#current_release_branch} = 13"  ]; then
        count12="${current_release_branch[@]:11:1}"
        echo $count12
        new_release_branch=`echo "$current_release_branch"  | sed s/./$(( $count12 + 1 ))/12 | sed s/./0/13`
        echo "New release branch is: $new_release_branch"
fi
commit_merge01="Merge $current_release_branch branch to master branch."
commit_merge02="Merge master branch to develop branch."
tag="$current_release_branch"

git checkout  $current_release_branch
git pull origin $current_release_branch
git checkout master
git pull origin master
git merge -m "$commit_merge01" $current_release_branch
git fetch --tags
git tag $tag
git push origin master
git push -d origin $current_release_branch
git branch -d $current_release_branch
git checkout develop
git pull origin develop
git merge -m "$commit_merge02" master
git checkout -b $new_release_branch
git push --set-upstream origin $new_release_branch
