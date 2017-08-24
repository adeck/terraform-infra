#!/usr/bin/env python
#
# This is ugly spaghetti code. Read at own peril.
# I am truly sorry.
#

import sys
import os
from os import listdir
from os.path import isfile, isdir, islink

from jinja2 import Template, Environment, FileSystemLoader
import shutil

import yaml
import click

jinja_dir = 'jinjas'
staging_dir = 'staging'
output_dir = 'terraform'
state_files = ['terraform.tfstate', 'terraform.tfstate.backup']

def combine_files(path):
    result = ""
    if isfile(path) and path.endswith('.tf'):
        with open(path, 'r') as f:
            result = f.read()
    elif isdir(path):
        result = '\n'.join((combine_files('%s/%s' % (path, f)) for f in listdir(path)))
    return result

def load(filename):
    with open(filename, 'r') as f:
        return yaml.safe_load(f.read())

def cleanup():
    if isdir(output_dir):
        shutil.rmtree(output_dir)
    if isdir(staging_dir):
        shutil.rmtree(staging_dir)

def setup(env_dir):
    os.mkdir(output_dir)
    for fname in state_files:
        s = lambda f: os.path.join(f, fname)
        os.symlink(s(os.path.relpath(env_dir, output_dir)), s(output_dir))
    os.mkdir(staging_dir)
    relpath = os.path.relpath(jinja_dir, output_dir)
    os.symlink(relpath + '/files', output_dir + '/files')

def create_tf_templates(data):
    components_dir = '%s/components' % jinja_dir
    # TODO -- change this so it can use the FileSystemLoader to handle macros
    # First, we combine all the files for the components...
    for component in listdir(components_dir):
        path = '%s/%s' % (components_dir, component)
        if isdir(path):
            content = combine_files(path)
            with open('%s/%s.tf' % (staging_dir, component), 'w') as f:
                f.write(content)
    relpath = os.path.relpath(jinja_dir, staging_dir)
    os.symlink(relpath + '/macros', staging_dir + '/macros')
    # ...then we compile those resources.
    jinja_env = Environment(loader=FileSystemLoader(staging_dir))
    for component in listdir(staging_dir):
        if component.endswith('.tf'):
            content = jinja_env.get_template(component).render(data)
            with open('%s/%s' % (output_dir, component), 'w') as f:
                f.write(content)

@click.command()
@click.argument('env_dir')
def build(env_dir):
    cleanup()
    setup(env_dir)
    data = load('%s/main.yml' % env_dir)
    create_tf_templates(data['terraform'])

if __name__ == '__main__':
    build()

