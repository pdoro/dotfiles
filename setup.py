
import os, sys, re
import pip
import logging
import zipfile
import string
import random
import importlib
import subprocess
from os import path
from datetime import datetime

rand_str = lambda n : ''.join([random.choice(string.ascii_letters + string.digits) for _ in range(n)])

local_bin_dir = '/usr/local/bin'
wd = path.join('/tmp', rand_str(10))

urls = {
    'oh-my-zsh'    : 'https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh',
    'exa'          : 'https://github.com/ogham/exa/releases/download/v0.8.0/exa-linux-x86_64-0.8.0.zip',
    'fzf'          : 'https://github.com/junegunn/fzf.git',
    'powerlevel9k' : 'https://github.com/bhilburn/powerlevel9k.git',
    'enhancd'      : 'https://github.com/b4b4r07/enhancd.git'
}

apt_programs = (
    'htop',                 # http://hisham.hm/htop/
    'the_silver_searcher',  # https://github.com/ggreer/the_silver_searcher
    'nmap',                 # https://www.wikiwand.com/en/Nmap
    'httpie',               # https://httpie.org/
    'jq',                   # https://stedolan.github.io/jq/,
    'tmux',                 # https://github.com/tmux/tmux/wiki
    'tree',
)

pip_programs = (
    'pgcli',  # https://www.pgcli.com/install
    'pipenv',  # https://docs.pipenv.org/
)

def setup_logger(level=logging.INFO):
    logger = logging.getLogger()
    file_handler = logging.StreamHandler()
    stdout_handler = logging.FileHandler()
    formatter = logging.Formatter('%(asctime)s %(name)-12s %(levelname)-8s %(message)s')
    stdout_handler.setFormatter(formatter)
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)
    logger.addHandler(stdout_handler)
    logger.setLevel(level)
    return logger

log = setup_logger()

def main():
    intro()
    prepare_setup()
    setup_working_directory()
    apt_install(*apt_programs)
    pip_install(*pip_programs)
    install_exa()
    """
    setup_oh_my_zsh()
    install_exa()
    install_fzf()
    setup_tmux()
    setup_enhancd()
    """

def setup_oh_my_zsh():
    with Halo(text='Installing oh-my-zsh', spinner='dots') as halo:
        install_sh = download(urls['oh-my-zsh'], halo, 'Installing oh-my-zsh')
        subprocess.call('source', install_sh)
        subprocess.call('chsh /bin/zsh')

def setup_tmux():
    os.rename('.tmux.conf', '~/.tmux.conf')

def setup_enhancd():
    git_clone(urls['enhancd'])
    subprocess.call('source' 'enhancd/init.sh')

def setup_working_directory(working_directory = wd):
    with Halo(text='Preparing working directory', spinner='dots') as halo:
        os.makedirs(wd)
        os.chdir(wd)
        log_and_succeed(halo, 'Instalation process changed to directory {}'.format(wd))

def prepare_setup():
    print('Installing halo', end='')
    pip_install('halo', show_progress = False)
    print('\r✔ Installed halo')
    global Halo, requests, colorama
    Halo = importlib.import_module('halo').Halo
    pip_install('requests', 'colorama')
    requests = importlib.import_module('requests')
    colorama = importlib.import_module('colorama')

def install_exa():
    exa_bin = 'exa-linux-x86_64'
    exa_path = path.join(local_bin_dir, 'exa')
    with Halo(text='Installing exa', spinner='dots') as halo:
        try:
            filename = download(urls['exa'], halo, 'Installing exa')
            halo.text = 'Installing exa : unzipping file'
            with zipfile.ZipFile(filename, 'r') as zip_ref:
                zip_ref.extract(exa_bin, path=local_bin_dir)
            os.rename(path.join(local_bin_dir, exa_bin), exa_path)
            os.chmod(exa_path, 0o755)
            halo.succeed('Installed exa successfully, aliased as ls in ~/.zshrc')
        except Exception as ex:
            halo.error('Error while installing exa - Review setup.log for more details')
            log.error('Error installing exa', ex, exc_info = True)

def install_fzf():
    git_clone(repository=urls['fzf'], directory_dest='~/.fzf')
    subprocess.call('source ~/.fzf/install')

def pip_install(*packages, show_progress = True):
    for package in packages:
        if show_progress:
            halo = Halo(text='Installing ' + package, spinner='dots')
            halo.start()
        log.debug('Installing python package : {}'.format(package))
        pip.main(['install', package, "--quiet"])
        log.debug('Installed python package : {}'.format(package))
        if show_progress:
            halo.succeed('Installed ' + package)

def apt_install(*programs):
    for program in programs:
        log.debug('Installing {} with apt'.format(program))
        # Todo install

def git_clone(repository, directory_dest):
    subprocess.call((
        'git clone depth --1',
        repository,
        directory_dest
    ))

def log_and_succeed(halo, text):
    halo.succeed(text)
    log.info(text)

def download(url, spinner, base_str):
    response = requests.get(url, stream = True)
    # Total size in bytes
    total_size, downloaded = int(response.headers.get('content-length', 0)), 0
    d = response.headers['content-disposition']
    filename = re.findall("filename=(.+)", d)[0]
    with open(filename, 'wb') as fp:
        for data in response.iter_content(32*1024):
            if data:
                downloaded += 32*1024
                spinner.text = base_str + ' : {:.2f}%'.format(downloaded/total_size * 100)
                fp.write(data)

    return filename

def intro():
    intro = """{sep}
             Starting installation script at {}
             This script will do the following steps:
             - Install oh-my-zsh, change shell to zsh and setup .zshrc
             - Install powerlevel9k as zsh theme
             - Install tmux and setup .tmux.conf
             - Install exa
             - Install fzf
             - Install nvim
             - Install enhancd
             - Install pip packages : {}
             - Install apt programs : {}
             {sep}"""\
        .format(datetime.now(), ', '.join(pip_programs), ', '.join(apt_programs), sep = '|{}|'.format(75 * '='))
    print(intro)

if __name__ == '__main__':
    main()
