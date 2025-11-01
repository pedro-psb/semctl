# Como trabalhar com Pull Requests

## Requsitos

* Git instalado com configuracao basica
* Git configurado com credenciais do Github (opcional):
    - Isso significa que o git do seu computador sabe que a maquina é confiável
    - Se isso não for configurado, tem que entrar com senha toda hora
    - Existe mais de uma forma de configurar essa autenticação
    - Uma possibilidade: <https://docs.github.com/pt/github-cli/github-cli/quickstart#prerequisites>

## Workflow

### Configurar fork

Essa etapa deve ser feita somente quando for clonar um novo repositório ou começar a contribuir em um novo projeto open-source.

1. Criar fork no github
2. Clonar localmente
3. Configurar 'remotes'
    * `upstream` aponta para "principal" `pedro-psb/semctl`
    * `origin` aponta para fork `USERNAME/semctl`

Exemplo:

```bash
# ver os remotes configurados localmente
$ git clone https://github.com/pedro-psb/semctl
$ git cd semctl

# ver os remotes configurados localmente
$ git remote -v
origin  git@github.com:pedro-psb/semctl.git (fetch)
origin  git@github.com:pedro-psb/semctl.git (push)

# ver os remotes configurados localmente
$ git remote rename origin upstream
$ git remote add origin git@github.com:USERNAME/semctl
```

### Criar um PR

```bash
# saber em qual branch vc está
$ git status
On branch main
Your branch is up to date with 'upstream/main'.
(...)

# atualizar 'main' local com o que está na 'main' do upstream
$ git fetch upstream
$ git rebase upstream/main

# cria e muda para nova branch baseada na atual (main)
$ git checkout -b MYBRANCH

# cria e muda para nova branch baseada na atual (main)
$ git add docs
$ git commit -m "Melhorar documentacao para devs"

# envia os commits locais da branch MYBRANCH para MYBRANCH do 'origin' (seu fork)
# HEAD aqui é equivalente a branch atual, que no caso é  MYBRANCH
$ git push origin HEAD
```
