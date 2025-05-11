#!/usr/bin/zsh

#### .zshrc ファイルのバックアップを作成
cp ~/.zshrc ~/.zshrc.bak

#### プロンプトのカスタマイズ
echo 'export PS1="-[%F{green}%D{%a %b %d}-%*]-%F{orange}%n@%F{red}%m%n\n-%F{blue}%~%f%# "' >>~/.zshrc

source ~/.zshrc
echo "Zsh prompt has been customized."
echo "Please restart your terminal to see the changes."
echo "If you want to revert the changes, run the following command:"
echo "cp ~/.zshrc.bak ~/.zshrc"
echo "Then, run 'source ~/.zshrc' to apply the changes."
echo "Done."
