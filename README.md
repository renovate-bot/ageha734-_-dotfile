# dotfile

## Get started

### 1. Clone dotfile

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply https://github.com/ageha734/dotfile.git
```

### 2. Setup proto

```bash
bash <(curl -fsSL https://moonrepo.dev/install/proto.sh)
```

### 3. Git Setup

```bash
cat << 'EOF' > ~/.gitconfig.user
[user]
name = ""
email = ""
signingkey = "ssh-ed25519 <>"

[github]
user = ""
EOF
```

## Check Setup

✅ **2025年08月01日** に動作確認済み
