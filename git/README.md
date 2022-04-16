# Git

[Git Overview](https://git-scm.com/book/en/v2)

## git rebasing

[Rebasing](https://git-scm.com/book/en/v2/Git-Branching-Rebasing)

```shell
git config --global pull.rebase true
git config --global branch.autoSetupRebase always
```

## Troubleshooting

1. Issue with pushing large files(more than 100GB) through git

```shell
# Remove file using filter-branch
git filter-branch --tree-filter 'rm -rf your/file/path/task.txt' HEAD

# After that push the code
git push origin master -f
```



