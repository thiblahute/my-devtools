#!/usr/bin/env python3

import argparse
import configparser
import os
import json
import shutil
import subprocess

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('-C', help="Build directory", default=None, dest='bdir')
    parser.add_argument('-S', help="Source dir", default=os.curdir, dest='sdir')
    parser.add_argument('-r', '--remote', help="New remote base URI", default=None, dest='remote')
    parser.add_argument('-pr', '--push-remote', help="New remote base URI for pushing", default=None, dest='push_remote')
    parser.add_argument('-b', '--branch', help="New branch to use", default=None, dest='branch')
    options = parser.parse_args()

    mesonintrospect = shutil.which('mesonintrospect') or shutil.which('mesonintrospect.py')
    cmd = [mesonintrospect, '--projectinfo']
    if options.bdir:
        cmd += [options.bdir]
    subprojects = json.loads(subprocess.check_output(cmd))['subprojects']
    for proj in subprojects:
        wrapfile = os.path.join(options.sdir, 'subprojects', proj['name'] + '.wrap')
        wrap = configparser.ConfigParser()
        wrap.read(wrapfile)

        if not options.remote:
            remote = wrap['wrap-git']['url']
        else:
            remote = options.remote + proj['name']

        if not options.branch:
            branch = wrap['wrap-git']['revision']
        else:
            branch = options.branch

        if "refs/heads/" in subprocess.check_output(["git", "ls-remote", "--heads", remote, branch]).decode():
            wrap['wrap-git']['revision'] = branch
            wrap['wrap-git']['url'] = remote
            pushurl = wrap['wrap-git'].get('push-url')
            if pushurl and options.push_remote:
                wrap['wrap-git']['push-url'] = options.push_remote + '/' + proj['name']
            print("Setting up %s" % (proj['name']))
            with open(wrapfile, 'w') as configfile:
                wrap.write(configfile)
        else:
            print("ERROR: %s remote %s doesn't have a branch %s" % (proj['name'],
                                                                    remote,
                                                                    branch))


