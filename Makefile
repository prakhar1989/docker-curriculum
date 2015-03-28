TITLE=$(shell cat build/title.txt)
REPO=$(shell python build/tweaks/fork.py)
REPO_ESCAPED=$(echo $(REPO) | sed -e "s/\//\\\\\//g")
SHOULD_CREATE_UPSTREAM=$(shell git remote -v | grep upstream)
SLUG=$(shell cat build/slug.txt)

default: output.html

.PHONY:
git:
	@if [ -n "$(SHOULD_CREATE_UPSTREAM)" ]; then \
	echo "Make a new repo on GitHub, and find it's SSH / HTTPS url, and paste it below."; \
	printf 'Paste GitHub URL: '; \
	read REMOTE; \
	git remote rename origin upstream > tmp.out 2>&1 || cat tmp.out; rm tmp.out; \
	git remote add origin $$REMOTE > tmp.out 2>&1 || cat tmp.out; rm tmp.out;\
	fi

build/title.txt: git
	@if [ ! -f "build/title.txt" ]; then \
	printf 'Please enter the name of your curriculum: '; \
	read TITLE; \
	echo $$TITLE > build/title.txt; \
	echo "Filling in templates..."; \
	sed -e "s/{{ title }}/$$TITLE/g" -e "s/{{ repo }}/${REPO_ESCAPED}/g" "build/template.md" > "$$TITLE.md"; \
	echo "Syncing build/title.txt with $(REPO)"; \
	git reset HEAD . > tmp.out 2>&1 || cat tmp.out; rm tmp.out; \
	git add build/title.txt > tmp.out 2>&1 || cat tmp.out; rm tmp.out; \
	git commit -m "Initialize repo" > tmp.out 2>&1 || cat tmp.out; rm tmp.out; \
	git push -u origin master > tmp.out 2>&1 || cat tmp.out; rm tmp.out; \
	fi

output.html: build/title.txt
	@cd build; \
	cp "../$(TITLE).md" .; \
	cp template.css "$(TITLE).css"; \
	python md2html.py "$(TITLE).md" ;\
	mv "$(TITLE).html" ../output.html; \
	rm -f "$(TITLE).css" "$(TITLE).md"

build/slug.txt: output.html
	@if [ ! -f "build/slug.txt" ]; then \
	printf 'Enter a path slug for your curriculum: \"$(TITLE)\".  It should contain only lowercase letters, numbers, and dashes.\n'; \
	printf '\nExample path slugs: python, javascript, advanced-java\n\n'; \
	printf 'Path: '; \
	read SLUG; \
	echo $$SLUG > build/slug.txt; \
	ssh adi-website "mkdir -p /srv/learn/public_html/$$SLUG"; \
	echo "Syncing build/slug.txt with $(REPO)"; \
	git reset HEAD . > tmp.out 2>&1 || cat tmp.out; rm tmp.out; \
	git add build/slug.txt > tmp.out 2>&1 || cat tmp.out; rm tmp.out; \
	git commit -m "Setup Deploy" > tmp.out 2>&1 || cat tmp.out; rm tmp.out; \
	git push -u origin master > tmp.out 2>&1 || cat tmp.out; rm tmp.out; \
	fi

.PHONY:
deploy: output.html build/slug.txt
	@if scp output.html adi-website:/srv/learn/public_html/$(SLUG)/index.html > /dev/null; \
	then echo "Deployed to http://learn.adicu.com/$(SLUG)" ;fi

.PHONY:
clean:
	rm -f build/title.txt build/slug.txt *.html


