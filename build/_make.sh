#! /bin/bash

###############################################################################
# Usage: ./_make.sh <mode>                                                    #
# Valid modes:                                                                #
#   - init                                                                    #
#   - fix-remote                                                              #
#   - build                                                                   #
#   - pre-deploy                                                              #
#   - deploy                                                                  #
###############################################################################


###############################################################################
# Helper Functions                                                            #
###############################################################################

TMP=_tmp.out
# Get the title of the curriculum.
title () {
    cat build/title.txt
}

# Get the URL of the GitHub repo for the curriculum.
repo () {
    python build/tweaks/fork.py
}

# Get the URL of the GitHub repo, with / escaped to \/ for sed.
repo_escaped () {
    repo | sed -e "s/\//\\\\\//g"
}

# Get the chosen URL path slug for deployment.
slug () {
    cat build/slug.txt
}

# Empty if an upstream remote doesn't exist
should_create_upstream () {
    git remote -v | grep upstream
}

# Run a git commit with the arguments given"
quiet_git () {
    if [ $# -ne 1 ] ; then # Validate arguments
        echo "Wrong number of arguments to quiet_git(). Wanted 1, got $#."
        return 1
    fi
    output=$(echo "$1" | xargs git > $TMP 2>&1) # save the output
    if [ $output ]; then
        # If the ouput has an error message because of no changes, silence it.
        if [ cat $TMP | grep "no changes" | wc -l -eq 0 ]; then
            cat $TMP # A real error.  Echo it.
        fi
    fi
    rm $TMP
}


###############################################################################
# Validate Arguments                                                          #
###############################################################################
if [ $# -ne 1 ] ; then
    echo "Wrong number of arguments passed. Wanted 1, Got $#."
fi


###############################################################################
# ./_make.sh init                                                             #
#                                                                             #
# Prompt the user for a title, and fill in the markdown template to create    #
# the main markdown file in the root directory.  Save the title of the file   #
# to build/title.txt                                                          #
###############################################################################
if [ "$1" = "init" ] ; then
    if [ ! -f "build/title.txt" ]; then

        # Get the name
        printf "Please enter the name of your curriculum: "
        read TITLE

        # Save it to build/title.txt
        echo $TITLE > build/title.txt

        # Create the markdown file in the root directory
        echo "Filling in templates..."
        sed -e "s/{{ title }}/$TITLE/g" -e "s/{{ repo }}/$(repo_escaped)/g" "build/template.md" > "$TITLE.md"

        # Commit build/title.txt to GitHub
        echo "Syncing build/title.txt with $(repo)"
        quiet_git 'reset HEAD .'
        quiet_git 'add build/title.txt'
        quiet_git 'commit -m "Initialize repo"'
        quiet_git 'push -u origin master'
    fi


###############################################################################
# ./_make.sh fix-remotes                                                      #
#                                                                             #
# Move origin to be upstream, and set origin to be the GitHub URL they paste. #
###############################################################################
elif [ "$1" = "fix-remotes" ] ; then
    # Only ask for this if upstream doesn't already exist.
    if [ -z "$(should_create_upstream)" ] ; then
        echo "Make a new repo on GitHub, and find it's SSH / HTTPS url, and paste it below."
        printf "Paste GitHub URL: "
        read REMOTE
        quiet_git "remote rename origin upstream"
        quiet_git "remote add origin $REMOTE"
    fi


###############################################################################
# ./_make.sh build                                                            #
#                                                                             #
# Make output.html from the markdown file in the root dir.                    #
###############################################################################
elif [ "$1" = "build" ] ; then
    TITLE_TMP="$(title)"

    # copy over all needed files into build/
    cd build
    cp "../$TITLE_TMP.md" .
    cp template.css "$TITLE_TMP.css"

    # run md2html
    python md2html.py "$TITLE_TMP.md"

    # copy output to the root dir, and delete intermediate files
    mv "$TITLE_TMP.html" ../output.html
    rm -f "$TITLE_TMP.css" "$TITLE_TMP.md"


###############################################################################
# ./_make.sh pre-deploy                                                       #
#                                                                             #
# Choose a slug for learn.adicu.com/<your_slug_here>, save it in              #
# build/slug.txt, make the folder on the remote as needed, and save           #
# build/slug.txt to GitHub                                                    #
###############################################################################
elif [ "$1" = "pre-deploy" ] ; then

    # We don't need to do any of this if we've already created build/slug.txt
    if [ ! -f "build/slug.txt" ]; then
        echo "Enter a path slug for your curriculum: \"$(title)\".  Your curriculum will be deployed to learn.adicu.com/<your-slug-here>. Your slug should contain only lowercase letters, numbers, and dashes."
        echo "Examples: python, javascript, advanced-java"

        # Read in a new, valid slug
        while [ 1 ]; do
            # Read in the slug
            printf "Enter a slug: "
            read SLUG
            echo $SLUG > build/slug.txt

            if [[ ! $SLUG =~ ^[0-9a-z-]*$ ]]; then
                # The filename is invalid
                echo "$SLUG is not valid.  Slugs must contain lowercase letters, numbers, and dashes."
            # try to make the directory
            elif [ -n "$(ssh adi-website "mkdir /srv/learn/public_html/$SLUG" 2>&1)" ]; then
                # A directory already exists with that name.  Sorry!
                echo "Something already exists at learn.adicu.com/$SLUG.  Try another slug."
            else
                break  # The filename is valid!
            fi
        done

        # Commit build/slug.txt to GitHub
        echo "Syncing build/slug.txt with $(repo)"
        quiet_git 'reset HEAD .'
        quiet_git 'add build/slug.txt'
        quiet_git 'commit -m "Setup Deploy"'
        quiet_git 'push -u origin master'
    fi


###############################################################################
# ./_make.sh deploy                                                           #
#                                                                             #
# Deploy to adi-website.                                                      #
###############################################################################
elif [ "$1" = "deploy" ] ; then
    if scp output.html adi-website:/srv/learn/public_html/$(slug)/index.html > /dev/null; then
        echo "Deployed to http://learn.adicu.com/$(slug)"
    fi
fi
