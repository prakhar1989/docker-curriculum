#! /bin/bash

TMP=.tmp.out
title () {
	cat build/title.txt
}
repo () {
	python build/tweaks/fork.py
}
repo_escaped () {
	repo | sed -e "s/\//\\\\\//g"
}
slug () {
	cat build/slug.txt
}
should_create_upstream () {
	git remote -v | grep upstream
}

quiet () {
	if [ $# -ne 1 ] ; then
		echo "Missing command"
		return 1
	fi
	output=$(echo "$1" | xargs git > $TMP 2>&1)
	if [ $output ]; then
		if [ cat $TMP | grep "no changes" | wc -l -eq 0 ]; then
			cat $TMP
		fi
	fi
	rm $TMP
}


if [ $# -ne 1 ] ; then
	echo "Please provide a parameter."
fi

if [ "$1" = "init" ] ; then
	if [ ! -f "build/title.txt" ]; then
		printf "Please enter the name of your curriculum: "
		read TITLE
		echo $TITLE > build/title.txt
		echo "Filling in templates..."
		sed -e "s/{{ title }}/$TITLE/g" -e "s/{{ repo }}/$(repo_escaped)/g" "build/template.md" > "$TITLE.md"
		echo "Syncing build/title.txt with $(repo)"
		quiet 'reset HEAD .'
		quiet 'add build/title.txt'
		quiet 'commit -m "Initialize repo"'
		quiet 'push -u origin master'
	fi
elif [ "$1" = "fix-remotes" ] ; then
	if [ -z "$(should_create_upstream)" ] ; then
	echo "Make a new repo on GitHub, and find it's SSH / HTTPS url, and paste it below."
	printf "Paste GitHub URL: "
	read REMOTE
	quiet git remote rename origin upstream
	quiet git remote add origin $REMOTE
	fi
elif [ "$1" = "build" ] ; then
	TITLE_TMP="$(title)"
	cd build
	cp "../$TITLE_TMP.md" .
	cp template.css "$TITLE_TMP.css"
	python md2html.py "$TITLE_TMP.md"
	mv "$TITLE_TMP.html" ../output.html
	rm -f "$TITLE_TMP.css" "$TITLE_TMP.md"
elif [ "$1" = "pre-deploy" ] ; then
	if [ ! -f "build/slug.txt" ]; then
		echo "Enter a path slug for your curriculum: \"$(title)\".  It should contain only lowercase letters, numbers, and dashes."
		echo "Examples: python, javascript, advanced-java\n"
		printf "Path: "
		read SLUG
		echo $SLUG > build/slug.txt
		ssh adi-website "mkdir -p /srv/learn/public_html/$SLUG"
		echo "Syncing build/slug.txt with $(repo)"
		quiet 'reset HEAD .'
		quiet 'add build/slug.txt'
		quiet 'commit -m "Setup Deploy"'
		quiet 'push -u origin master'
	fi
elif [ "$1" = "deploy" ] ; then
	if scp output.html adi-website:/srv/learn/public_html/$(slug)/index.html > /dev/null; then
		echo "Deployed to http://learn.adicu.com/$(slug)"
	fi
fi


