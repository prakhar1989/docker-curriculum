TITLE=$(shell cat build/title.txt)
REPO=$(shell python build/tweaks/fork.py | sed -e "s/\//\\\\\//g")
SLUG=$(shell cat build/slug.txt)

default: output.html

git:
	@echo "Make a new repo on GitHub, and find it's SSH / HTTPS url, and paste it below."
	@printf 'Paste GitHub URL: '; \
    read REMOTE; \
	@git remote rename origin upstream > tmp.out || cat tmp.out; rm tmp.out \
    git remote add origin $$REMOTE

build/title.txt: git
	@printf 'Please enter the name of your curriculum: '; \
    read TITLE; \
    echo $$TITLE > build/title.txt; \
    echo "Filling in templates..."; \
    sed -e "s/{{ title }}/$$TITLE/g" -e "s/{{ repo }}/${REPO}/g" "build/template.md" > "$$TITLE.md"; \

output.html: build/title.txt
	@cd build; \
	cp "../$(TITLE).md" .; \
	cp template.css "$(TITLE).css"; \
	python md2html.py "$(TITLE).md" ;\
	mv "$(TITLE).html" ../output.html; \
	rm -f "$(TITLE).css" "$(TITLE).md"; \
	cd ..; \
	echo "Syncing build/title.txt with $(REPO)"; \
	git reset HEAD . > tmp.out || cat tmp.out; rm tmp.out; \
	git add build/title.txt > tmp.out || cat tmp.out; rm tmp.out; \
	git commit -m "Initialize repo" > tmp.out || cat tmp.out; rm tmp.out; \
	git push -u origin master > tmp.out || cat tmp.out; rm tmp.out; \


build/slug.txt: output.html
	@printf 'Enter a path slug for your curriculum: \"$(TITLE)\".  It should contain only lowercase letters, numbers, and dashes.\n'
	@printf '\nExample path slugs: python, javascript, advanced-java\n\n'
	@printf 'Path: '; \
    read SLUG; \
    echo $$SLUG > build/slug.txt; \
    ssh adi-website "mkdir -p /srv/learn/public_html/$$SLUG"; \
    echo "Syncing build/slug.txt with $(REPO)"; \
	git reset HEAD . > tmp.out || cat tmp.out; rm tmp.out; \
	git add build/slug.txt > tmp.out || cat tmp.out; rm tmp.out; \
	git commit -m "Setup Deploy" > tmp.out || cat tmp.out; rm tmp.out; \
	git push -u origin master > tmp.out || cat tmp.out; rm tmp.out; \

.PHONY:
deploy: output.html build/slug.txt
	@if scp output.html adi-website:/srv/learn/public_html/$(SLUG)/index.html > /dev/null; \
	then echo "Deployed to http://learn.adicu.com/$(SLUG)" ;fi

.PHONY:
clean:
	rm -f build/title.txt build/slug.txt *.html


