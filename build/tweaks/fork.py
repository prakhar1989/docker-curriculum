import re
import subprocess
url_regex = re.compile(r'origin\s([^ ]*)')
ssh_regex = re.compile(r'git@github.com:(.*)')
ps = subprocess.Popen(('git', 'remote', '-v'), stdout=subprocess.PIPE)
remotes = ps.communicate()[0]
remote = url_regex.match(remotes).group(1)
if not remote.startswith('http'):
    end = ssh_regex.match(remote).group(1)
    remote = 'https://github.com/' + end
pre_body = ('<a href="%s"><img class="github" '
            'src="https://s3.amazonaws.com/github/ribbons/'
            'forkme_right_darkblue_121621.png" '
            'alt="Fork me on GitHub"></a>') % remote

if __name__ == '__main__':
    print remote
