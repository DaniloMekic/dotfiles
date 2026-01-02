# Setup
```shell
$ chmod +x bootstrap
$ ./bootstrap --help
```

# Git Submodules
- `Neovim` submodule is pointing to a repository located at [DaniloMekic/nvim-config](https://github.com/DaniloMekic/nvim-config).  

## Cloning the Repository
In order to clone this repo, submodules need to be initialized and updated:
```
# Set .gitmodules file
$ git submodule set-url Neovim git@github.com:DaniloMekic/nvim-config.git

# Read .gitmodules file and copy the configuration into the local .git/config file
$ git submodule init

# Fetch and check out the referenced commit
$ git submodule update
```

`git submodule init` registers submodules listed in `.gitmodules`, setting up the mapping to the submodule's remote URL.  
`git submodule update` fetches and checks out specific commit that superproject references, downloading it from remote repository.

This can also be achieved in one step:
```
$ git clone --recurse-submodules <remote-repo.git>
```
After cloning and updating, check submodule status with:
```
$ git submodule status
```

## Updating Submodule
### 1. Stage and commit changes in submodule:
```
$ git add <files>
$ git commit -m "<message>"
```

### 2. Update superproject to reference new commit:
If local repo is behind remote one, fetch the latest commit:
```
$ git submodule update --remote
```

Update reference and commit the updated reference in the superproject:
```
$ git add <subproject>
$ git commit -m "<message>"
```

Confirm that the superproject is tracking the correct submodule commit:
```
$ git ls-tree HEAD <subproject>
```
