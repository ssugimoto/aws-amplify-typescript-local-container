

## see
- VSCode Remote Container は https://github.com/toricls/aws-amplify-sns-workshop-in-vscode をカスタマイズしています.
    - awsディレクトリ作成
    - sshディレクトリ作成
    - Node.js, amplify cli version up.

## Usage for windows
1. Windows10, WSL2 enabled
1. Install Docker Desktop for Windows / Mnikube, Podman, lima
1. Install VSCode. and VSCode plugin( Remote-Containers, Remote-WSL , and more）
1. VS Code Open folder , PATH existing .devcontainer dir(exists file devcontainer.json).

### Docker 用の設定 for Winodows

- `%UserProfile%¥.wslconfig` ファイルを作成し、メモリとスレッドを設定する。

```
[wsl2]
memory=6GB # Limits VM memory in WSL 2 to 6 GB max 60%
processors=8 # Makes the WSL 2 VM use two virtual processors ,max 80%
```
- 設定したらDocker Desktopを再起動するか、OSを再起動する


## コンテナ内のユーザー

- 以前は、root でしたが、dockerベースイメージ変更され、 node ユーザー がデフォルトになっているため、nodeユーザーを使うようにしています
- devcontainer.json 内の「"remoteUser": "node"」を root にすると、rootになります
- remoteUserをrootにする場合
     - devcontainer.json 内のmountsをrootに合わせて target ディレクトリを変更します（ /home/node/  -> /root/ ）
     - Dockerfile での RUN を su node をやめて、 root実行されるように変更します（  RUN su node コマンド ->  RUN コマンド）

## VSCode
- install Visual Studio Code
    - https://code.visualstudio.com/download
- 拡張機能を入れる
    - Visual Studio Code with the [`Remote - Containers` プレビュー版](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) 
    - `Remote - wsl`(ms-vscode-remote.remote-wsl プレビュー版)
    - `Docker` (ms-azuretools.vscode-docker)
    - Git操作系（ `Git Lens` , `Git Graph`等）

### VS Code Remote Development

### リモートコンテナを使う
1. このリポジトリをGit clone または zipダウンロードする
1. VSCodeから File -> OpenFolder -> this project folder.  `.devcontainer` があるフォルダを開く
    ```
        C:\xxx\aws-amplify-typescript-local-container
            │
            ├─.devcontainer
            │      devcontainer.json
            │      Dockerfile
            │
            ├─aws
            │      config
            │      credentials
            │
            └─ssh
                    chmod.txt
                    config
                    github_rsa
                    github_rsa.pub
                    known_hosts        
1. 初回であればコンテナビルドが自動実行される
    - リビルドするとコンテナ内のファイルが消える（なくなる）ので注意

- 上記の 手順で単にエクスプローラー相当で開かれる場合は、VS Code メニュー等で「Reopen In Container」で開く


#### リモートコンテナ内の説明
- VS Codeの拡張機能のremote explorer で、「Open Folder In container」でVSCodeをIDEにしてファイルの編集ができる 
- terminal で入って、ホスト側をマウントしている場所の表示
    ```
    cd /hostdir
    ```
- `/workspaces` はホスト側からは見られない。Linuxベースで動かせる領域なので、npm,yarn等の操作が高速になる。このディレクトリ利用を推奨する。

- `/hostdir` のディレクトリ下で作業する場合は、リモートコンテナ内でGit操作しても良いし、ホスト側でGit操作しても良い。ただし、hostdirはディスクアクセスが非常に遅いのでプログラムを配置すると実用に耐えられない。

- コンテナ内でのみ使う場合（ホスト側の共有マウントの場所を使わない）
    ```sh
    cd /workspaces
    git clone git@github.com:xxx/xxx.git

    ```
- ホスト側と連携して使う場合
    - リモートコンテナのリポジトリ（devcontainerのリポジトリ）はcloneしていないこと（zipダウンロードしたものを使っていること、または .gitディレクトリを消せば良い）
    ```sh
    cd /hostdir
    mkdir xxx
    cd xxx
    git clone git@github.com:xxx/xxx.git
    ```

### コンテナ内からGitリポジトリを使う
- コンテナ内の `/root/.ssh`は Windows（ホスト）側のディレクトリをマウントしている
- sshのディレクトリは、初回マウント時にパーミッションが変わってしまうので、  `sudo chmod 600 /root/.ssh/*`  が必要な場合がある。Linux側でパーミッション変更した後にwindows側でファイル変更すると、パーミッションが戻ってしまう。
- 一例
    ```sh
    $ cd /hostdir
    $ find ./ssh/
    ./ssh/
    ./ssh/chmod.txt
    ./ssh/config
    ./ssh/github_rsa
    ./ssh/github_rsa.pub
    ./ssh/known_hosts

    $ cat ./ssh/config
    Host github.com
        User git
        IdentityFile ~/.ssh/github_rsa
    ```

### コンテナ内でAWSのクレデンシャルを使う
- コンテナ内の `/root.aws/` はWindows（ホスト）側のディレクトリをマウントしているので、AWSアカウント（案件）ごとに切替えを意識せずに利用できる
    ```
    $ cd /hostdir
    $ ls -l aws
    ```

    `/hostdir/aws` の場所は、言い換えると、ディレクトリ `.devcontainer` と同じ階層に ディレクトリ`aws` がある構成。
    
    `/hostdir/aws`に、Windows ホスト側にあるクレデンシャル`%UserProfile%\.aws\credentials と config` を 置くことでAWSアカウントごとやアプリケーションごとのIAMユーザー・profile 切替えは不要になる
    
    - 以下例
    
    ```
    .
        ├─.devcontainer
        ├─aws
        │      config
        │      credentials
    ```

## Link
### VS Code 拡張機能・プラグイン
#### リモートコンテナ系
- [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
- [Remote - WSL](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl#:~:text=The%20Remote%20%2D%20WSL%20extension%20lets,as%20you%20would%20from%20Windows.)
- [VS Code Remote Development](https://code.visualstudio.com/docs/remote/remote-overview)
 
#### Amplify 系
- [AWS Amplify API]
- [AppSync Utils]
- [GraphQL for VSCode]
#### ブラウザ系
- [Debugger for Chrome]
#### Git系
- [Git Graph]
- [GitLens]

