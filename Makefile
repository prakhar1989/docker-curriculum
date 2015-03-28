.PHONY:
default: output.html

.PHONY:
git:
	@build/_make.sh fix-remotes

build/title.txt: git
	@if [ ! -f "build/title.txt" ]; then \
		build/_make.sh init; \
	fi

output.html: build/title.txt *.md
	@build/_make.sh build

build/slug.txt: output.html
	@if [ ! -f "build/slug.txt" ]; then \
		build/_make.sh pre-deploy; \
	fi

.PHONY:
deploy: output.html build/slug.txt
	@build/_make.sh deploy

.PHONY:
clean:
	rm -f build/title.txt build/slug.txt *.html


