#! /bin/bash

TMP=.tmp.out
title () {
	cat build/title.txt
}
repo () {
	python build/tweaks/fork.py
}
repo_escaped () {
	echo "$(repo)" | sed -e "s/\//\\\\\//g"
}
slug () {
	cat build/slug.txt
}
should_create_upstream () {
	git remote -v | grep upstream
}

quiet () {
	if [ $# -eq 0 ] ; then
		echo "Missing arguments"
		return 1
	fi

	$@ > $TMP 2>&1 || cat $TMP
	rm $TMP
}


if [ $# -ne 1 ] ; then
	echo "Please provide a parameter."
fi

if [ "$1" = "init" ] ; then
	printf "Please enter the name of your curriculum: "
	read TITLE
	echo $(title) > build/title.txt
	echo "Filling in templates..."
	sed -e "s/{{ title }}/$(title)/g" -e "s/{{ repo }}/$(repo)_escaped/g" "build/template.md" > "$(title).md"
	echo "Syncing build/title.txt with $(repo)"
	quiet git reset HEAD .
	quiet git add build/title.txt
	quiet git commit -m "Initialize repo"
	quiet git push -u origin master
elif [ "$1" = "fix-remotes" ] ; then
	if [ -z "$(should_create_upstream)" ] ; then
	echo "Make a new repo on GitHub, and find it's SSH / HTTPS url, and paste it below."
	printf "Paste GitHub URL: "
	read REMOTE
	quiet git remote rename origin upstream
	quiet git remote add origin $REMOTE
	fi
elif [ "$1" = "build" ] ; then
	cd build
	cp "../$(title).md" .
	cp template.css "$(title).css"
	python md2html.py "$(title).md" ;\
	mv "$(title).html" ../output.html
	rm -f "$(title).css" "$(title).md"
elif [ "$1" = "pre-deploy" ] ; then
	echo "Enter a path slug for your curriculum: \"$(title)\".  It should contain only lowercase letters, numbers, and dashes."
	echo "Examples: python, javascript, advanced-java\n"
	printf "Path: "
	read SLUG
	echo $SLUG > build/slug.txt
	ssh adi-website "mkdir -p /srv/learn/public_html/$SLUG"
	echo "Syncing build/slug.txt with $(repo)"
	quiet git reset HEAD .
	quiet git add build/slug.txt
	quiet git commit -m "Setup Deploy"
	quiet git push -u origin master
elif [ "$1" = "deploy" ] ; then
	if scp output.html adi-website:/srv/learn/public_html/$(slug)/index.html > /dev/null; then
		echo "Deployed to http://learn.adicu.com/$(slug)"
	fi
fi


