ADI Curriculum Template
=======================

Make a new curriculum to be deployed on [learn.adicu.com](http://learn.adicu.com).  It's easy to get started writing your own curriculum!

### Getting started
*This assumes that you don't fork this repo.  You can only fork once, after all!*

1. `git clone https://github.com/adicu/learn-template.git`

2. `cd learn-template`

3. `make`.  This will prompt you several times:
    1. First, make a new, different repo on GitHub for your curriculum, and _**don't**_ initialize it with a `README.md` or `.gitignore`.  We'll make these ourselves.  Copy the HTTPS / SSH url, and paste it into the first prompt.
    2. Next, enter the name for your curriculum.  It should be capitalized, with spaces.  Something like "Javascript for Beginners" is good.

    The whole process should look something like this:
    ```
    Make a new repo on GitHub, and find it's SSH / HTTPS url, and paste it below.
    Paste GitHub URL: https://github.com/danrschlosser/learn-javascript.git
    Please enter the name of your curriculum: JavaScript for Beginners
    Filling in templates...
    Converting markdown with Python markdown...
    Syncing build/title.txt with https://github.com/danrschlosser/learn-javascript.git
    ```

4. Edit your newly created markdown file.  The `make` command should have created a `.md` file in the root directory.  Write your curriculum in the file.

### Viewing in Browser

The `make` command also generates `output.html`, which is the HTML version of the markdown file created in the root directory.  You can open this file in your browser to view your project.

### Deploying

_Note: In order to deploy these projects, you need to have SSH access to `adi-website`.  Ask Dan, Nate, Eunice, or Raymond for help setting this up._

Run `make deploy` to deploy your curriculum.  The first time, it will ask for 

#### Solutions

All solutions are available by section in the `solutions/` folder.

#### Using Vagrant

We support running with vagrant!  [Install and setup Vagrant](https://docs.vagrantup.com/v2/installation/index.html), and then:

    $ vagrant up # launches the box
    $ vagrant ssh # ssh into the box
    # You are now in the vagrant instance
    $ cd /vagrant # go to the code
    $ cd <solutions folder> # Ex: cd webdev-solutions/1.3.2\ Dynamic\ Routes
    # Run the solution # Ex: python app.py

#### Directory Structure

##### build/

This is where all the extra files needed to convert from markdown to HTML go. `build.sh` uses the files from this folder.

##### img/ 

All images for the project should be put in here.

##### 
