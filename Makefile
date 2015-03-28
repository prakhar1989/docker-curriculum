.PHONY:
default: output.html

.PHONY:
git:
	@build/_make.sh fix-remotes

build/title.txt: git
	@build/_make.sh init; \

output.html: build/title.txt *.md
	@build/_make.sh build

build/slug.txt: output.html
	@build/_make.sh pre-deploy

.PHONY:
deploy: output.html build/slug.txt
	@build/_make.sh deploy

.PHONY:
clean:
	rm -f build/title.txt build/slug.txt *.html


