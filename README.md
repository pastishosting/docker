# Installation

```bash
git clone git@github.com:pastishosting/docker.git
cd docker
git submodule update --init --recursive
```

# Développement

## Modification d'un submodule

dans le dossier du submodule :

```bash
git add && git commit && git push
```

à la racine du projet :

```
git submodule foreach "(git checkout master; git pull; cd ..; git add '$path'; git commit -m 'Submodule Sync')"
git push
```

# Exploitation

## Récupération de la dernière version des sources

```bash
git pull && git submodule update
```

## (re)Démarrage des services

```bash
./start
```
