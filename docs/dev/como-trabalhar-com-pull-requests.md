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

É uma boa prática sempre saber em que branch você está e qual o estado
atual do seu repositório.
Muitas vezes seu terminal ou IDE vai mostrar essas informações, mas
se habitue a fazer:

```bash
$ git status
On branch main
Your branch is up to date with 'upstream/main'.
(...)
```

1. Atualizar 'main' local

    Atualiza branch local com o que está na 'main' do upstream.
    Nesse caso, o rebase aplica os commits que estao em upstream/main
    e que não estão na branch atual. Pode haver um conflito, mas isso
    fica para outra guia.

    ```bash
    git fetch upstream
    git rebase upstream/main
    ```

2. Criar e mudar para nova branch (feature branch)

    A nova branch é baseada no estado da atual (main, no caso).
    Se a branch atual fosse outra, ele "copiaria" dela.

    ```bash
    git checkout -b MYBRANCH
    ```

3. Implementar mudança e comitar

    Esse estado ainda é totalmente local.
    Seu fork e o repositório principal no github não sabem das suas mudanças.

    ```bash
    # ... editar arquivos, entao:
    git add docs
    git commit -m "Melhorar documentacao para devs"
    ```

4. Fazer push para o seu fork

    Envia os commits locais da branch MYBRANCH para MYBRANCH do 'origin' (seu fork).
    HEAD aqui é equivalente a branch atual, que no caso é  MYBRANCH.

    ```bash
    git push origin HEAD
    ````

5. Processo de Review do seu PR

    - 1. Alguem faz um review e pede uma mudança. Volte no passo 3
    - 1. O PR nao foi revisado, mas vc lembrou que precisa fazer mais algo. Volte no passo 3
    - 1. O PR nao foi revisado e vc está com pressa. Cutuque seus colegas
    - 1. Seu PR foi aprovado. Parabéns!


> [!NOTE]
> O passo (1) pode ser feito com `git pull`, que basicamente realiza essas duas
> operações, mas sua branch precisa estar configurada corretamente. Não vou cobrir
> essa abordagem aqui. No geral, recomendo usar a forma explícita que mostro aqui
> para ajudar a entender o que realmente está acontecendo.

## Referências

* Alguns videos de um processo de Pull Request (existem muitos):
    * <https://www.youtube.com/watch?v=U-Y_Mtdyo74>
    * <https://www.youtube.com/watch?v=Du04jBWrv4A>
    * **Crítica**: em ambos os videos eles comitam na main do fork deles.
      Isso pode funcionar em casos simples, mas no geral é uma boa prática sempre criar uma "feature branch" (pr-branch?) baseada na main para trabalhar. 
