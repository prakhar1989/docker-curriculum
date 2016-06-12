# -*- encoding: UTF-8 -*-

# Adapted from Sublime Text 2/3 Markdown Preview by revolunet
# https://github.com/revolunet/sublimetext-markdown-preview

import os
import sys
import traceback
import tempfile
import re
import json


def is_ST3():
    ''' check if ST3 based on python version '''
    version = sys.version_info
    if isinstance(version, tuple):
        version = version[0]
    elif getattr(version, 'major', None):
        version = version.major
    return (version >= 3)

if is_ST3():
    from . import markdown
    from urllib.request import urlopen
    from urllib.error import HTTPError, URLError

    def Request(url, data, headers):
        ''' Adapter for urllib2 used in ST2 '''
        import urllib.request
        return urllib.request.Request(url, data=data, headers=headers, method='POST')

else:
    import markdown
    from urllib2 import Request, urlopen, HTTPError, URLError

_CANNOT_CONVERT = u'cannot convert markdown'


def save_utf8(filename, text):
    if is_ST3():
        f = open(filename, 'w', encoding='utf-8')
        f.write(text)
        f.close()
    else: # 2.x
        f = open(filename, 'w')
        f.write(text.encode('utf-8'))
        f.close()

def load_utf8(filename):
    if is_ST3():
        return open(filename, 'r', encoding='utf-8').read()
    else: # 2.x
        return open(filename, 'r').read().decode('utf-8')


def new_scratch_view(window, text):
    ''' create a new scratch view and paste text content
        return the new view
    '''

    new_view = window.new_file()
    new_view.set_scratch(True)
    if is_ST3():
        new_view.run_command('append', {
            'characters': text,
        })
    else: # 2.x
        new_edit = new_view.begin_edit()
        new_view.insert(new_edit, 0, text)
        new_view.end_edit(new_edit)
    return new_view


class MarkdownCompiler():
    ''' Do the markdown converting '''

    def isurl(self, css_name):
        match = re.match(r'https?://', css_name)
        if match:
            return True
        return False

    def get_search_path_css(self, parser):
        css_name = 'default'
        if css_name == 'default':
            css_name = 'github.css' if parser == 'github' else 'markdown.css'

        # Try the local folder for css file.
        if self.mdfile is not None:
            css_path = os.path.join(os.path.dirname(os.path.abspath(self.mdfile.name)), css_name)
            if os.path.isfile(css_path):
                return u"<style>%s</style>" % load_utf8(css_path)

        # Try the build-in css files.
        return u"<style>%s</style>" % open(css_name).read()

    def get_override_css(self):
        ''' handls allow_css_overrides setting. '''

        filename = os.path.abspath(self.mdfile.name)
        filetypes = [".md", ".mdown", ".markdown"]

        if filename and filetypes:
            for filetype in filetypes:
                if filename.endswith(filetype):
                    css_filename = filename.rpartition(filetype)[0] + '.css'
                    if (os.path.isfile(css_filename)):
                        return u"<style>%s</style>" % load_utf8(css_filename)
        return ''

    def get_stylesheet(self, parser):
        ''' return the correct CSS file based on parser and settings '''
        return self.get_search_path_css(parser) + self.get_override_css()

    def get_javascript(self):
        js_files = None
        scripts = ''

        if js_files is not None:
            # Ensure string values become a list.
            if isinstance(js_files, str) or isinstance(js_files, unicode):
                js_files = [js_files]
            # Only load scripts if we have a list.
            if isinstance(js_files, list):
                for js_file in js_files:
                    if os.path.isabs(js_file):
                        # Load the script inline to avoid cross-origin.
                        scripts += u"<script>%s</script>" % load_utf8(js_file)
                    else:
                        scripts += u"<script type='text/javascript' src='%s'></script>" % js_file
        return scripts

    def get_highlight(self):
        ''' return the Highlight.js and css if enabled '''

        highlight = ''
        highlight += "<style>%s</style>" % open('highlight.css').read()
        highlight += "<script>%s</script>" % open('highlight.js').read()
        highlight += "<script>hljs.initHighlightingOnLoad();</script>"
        return highlight


    def get_contents(self, wholefile=False):
        ''' Get contents or selection from view and optionally strip the YAML front matter '''
        contents = self.mdfile.read()
        if not wholefile:
            # use selection if any
            selection = self.view.substr(self.view.sel()[0])
            if selection.strip() != '':
                contents = selection
        return unicode(contents.decode("utf-8", "replace"))

    def postprocessor(self, html):
        ''' fix relative paths in images, scripts, and links for the internal parser '''
        def tag_fix(match):
            tag, src = match.groups()
            filename = os.path.abspath(self.mdfile.name)
            if filename:
                if not src.startswith(('file://', 'https://', 'http://', '/', '#')):
                    abs_path = u'file://%s/%s' % (os.path.dirname(filename), src)
                    tag = tag.replace(src, abs_path)
            return tag
        #RE_SOURCES = re.compile("""(?P<tag><(?:img|script|a)[^>]+(?:src|href)=["'](?P<src>[^"']+)[^>]*>)""")
        #html = RE_SOURCES.sub(tag_fix, html)
        return html

    def curl_convert(self, data):
        try:
            import subprocess

            # It looks like the text does NOT need to be escaped and
            # surrounded with double quotes.
            # Tested in ubuntu 13.10, python 2.7.5+
            shell_safe_json = data.decode('utf-8')
            curl_args = [
                'curl',
                '-H',
                'Content-Type: application/json',
                '-d',
                shell_safe_json,
                'https://api.github.com/markdown'
            ]

            github_oauth_token = None
            if github_oauth_token:
                curl_args[1:1] = [
                    '-u',
                    github_oauth_token
                ]

            markdown_html = subprocess.Popen(curl_args, stdout=subprocess.PIPE).communicate()[0].decode('utf-8')
            return markdown_html
        except subprocess.CalledProcessError as e:
            print e
            print('cannot use github API to convert markdown. SSL is not included in your Python installation. And using curl didn\'t work either')
        return None

    def convert_markdown(self, markdown_text, parser):
        ''' convert input markdown to HTML, with github or builtin parser '''

        markdown_html = _CANNOT_CONVERT
        if parser == 'github':
            github_oauth_token = None

            # use the github API
            print('Converting markdown with github API...')
            github_mode = "markdown"
            data = {
                "text": markdown_text,
                "mode": github_mode
            }
            data = json.dumps(data).encode('utf-8')

            try:
                headers = {
                    'Content-Type': 'application/json'
                }
                if github_oauth_token:
                    headers['Authorization'] = "token %s" % github_oauth_token
                url = "https://api.github.com/markdown"
                print(url)
                request = Request(url, data, headers)
                markdown_html = urlopen(request).read().decode('utf-8')
            except HTTPError:
                e = sys.exc_info()[1]
                if e.code == 401:
                    print('github API auth failed. Please check your OAuth token.')
                else:
                    print('github API responded in an unfashion way :/')
            except URLError:
                # Maybe this is a Linux-install of ST which doesn't bundle with SSL support
                # So let's try wrapping curl instead
                markdown_html = self.curl_convert(data)
            except:
                e = sys.exc_info()[1]
                print(e)
                traceback.print_exc()
                print('cannot use github API to convert markdown. Please check your settings.')
            else:
                print('converted markdown with github API successfully')

        elif parser == 'markdown2':
            # convert the markdown
            enabled_extras = ['footnotes', 'fenced-code-blocks', 'cuddled-lists', 'code-friendly']
            markdown_html = markdown2.markdown(markdown_text, extras=enabled_extras)
            toc_html = markdown_html.toc_html
            if toc_html:
                toc_markers = ['[toc]', '[TOC]', '<!--TOC-->']
                for marker in toc_markers:
                    markdown_html = markdown_html.replace(marker, toc_html)

        else:
            print('Converting markdown with Python markdown...')
            markdown_html = markdown.markdown(markdown_text, extensions=['extra', 'toc'])

        markdown_html = self.postprocessor(markdown_html)
        return markdown_html

    def get_title(self):
        title = "Docker for Beginners" # self.mdfile.name
        if not title:
            fn = self.mdfile.name
            title = 'untitled' if not fn else os.path.splitext(os.path.basename(fn))[0]
        title.replace('.md', '')
        return '<title>%s</title>' % title

    def modify_body(self, body):
        ''' make ammendments to the body before adding it to the html'''
        from tweaks import fork
        from tweaks import analytics
        body = fork.pre_body + body + analytics.script
        return body

    def get_header(self):
        '''returns header for the generated file'''
        with open("header.html") as f:
            return f.read()

    def run(self, mdfile, parser, wholefile=False): 
        ''' return full html and body html for view. '''
        self.mdfile = mdfile
        contents = self.get_contents(wholefile)
        body = self.convert_markdown(contents, parser)
        html = self.get_header()
        html += self.get_stylesheet(parser)
        html += self.get_javascript()
        html += self.get_highlight()
        html += self.get_title()
        html += '</head><body>'
        html += self.modify_body(body)
        html += '</body>'
        html += '</html>'
        return html, body


compiler = MarkdownCompiler()

def main():
    mdfilename = sys.argv[1]

    with open(mdfilename) as mdfile:
        html, body = compiler.run(mdfile, 'markdown', True)

    htmlfile = os.path.splitext(os.path.abspath(mdfile.name))[0]+'.html'
    save_utf8(htmlfile, html)

if __name__ == "__main__":
    main()
