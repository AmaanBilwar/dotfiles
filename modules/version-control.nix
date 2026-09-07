{ ... }:

{
  home.file.".gitconfig".text = ''
    [credential "https://github.com"]
    	helper =
    	helper = !/usr/bin/gh auth git-credential
    [credential "https://gist.github.com"]
    	helper =
    	helper = !/usr/bin/gh auth git-credential
    [user]
    	email = bilwarad@mail.uc.edu
    	name = Amaan Bilwar
    [init]
    	defaultBranch = main
    [core]
    	editor = nvim
  '';

  home.file.".config/gh/config.yml".text = ''
    version: 1
    git_protocol: https
    editor:
    prompt: enabled
    pager:
    aliases:
        co: pr checkout
    http_unix_socket:
    browser:
  '';

  home.file.".config/jj/config.toml".text = ''
    #:schema https://docs.jj-vcs.dev/latest/config-schema.json

    [user]
    name = "Amaan Bilwar"
    email = "bilwarad@mail.uc.edu"

    [ui]
    default-command = "log"
    editor = "nvim"
    diff-editor = ":builtin"

    [revset-aliases]
    'closest_bookmark(to)' = 'heads(::to & bookmarks())'
    'closest_pushable(to)' = 'heads(::to & mutable() & ~description(exact:"") & (~empty() | merges()))'

    [aliases]
    tug = ["bookmark", "move", "--from", "closest_bookmark(@)", "--to", "closest_pushable(@)"]
  '';
}
